local test = require("test")
local registry = require("registry")
local security = require("security")
return {run = test.run_cases(function()
    test.describe("documentation member policies", function()
        test.it("keeps declared module and runtime grants identical", function()
            local public = assert(registry.get("kickside.docs.security:module_access"))
            local private = assert(registry.get(public.meta.includes[1]))
            test.eq(public.meta.intent, "module_access")
            test.eq(public.meta.surface, "kickside.docs")
            test.eq(private.meta.private, true)
            test.eq(#public.data.policy.resources, 3)
            test.eq(#public.data.policy.resources, #private.data.policy.resources)
            test.eq(#public.data.policy.actions, #private.data.policy.actions)
            local actor = security.new_actor("policy-member", {})
            local declared = assert(security.policy(tostring(public.id)))
            local runtime = assert(security.policy(tostring(private.id)))
            for index, resource in ipairs(public.data.policy.resources) do
                test.eq(resource, private.data.policy.resources[index])
            end
            for index, action in ipairs(public.data.policy.actions) do
                test.eq(action, private.data.policy.actions[index])
                for _, id in ipairs({"kickside.docs:catalog", "kickside.docs:pages.index", "kickside.docs.traits:docs_reader", "kickside.docs.security:module_access", "unrelated:entry"}) do
                    test.eq(declared:evaluate(actor, action, id), runtime:evaluate(actor, action, id))
                    test.eq(declared:evaluate(actor, action, id), id == "unrelated:entry" and "undefined" or "allow")
                end
            end
        end)
        test.it("admits exactly the two tool ids through tool access", function()
            local entry = assert(registry.get("kickside.docs.security:tool_access"))
            test.eq(entry.meta.intent, "tool_access")
            test.eq(#entry.data.policy.resources, 2)
            local policy = assert(security.policy(tostring(entry.id)))
            local actor = security.new_actor("tool-member", {})
            local expected = {["kickside.docs.traits:list_docs_tool"] = true, ["kickside.docs.traits:read_doc_tool"] = true}
            local entries = assert(registry.find({}))
            for _, row in ipairs(entries) do
                local id = tostring(row.id)
                test.eq(policy:evaluate(actor, "access", id), expected[id] and "allow" or "undefined", id)
            end
            for id in pairs(expected) do
                test.eq(policy:evaluate(actor, "access", id), "allow")
                test.eq(policy:evaluate(actor, "access", id .. ".unlisted"), "undefined")
            end
        end)
        test.it("limits tool runtime grants to the traits namespace", function()
            local public = assert(registry.get("kickside.docs.security:tool_access"))
            test.eq(#public.meta.includes, 1)
            test.eq(public.meta.includes[1], "kickside.docs.security:tool_runtime")
            local entry = assert(registry.get(public.meta.includes[1]))
            test.eq(entry.meta.private, true)
            test.eq(#entry.data.policy.resources, 1)
            test.eq(entry.data.policy.resources[1], "kickside.docs.traits:*")
            local policy = assert(security.policy(tostring(entry.id)))
            local actor = security.new_actor("tool-member", {})
            for _, row in ipairs(assert(registry.find({}))) do
                local id = tostring(row.id)
                local expected = id:match("^kickside%.docs%.traits:") and "allow" or "undefined"
                for _, action in ipairs(entry.data.policy.actions) do
                    test.eq(policy:evaluate(actor, action, id), expected, id)
                end
            end
        end)
        test.it("binds only module policies to the member requirement", function()
            local requirement = assert(registry.get("kickside.docs.security:user_security_scope"))
            test.eq(requirement.meta.value_kind, "security.scope")
            test.eq(requirement.data.default, "kickside.security.groups:members")
            test.eq(#requirement.data.targets, 2)
            local seen = {}
            for _, target in ipairs(requirement.data.targets) do
                test.eq(target.path, ".groups +=")
                seen[target.entry] = true
                local entry = assert(registry.get(target.entry))
                test.eq(#entry.data.groups, 1)
                test.eq(entry.data.groups[1], "app:members")
            end
            for _, name in ipairs({"module_access", "module_runtime"}) do
                test.is_true(seen["kickside.docs.security:" .. name])
            end
            for _, name in ipairs({"tool_access", "tool_runtime"}) do
                local entry = assert(registry.get("kickside.docs.security:" .. name))
                test.eq(#entry.data.groups, 0)
            end
            local outsider = assert(security.new_scope({}))
            local actor = security.new_actor("outside-member-group", {})
            test.eq(outsider:evaluate(actor, "funcs.call", "kickside.docs.traits:read_doc_tool"), "undefined")
        end)
    end)
end)}
