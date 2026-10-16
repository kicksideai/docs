# Discovery, addressing, and context

| Identity | Example | Source |
| --- | --- | --- |
| Package | `kickside/inbox` | Hub manifest |
| Namespace | `kickside.inbox` | Root `ns.definition` |
| Entry | `kickside.inbox.sink:inbox_sink` | Exact registry declaration |
| Contract | `kickside.data:writable` | `contract.definition` |
| Component | Runtime resource ID | Component service |

A package name, label, or folder does not determine a namespace. A Component ID is not a registry entry ID.

## Find the declaration

Use `registry.get(id)` for a known entry. Discover an extension family by kind and its canonical metadata:

```lua
local ports, err = registry.find({
    [".kind"] = "registry.entry",
    ["meta.type"] = "kickside.automation.port",
})
if err then return nil, err end
```

Discovery runs under the caller's scope. An absent result can mean missing installation, a nonmatching declaration, or denied visibility. Keep persisted execution references exact; discovery is an authoring operation.

Use `kickside.agents:tools` for normalized actor-visible tools and `kickside.blocks:blocks` for validated Blocks. Inspect installed or proposed package entries through the Hub's entry-inclusive plan.

## Select and invoke the instance

Query Components through their actor-scoped service. Open the selected instance with the required access and target contract. Component supplies private context and declared `context_required` values such as `component_id`.

Discovery needs declaration metadata; invocation needs an authorized resource. Synchronous calls inherit the actor; deferred owners capture and later resolve the canonical execution identity. Do not infer context from titles or manufacture a broader scope for missing resources.
