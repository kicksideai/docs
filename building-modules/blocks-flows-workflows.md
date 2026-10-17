# Blocks, Flows, Workflows, and ports

A Block is one typed capability. A Flow is a native Dataflow DAG and its durable execution. A Workflow is a user-owned visual definition that publishes immutable versions.

## Block declarations

A Block is a `registry.entry` with `meta.type: kickside.block` and `data.block.api_version: kickside.block/v1`. It declares object schemas for input, config, and output, output ports, presentation metadata, and exactly one execution target: `function` (`function_id`), `agent` (`agent_id`), or `wait`.

A `failed` port and error schema are declared together. A function Block receives `{input, config}`. Unknown declaration fields fail validation. Public tools are projected as virtual Blocks from their authoritative tool schemas; do not duplicate them.

Use `kickside.blocks:blocks` to discover, validate, and lower each Block into one native node plan. The composing caller owns the graph and edges. Headless composition does not require the visual Workflow module.

## Portable and visual definitions

A portable Flow uses `meta.type: kickside.flow` and `data.flow.api_version: kickside.flow/v1`. Blocks owns declaration checksums, references, binding, and materialization.

Workflows owns visual authoring, validation, publishing, compilation, and run history. Its definition event stream is authoritative. Publishing freezes a compiled version; launching gives the run independent native node and data IDs.

The structural node kinds are `start`, `finish`, `error`, `branch` (Condition), `cycle` (Loop), `for_each` (For each), and `combine`; executable steps are `block` and `flow` (a nested published Flow). They route or compose execution rather than substituting empty functions.

## Waits and ports

A wait lowers to `kickside.blocks:await`. Its durable park commits before a provider-owned arm. Resume calls `kickside.blocks:resume` with `{dataflow_id, signal_id, payload}`, including nested and restarted waits. The stored execution identity governs resumed work.

Block output ports live in `data.block.ports`, with `direction: out`. Automation ports are separate standalone catalog entries for ongoing sources and destinations.
