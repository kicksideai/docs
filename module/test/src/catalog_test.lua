local test = require("test")
local catalog = require("catalog")
local registry = require("registry")
local fs = require("fs")
local funcs = require("funcs")
local security = require("security")
local json = require("json")
local sql = require("sql")

local function repository_pages()
    local storage = assert(fs.get("app:repository"))
    local paths = {"index.md"}
    for _, section in ipairs({"getting-started", "using", "building-modules", "reference"}) do
        local iter, state = storage:readdir(section)
        if not iter then error(state) end
        for item in iter, state do
            if item.name:match("%.md$") then paths[#paths + 1] = section .. "/" .. item.name end
        end
    end
    table.sort(paths)
    return storage, paths
end

local function member(include_tools)
    local entries = assert(registry.find({[".kind"] = "security.policy"}))
    local policies = {}
    for _, entry in ipairs(entries) do
        for _, group in ipairs(entry.data.groups or {}) do
            if tostring(group) == "app:members" and
                (include_tools ~= false or not tostring(entry.id):match(":tool_")) then
                policies[#policies + 1] = assert(security.policy(tostring(entry.id)))
            end
        end
    end
    test.eq(#policies, include_tools == false and 3 or 5)
    return funcs.new():with_actor(security.new_actor("docs-member", {}))
        :with_scope(assert(security.new_scope(policies)))
end

local function matches_schema(value, schema)
    if schema.type == "object" or schema.type == "array" then
        test.eq(type(value), "table")
    elseif schema.type == "integer" then
        test.eq(type(value), "number")
        test.eq(value, math.floor(value))
    else
        test.eq(type(value), schema.type)
    end
    if schema.const ~= nil then test.eq(value, schema.const) end
    if schema.minimum ~= nil then test.is_true(value >= schema.minimum) end
    if schema.type == "object" then
        for _, key in ipairs(schema.required or {}) do test.not_nil(value[key], key) end
        for key, child in pairs(value) do
            local property = schema.properties and schema.properties[key]
            if property then matches_schema(child, property)
            elseif schema.additionalProperties == false then test.fail("unexpected property: " .. key)
            elseif type(schema.additionalProperties) == "table" then matches_schema(child, schema.additionalProperties) end
        end
    elseif schema.type == "array" then
        for _, child in ipairs(value) do matches_schema(child, schema.items) end
    end
end

local function define_tests()
    test.describe("documentation catalog", function()
        test.it("uses the configured database profile", function()
            local entry = assert(registry.get("app:db"))
            if entry.kind == "db.sql.sqlite" then
                test.eq(entry.data.file, ":memory:")
            else
                test.eq(entry.kind, "db.sql.postgres")
            end
            local db = assert(sql.get("app:db"))
            local rows, err = db:query("SELECT 1 AS value")
            local _, release_err = db:release()
            test.is_nil(err)
            test.is_nil(release_err)
            test.eq(rows[1].value, 1)
        end)

        test.it("lists every repository page with its metadata and section counts", function()
            local storage, paths = repository_pages()
            local result, err = catalog.list({limit = 100})
            test.is_nil(err)
            test.eq(result.count, #paths + 1)
            local rows, counts = {}, {}
            for _, row in ipairs(result.pages) do
                rows[row.path] = row
                counts[row.section] = (counts[row.section] or 0) + 1
            end
            for _, path in ipairs(paths) do
                local bytes = assert(storage:readfile(path))
                local row = rows[path]
                test.not_nil(row, path)
                test.eq(row.title, bytes:match("^# ([^\r\n]+)"), path)
                local section = path:match("^([^/]+)/") or ""
                test.eq(row.section, section, path)
                local kind = "guide"
                if section == "building-modules" then kind = "handbook" end
                if section == "reference" then kind = "reference" end
                test.eq(row.document_kind, kind, path)
                test.eq(row.status, "stable", path)
            end
            for section, count in pairs(counts) do test.eq(result.sections[section], count, section) end
            for section, count in pairs(result.sections) do test.eq(count, counts[section], section) end
            test.not_nil(rows["extensions/example.md"])
        end)

        test.it("filters sections and retains the complete sections summary", function()
            local all = assert(catalog.list({limit = 100}))
            for section, count in pairs(all.sections) do
                local result, err = catalog.list({section = section, limit = 100})
                test.is_nil(err)
                test.eq(result.count, count)
                for _, row in ipairs(result.pages) do test.eq(row.section, section) end
                for key, total in pairs(all.sections) do test.eq(result.sections[key], total) end
            end
            local empty = assert(catalog.list({section = "absent"}))
            test.eq(empty.count, 0)
            test.eq(#empty.pages, 0)
        end)

        test.it("pages by exact path without repeats or omissions", function()
            local all = assert(catalog.list({limit = 100}))
            local seen, cursor = {}, nil
            repeat
                local result, err = catalog.list({limit = 7, cursor = cursor})
                test.is_nil(err)
                test.eq(result.count, #result.pages)
                test.is_true(#result.pages <= 7)
                for _, row in ipairs(result.pages) do
                    seen[#seen + 1] = row.path
                    if #seen > 1 then test.is_true(seen[#seen - 1] < row.path) end
                end
                for section, count in pairs(all.sections) do test.eq(result.sections[section], count) end
                cursor = result.next_cursor
                if cursor then test.eq(cursor, result.pages[#result.pages].path) end
            until cursor == nil
            test.eq(#seen, #all.pages)
            for index, row in ipairs(all.pages) do test.eq(seen[index], row.path) end
        end)

        test.it("reads exact Markdown bytes and titles in every section", function()
            local storage = assert(fs.get("app:repository"))
            for _, path in ipairs({"index.md", "getting-started/index.md", "using/index.md", "building-modules/index.md", "reference/index.md"}) do
                local bytes = assert(storage:readfile(path))
                local result, err = catalog.read({page = path})
                test.is_nil(err)
                test.eq(result.page, path)
                test.eq(result.content, bytes, path)
                test.eq(result.title, bytes:match("^# ([^\r\n]+)"))
                test.eq(result.section, path:match("^([^/]+)/") or "")
            end
        end)

        test.it("returns typed errors for invalid inputs and unknown exact paths", function()
            for _, args in ipairs({{page = 3}, {}, {page = false}}) do
                local result, err = catalog.read(args)
                test.is_nil(result)
                test.is_true(errors.is(err, errors.INVALID))
            end
            for _, page in ipairs({"missing.md", "../README.md", "README.md", ""}) do
                local result, err = catalog.read({page = page})
                test.is_nil(result)
                test.is_true(errors.is(err, errors.NOT_FOUND))
            end
            for _, args in ipairs({{limit = 0}, {limit = 101}, {cursor = 3}, {section = 3}}) do
                local result, err = catalog.list(args)
                test.is_nil(result)
                test.is_true(errors.is(err, errors.INVALID))
            end
        end)

        test.it("calls both tools as a member and matches their declared result shapes", function()
            local exec = member()
            local listed, err = exec:call("kickside.docs.traits:list_docs_tool", {limit = 100})
            test.is_nil(err)
            test.eq(listed.success, true)
            test.eq(listed.count, #listed.pages)
            test.eq(listed.sections.extensions, 1)
            local first = assert(exec:call("kickside.docs.traits:list_docs_tool", {limit = 2}))
            local second = assert(exec:call("kickside.docs.traits:list_docs_tool", {limit = 2, cursor = first.next_cursor}))
            test.eq(second.sections.extensions, 1)
            test.is_true(second.pages[1].path > first.pages[2].path)
            local found = false
            for _, row in ipairs(listed.pages) do
                if row.path == "extensions/example.md" then found = true end
            end
            test.is_true(found)
            local read, read_err = exec:call("kickside.docs.traits:read_doc_tool", {page = "using/index.md"})
            test.is_nil(read_err)
            test.eq(read.success, true)
            test.eq(read.page, "using/index.md")
            test.eq(read.section, "using")
            test.eq(read.content, assert(fs.get("app:repository")):readfile(read.page))
            for name, result in pairs({list_docs_tool = listed, read_doc_tool = read}) do
                local entry = assert(registry.get("kickside.docs.traits:" .. name))
                local schema = assert(json.decode(entry.meta.output_schema))
                matches_schema(result, schema)
                test.eq(entry.meta.public, true)
                test.eq(entry.meta.mcp.required_scopes[1], "state.read")
                test.eq(#entry.meta.mcp.required_scopes, 1)
            end
            for _, args in ipairs({{page = 3}, {page = "absent.md"}}) do
                local value, call_err = exec:call("kickside.docs.traits:read_doc_tool", args)
                test.is_nil(value)
                test.is_true(errors.is(call_err, type(args.page) == "string" and errors.NOT_FOUND or errors.INVALID))
            end
        end)
        test.it("requires tool access in addition to module access", function()
            local exec = member(false)
            for _, name in ipairs({"list_docs_tool", "read_doc_tool"}) do
                local value, err = exec:call("kickside.docs.traits:" .. name, {page = "index.md"})
                test.is_nil(value)
                test.is_true(errors.is(err, errors.PERMISSION_DENIED))
            end
        end)

    end)
end
return {run = test.run_cases(define_tests)}
