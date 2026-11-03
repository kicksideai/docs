# Knowledge, uploads, and Inbox

## Knowledge engines

`kickside.knowledge` owns knowledge-base Components, engine discovery, lifecycle, ingestion, and retrieval integration. An engine implements `kickside.knowledge:kb_store_lifecycle` and publishes a `registry.entry` with `meta.type: kickside.kb_engine`.

The descriptor names its component implementation, query binding, store contract, creation and management views, default config, and source projections. Its declared workers materialize source events into engine-owned storage. The control plane discovers descriptors; it does not branch on engine names.

Keep one owner for derived knowledge metadata such as status, error, document count, chunk count, and ingestion timestamps. Test store creation, source materialization, query, access, and deletion through the Knowledge API.

## Upload content

Uploads owns bytes, records, processing jobs, tokens, derived artifacts, and preview endpoints. Upload type entries use `meta.type: upload.type`; a higher `priority` runs before a lower one, so specific processors precede generic ones.

A consumer uses the `kickside.contract:content_provider` contract (`get_content`, `get_info`) or a signed read token. A read token carries `purpose`, `upload_id`, `artifact_id`, `audience`, `issued_at`, and `expires_at`. Private configuration does not belong in a token. Conversion code remains below the Uploads resource layer.

### Work after processing

An upload is stored, processed by the pipeline its `upload.type` declares, and settles as `completed` or `error`. Work that needs the processed content attaches a completion callback instead of polling the upload's status.

The module that owns the follow-up work mints a completion token with `kickside.uploads.persist:upload_tokens` `pack({upload_id, function_id, on_error_id?, actor_id, actor_context, params})`, using an identity captured with `kickside.execution:execution_identity`. It attaches the token as the `upload_token` field of `POST /uploads`, the presigned or complete request, or as `metadata.__upload_token` for `kickside.uploads:uploads.upload_file`.

When processing settles, Uploads runs the function as a durable Job under the token's identity, once per upload, token, and outcome. The function receives the `upload_id`, `status`, `error`, type and size, storage location, upload metadata, and the token's `params`, then reads the derived artifacts with the same authority. A failure runs `on_error_id` when the token declares one. A deduplicated upload runs the callback with the existing upload's outcome, and each member extracted from an archive runs the archive's callbacks. Knowledge ingestion uses this path.

## Human review

Inbox owns assignment, item events, its read projection, and public counts. Item kinds are entries with `meta.type: inbox.item_type`, a `value`, `title`, `severity`, and a renderer named by `component_tag` and `component_base_path`.

`kickside.inbox.sink:inbox_sink` accepts notices. `kickside.inbox:block.review` is the durable human-wait reference: Inbox owns the item while Blocks/Dataflow own parking and signaling. Use the native signal identity to resume a nested or restarted wait.

An upload-to-knowledge Flow uses Uploads for content, the Knowledge owner for ingest facts, the engine projection for materialization, and Inbox for review. It does not access another module's SQL tables directly.
