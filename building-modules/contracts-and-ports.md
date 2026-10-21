# Contracts and ports

A `contract.definition` declares methods with descriptions and JSON input/output schemas. A `contract.binding` maps each method to its `function.lua` entry ID. One binding can implement several contracts; an item in a binding's `contracts` list can set `default: true`.

Open the contract under the current actor and scope. For an instance-bound contract, open through Component so `context_required` values and private context come from the selected resource.

Use a contract when multiple implementations exist or a module needs a stable boundary to another subsystem. Module-owned SQL remains behind that boundary.

## Writable destinations

A `kickside.data:writable` binding declares:

- `meta.delivery`: `exactly_once`, `at_least_once`, or `at_most_once`.
- `meta.input_shape`: `record` or `content`.
- The `write` method's function ID.

Each write carries `config`, `sink_op`, `input`, a per-delivery `idempotency_key`, and `origin`. The shared request schema makes `identity_key` optional; include it in every new writer. Rounds supply it as the stable destination record identity, and a sink that names records by key uses it in preference to `idempotency_key`. Stable identity names a destination record; delivery identity names one write, including all retries of that write. A later delivery that changes the record uses a new `idempotency_key` and retains its `identity_key`. Individual destinations can require stable identity for their operations.

Within the destination's receipt scope `(origin, sink_op, idempotency_key)`, the same key with the same write content returns the recorded result without repeating the effect. Reusing the key with different write content returns `idempotency_conflict`. A success reports a committed result. A classified failure follows the contract's DataError schema, including its permitted `scope` values.

The optional `identity_key` field and key semantics are part of the [current writable contract](https://github.com/kicksideai/kickside/blob/main/core/contract/src/data/registry/writable_contracts/_index.yaml). Direct Channel delivery replay is available from the upcoming release that includes [kickside#77](https://github.com/kicksideai/kickside/pull/77); CRM's `idempotency_conflict` classification is available from the upcoming release that includes [crm#18](https://github.com/kicksideai/crm/pull/18); direct Discord delivery replay is available from the upcoming release that includes [providers#19](https://github.com/kicksideai/providers/pull/19).

## Automation ports

A port is a standalone `registry.entry` with `meta.type: kickside.automation.port`. Its top-level fields name `binding`, optional `event`, operations, and config/input/output schemas. The fields select the port kind: `event` makes an event source naming an exact declared event, `operations` makes a destination bound to `kickside.data:writable`, and a port with neither is a collection source bound to `kickside.data:pullable`.

Block output ports instead live in `data.block.ports` and route a result within a Flow. Do not store Automation ports in a binding's `meta.ports`.

See [Automation delivery](automations-and-dataflows.md) and [Blocks and Flows](blocks-flows-workflows.md).
