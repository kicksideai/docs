# Automations and dataflows

The Automation engine owns drives, bounded rounds, cursors, receipts, retry ledgers, and controls. A kind implements its domain behavior through the shared contracts.

## Kinds and sources

Declare a `contract.binding` with `meta.type: kickside.automation`, class, input schema, supported actions, and Component, Installable, Round Consumer, and Deletable contracts. Data Sync is a source/transform/destination example; Channel Responder is a channel-specific example.

Data Sync's input requires title, trigger, sink port, enabled state, and transform. Its v2 trigger selects an event or collection port and its resource config. Transforms are none, expression, LLM, function, or code. Function transforms declare enforceable resource references; admission checks both the operator and selected principal.

Event sources pull committed thread sequences. Collection sources implement `kickside.data:pullable`. Timer sources use persisted occurrences and exact cadence deadlines. Payload schema describes `item.payload`; stable item keys, operation, deduplication, and source version belong to the envelope.

## Rounds and delivery

Each drive has a leased round slot. Work is bounded by policy and the earlier job or round deadline, with a reserve for commit. Event appends wake waiting work; timers sleep to their exact deadline.

A `kickside.trigger:round_consumer` puts every input delivery key in exactly one outcome list: delivered, skipped, waiting, uncertain, or failed. The delivery key correlates the outcome; the source item key can recur across changes.

A writable destination declares delivery semantics and input shape, then accepts config, operation, input, stable identity, delivery idempotency, and origin. Use the canonical origin validator. Receipts are scoped by origin, operation, and delivery key. A success follows the committed side effect; an uncertain effect uses the destination's receipt and reconciliation protocol.

The engine commits the source cursor and keeps held or failed items for independent retry. Confirmed destination mappings have receipts. Deleting a sync retires its receipts while keeping destination records.

## Trigger a Workflow

Declare an event source port, install Data Sync over that resource, and select the Run Workflow destination with an exact published Workflow version. The stable source identity deduplicates the run. Inspect admission and terminal run state separately; an appended source event is not a completed Flow.

Use installed kind controls for pause, resume, reconfigure, resync, replay, run now, and identity changes when declared. Do not implement parallel polling or retry state.
