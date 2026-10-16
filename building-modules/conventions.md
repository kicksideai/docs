# Registry and source conventions

A source `_index.yaml` declares `version: "1.0"`, an exact namespace, and entries. One root `ns.definition` owns the module's namespace. A package name or directory never determines an entry ID.

## Executable entries

`function.lua` declares source, exported method, registry imports, and permitted runtime modules. `library.lua` supplies shared code; `process.lua` owns process behavior. A contract binding maps methods to function IDs.

Known entries use `registry.get`; extension families use typed `registry.find`. Runtime Components use the component service. See [discovery](discovery-addressing-and-context.md).

## Requirements

A `ns.requirement` names host input and exact target fields. Host `ns.dependency.parameters` supplies the value. Targets can append groups through `.groups +=`. Preserve published requirement names and targets when adding capabilities.

## Errors

The native `errors` object is a global, not a registry import. Use a classified error and propagate it:

```lua
return nil, errors.new({
    message = "A record title is required",
    kind = errors.INVALID,
    retryable = false,
    details = { code = "TITLE_REQUIRED" },
})
```

Branch on `errors.is` or a stable details code, never message text. `errors.wrap` adds context. `kickside.contract:error_envelope` preserves source kind, retryability, details, and cause when a boundary adds annotations. Preserve native fields across serialized boundaries.

HTTP and MCP retain their published response shape, with additive kind and code fields. A retry after a side effect requires its idempotency or receipt protocol; success follows commit.

## HTTP and UI

An `http.endpoint` declares method, path, function, and a router supplied by requirement. The host owns the `/api/v1` prefix and authentication chain. Public callbacks use an intentional public router and validate signatures or tokens.

A frontend uses the module's filesystem/static declarations, view metadata, and navigation entry. Settings, events, tools, Blocks, and ports use their owner's exact metadata discriminators.
