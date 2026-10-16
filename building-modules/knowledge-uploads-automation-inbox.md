# Knowledge, uploads, and Inbox

## Knowledge engines

`kickside.knowledge` owns knowledge-base Components, engine discovery, lifecycle, ingestion, and retrieval integration. An engine implements `kickside.knowledge:kb_store_lifecycle` and publishes a `registry.entry` with `meta.type: kickside.kb_engine`.

The descriptor names its component implementation, query binding, store contract, creation and management views, default config, and source projections. Its declared workers materialize source events into engine-owned storage. The control plane discovers descriptors; it does not branch on engine names.

Keep one owner for derived knowledge metadata such as status, error, document count, chunk count, and ingestion timestamps. Test store creation, source materialization, query, access, and deletion through the Knowledge API.

## Upload content

Uploads owns bytes, records, processing jobs, tokens, derived artifacts, and preview endpoints. Upload type entries use `meta.type: upload.type`; priority selects more specific processors before generic ones.

A consumer uses Uploads' content contract or a signed upload token. Tokens carry the upload ID, purpose, expiry, and minimal routing or trace information. Private configuration does not belong in a token. Conversion code remains below the Uploads resource layer.

## Human review

Inbox owns assignment, item events, its read projection, and public counts. Item kinds are entries with `meta.type: inbox.item_type`, including their title, severity, and renderer.

`kickside.inbox.sink:inbox_sink` accepts notices. `kickside.inbox:block.review` is the durable human-wait reference: Inbox owns the item while Blocks/Dataflow own parking and signaling. Use the native signal identity to resume a nested or restarted wait.

An upload-to-knowledge Flow uses Uploads for content, the Knowledge owner for ingest facts, the engine projection for materialization, and Inbox for review. It does not access another module's SQL tables directly.
