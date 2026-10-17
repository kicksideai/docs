# Threads, events, and projections

A component's primary thread has the component's runtime ID. Threads store immutable facts; projections fold them into read models.

## Declare and append events

An event type is a `registry.entry` with `meta.type: kickside.core.threads.event` and a body schema. The kind's `meta.events.input` and `meta.events.output` are arrays of `{type = "<namespace>:<name>"}` objects, each naming a declared event type. Output items can set `system_only: true`.

Component WRITE authorizes declared inputs and outputs under the caller's identity. Outputs marked `system_only: true` require a framework maintenance actor or the `threads.output.publish` permission on that event type. User-appended input events use role `user`. Ordinary callers cannot set timestamps or append reserved framework events. A denied target rolls back the entire append batch.

Use the `kickside.core:threads` contract. `emit` ensures the component's thread and appends; `append_event` and `append_events` take a `thread_id`, which must be a component's primary thread (the component ID). The writer owns sequence allocation, deduplication, authorization, and post-commit wakeup.

Preserve `trace_context` fields `trace_id`, `run_id`, `caused_by_event_id`, and `correlation_key`. External deduplication uses `external_source`, `external_id`, and optional `external_version`.

## Concurrent writers

An optional `subject` names a stream within the thread. It is non-empty, at most 256 bytes, and contains no control characters. Its `subject_version` begins at 1 and survives event retention through the stored stream head.

`threads:find` with `thread_id` and `subject` returns the current subject version, or 0 for an absent subject. Appends accept `expect = {subject = name, version = number}`, `expect = {head = number}`, or both. A stale expectation returns CONFLICT and rolls back all writes in the batch. Exact duplicate retries return the stored events and original subject versions.

## Project committed state

Declare `meta.projections` items on the kind with `kind`, `worker_ref`, and optional `input_mode`: `prefetch_events` or `cursor_only` (the default). `func://` targets `function.lua`; `proc://` targets a supervised `process.lua`. Workers declare `meta.type: projection.worker`; they do not select a custom actor or security frame.

A worker receives `{thread_id, trace_context, worker_input_mode, cursor, projection, range}`, plus `events` in `prefetch_events` mode. It can return `body` and `last_seq` after read-model writes commit; `last_seq` defaults to the end of the loaded range and must lie inside it. Keep writes idempotent: leased work can run again. Release SQL connections before returning or spawning a child process. Check retention gaps before advancing a cursor.

Call `component.set_meta` for derived display state. A returned `meta` field does not update public component metadata. Read endpoints query committed tables rather than running projections.

When the writer needs acknowledgment, use `catch_up_projection` with the enclosing RFC3339 work deadline. Retention never prunes past the lowest retention pin or projection cursor; `retention.event_days` sets the age cutoff. A `component.<id>` notification tells the frontend to refetch state.
