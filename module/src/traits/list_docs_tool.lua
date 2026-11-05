local catalog = require("catalog")
local security = require("security")

local function handler(args: any): (any, error?)
    if not security.actor() or security.can("access", "kickside.docs.traits:list_docs_tool") ~= true then
        return nil, errors.new({kind = errors.PERMISSION_DENIED, message = "access denied"})
    end
    return catalog.list(args)
end

return {handler = handler}
