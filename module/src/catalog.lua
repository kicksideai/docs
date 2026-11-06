local registry = require("registry")
local keyset = require("keyset")

type Map = { [string]: any }

local M = {}

local function pages(): ({ any }?, error?)
    local entries, err = registry.find({
        [".kind"] = "registry.entry",
        ["meta.type"] = "wippy.documentation.page",
    })
    if err then return nil, err end

    local found: { any } = {}
    for _, entry in ipairs(entries) do
        local data: any = (entry :: Map).data
        if type(data.path) == "string" and data.path ~= "" and
            type(data.content) == "string" and data.content ~= "" then
            found[#found + 1] = data
        end
    end
    table.sort(found, function(left: any, right: any): boolean return left.path < right.path end)
    return found, nil
end

local function section_of(path: string): string
    return path:match("^([^/]+)/") or ""
end

function M.list(args: any): (Map?, error?)
    local input: Map = type(args) == "table" and (args :: Map) or {}
    if input.section ~= nil and type(input.section) ~= "string" then
        return nil, errors.new({kind = errors.INVALID, message = "section must be a string"})
    end
    local limit, cursor, page_err = keyset.args(input)
    if page_err then return nil, page_err end
    local found, err = pages()
    if err then return nil, err end

    local sections: Map = {}
    local rows: { any } = {}
    for _, page in ipairs(found) do
        local section = section_of(page.path)
        sections[section] = (sections[section] or 0) + 1
        if input.section == nil or input.section == section then
            rows[#rows + 1] = {
                path = page.path,
                title = page.title,
                section = section,
                document_kind = page.document_kind,
                status = page.status,
            }
        end
    end
    local selected, next_cursor = keyset.page(rows, keyset.field("path"), limit :: integer, cursor)
    return {success = true, count = #selected, pages = selected, sections = sections, next_cursor = next_cursor}, nil
end

function M.read(args: any): (Map?, error?)
    local input: Map = type(args) == "table" and (args :: Map) or {}
    if type(input.page) ~= "string" then
        return nil, errors.new({kind = errors.INVALID, message = "page must be a string"})
    end
    local found, err = pages()
    if err then return nil, err end
    for _, page in ipairs(found) do
        if page.path == input.page then
            return {
                success = true,
                page = page.path,
                title = page.title,
                section = section_of(page.path),
                content = page.content,
            }, nil
        end
    end
    return nil, errors.new({kind = errors.NOT_FOUND, message = "documentation page does not exist: " .. input.page})
end

return M
