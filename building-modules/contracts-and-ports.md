# Contracts and ports

A `contract.definition` declares methods with descriptions and JSON input/output schemas. A `contract.binding` maps each method to its `function.lua` entry ID. One binding can implement several contracts; a contract entry can mark an implementation `default: true`.

Open the contract under the current actor and scope. For an instance-bound contract, open through Component so `context_required` values and private context come from the selected resource.

Use a contract when multiple implementations exist or a module needs a stable boundary to another subsystem. Module-owned SQL remains behind that boundary.

## Writable destinations

A `kickside.data:writable` binding declares:

- `meta.delivery`: `exactly_once`, `at_least_once`, or `at_most_once`.
- `meta.input_shape`: `record` or `content`.
- The `write` method's function ID.

Each write carries a stable `identity_key`, per-delivery `idempotency_key`, and required `origin`. Stable identity names a destination record; delivery identity names one write attempt. A success reports a committed result. A classified failure follows the contract's DataError schema, including its permitted `scope` values.

## Automation ports

A port is a standalone `registry.entry` with `meta.type: kickside.automation.port`. Its top-level fields name `binding`, optional `event`, operations, and config/input/output schemas. An event port names an exact declared event; collection sources use `kickside.data:pullable`; destinations use `kickside.data:writable`.

Block output ports instead live in `data.block.ports` and route a result within a Flow. Do not store Automation ports in a binding's `meta.ports`.

See [Automation delivery](automations-and-dataflows.md) and [Blocks and Flows](blocks-flows-workflows.md).
