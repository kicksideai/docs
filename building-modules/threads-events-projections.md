# Threads, events, and projections

A component's primary thread has the component's runtime ID. Threads store immutable facts; projections fold them into read models.

## Declare and append events

An event type is a `registry.entry` with `meta.type: kickside.core.threads.event` and a body schema. The kind's `meta.events.input` and `meta.events.output` list exact event IDs from its module.

Component WRITE authorizes declared inputs and outputs under the caller's identity. Outputs marked `system_only: true` require the trusted framework maintenance path. Ordinary callers cannot set timestamps or append reserved framework events. A denied target rolls back the entire append batch.

Use the `kickside.core:threads` contract. `emit` ensures the component's thread and appends; `append_event` and `append_events` accept explicit thread IDs. The writer owns sequence allocation, deduplication, authorization, and post-commit wakeup.

Preserve `trace_context` fields `trace_id`, `run_id`, `caused_by_event_id`, and `correlation_key`. External deduplication uses `external_source`, `external_id`, and optional `external_version`.

## Concurrent writers

An optional `subject` names a stream within the thread. It is non-empty, at most 256 bytes, and contains no control characters. Its `subject_version` begins at 1 and survives event retention through the stored stream head.

`threads:find` with `thread_id` and `subject` returns the current subject version, or 0 for an absent subject. Appends accept `expect = {subject = name, version = number}`, `expect = {head = number}`, or both. A stale expectation returns CONFLICT and rolls back all writes in the batch. Exact duplicate retries return the stored events and original subject versions.

## Project committed state

Declare `meta.projections` on the kind with `kind`, `worker_ref`, and input mode. `func://` targets `function.lua`; `proc://` targets a supervised `process.lua`. Workers declare `meta.type: projection.worker`; they do not select a custom actor or security frame.

A `prefetch_events` worker receives thread, cursor, projection, events, trace, and range. Return `body` and `last_seq` after read-model writes commit. Keep writes idempotent: leased work can run again. Release SQL connections before returning or spawning a child process. Check retention gaps before advancing a cursor.

Call `component.set_meta` for derived display state. A returned `meta` field does not update public component metadata. Read endpoints query committed tables rather than running projections.

When the writer needs acknowledgment, use `catch_up_projection` with the enclosing RFC3339 work deadline. Retention with `drain_aware: true` preserves cursor and event-drive drain boundaries. A `component.<id>` notification tells the frontend to refetch state.
