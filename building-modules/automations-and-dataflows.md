# Automations and dataflows

The Automation engine owns drives, bounded rounds, cursors, receipts, retry ledgers, and controls. A kind implements its domain behavior through the shared contracts.

## Kinds and sources

Declare a `contract.binding` with `meta.type: kickside.automation`, class, input schema, supported actions, and Component, Installable, Round Consumer, and Deletable contracts. Data Sync is a source/transform/destination example; Channel Responder is a channel-specific example.

Data Sync's input requires title, trigger, sink port, enabled state, and transform. Its trigger is `{v = 2, source, config, backfill, ...}`. An event source takes `backfill` `all` or `none` and no schedule; a collection source takes `all`, `none`, `{since}`, or `{last_days}`, and a schedule of type `interval`, `ticker`, or `cron`. Transform `kind` is `none`, `expr`, `llm`, `func`, or `code`. Function transforms receive `{item = {item_key, envelope, input, payload}, config}` with the source payload in `item.input`. Expression bindings expose the payload as `payload` and `input`. Function transforms declare enforceable resource references; admission checks both the operator and selected principal. A transform skips an item explicitly by returning `{present = false, skip = "<reason>"}`; the round records it as skipped, with no sink write and no failed delivery. A transform that returns no value without a skip fails the item, so items are never dropped silently.

Event sources pull committed thread sequences. Collection sources implement `kickside.data:pullable`. Timer sources use persisted occurrences and exact cadence deadlines. Payload schema describes `item.payload`; stable item keys, operation, deduplication, and source version belong to the envelope.

Editors obtain real source payloads through
`POST /api/v1/automations/source-samples` with `{source, config, limit}`, where
`limit` is an integer from 1 to 100. An event source needs `config.thread_id`
unless its class is a per-user singleton. The result contains `success`,
`samples` (up to `limit` item payloads; deletes are excluded), and the source's
`output_schema` when declared. The bounded read uses the caller's identity and
does not advance an installed drive. An empty source returns no samples;
generation does not fabricate payloads from its schema.

## Rounds and delivery

Each drive has a leased round slot. Work is bounded by policy and the earlier job or round deadline, with a reserve for commit. Event appends wake waiting work; timers sleep to their exact deadline.

A `kickside.trigger:round_consumer` puts every input `delivery_key` in exactly one outcome list: `delivered_items`, `skipped_items`, `waiting_items`, `uncertain_items`, or `failed_items`, each item as `{key = delivery_key, ...}`; failed items also carry `error`. The delivery key correlates the outcome; the source item key can recur across changes.

A writable destination declares delivery semantics and input shape, then accepts `config`, `sink_op`, `input`, `identity_key`, `idempotency_key`, and `origin`. Validate origin with `origin(req)` from the `kickside.data:writable_sink` library. Receipts are keyed by `(origin, sink_op, idempotency_key)`. A success follows the committed side effect; an uncertain effect uses the destination's receipt and reconciliation protocol.

The engine commits the source cursor and keeps held or failed items for independent retry. Confirmed destination mappings have receipts. Deleting a sync retires its receipts while keeping destination records.

## Trigger a Workflow

Declare an event source port, install Data Sync over that resource, and select the Run Workflow destination with an exact published Workflow version. The stable source identity deduplicates the run. Inspect admission and terminal run state separately; an appended source event is not a completed Flow.

Use installed kind controls for pause, resume, reconfigure, resync, replay, run now, and identity changes when declared. Do not implement parallel polling or retry state.
