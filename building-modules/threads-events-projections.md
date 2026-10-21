# Threads, events, and projections

A component's primary thread has the component's runtime ID. Threads store immutable facts; projections fold them into read models.

## Declare and append events

An event type is a `registry.entry` with `meta.type: kickside.core.threads.event` and a body schema. The kind's `meta.events.input` and `meta.events.output` are arrays of `{type = "<namespace>:<name>"}` objects, each naming a declared event type. Output items can set `system_only: true`.

Component WRITE authorizes declared inputs and outputs under the caller's identity. Outputs marked `system_only: true` require a framework maintenance actor or the `threads.output.publish` permission on that event type. User-appended input events use role `user`. Ordinary callers cannot set timestamps or append reserved framework events. A denied target rolls back the entire append batch.

Use the `kickside.core:threads` contract. `emit` ensures the component's thread and appends; `append_event` and `append_events` take a `thread_id`, which must be a component's primary thread (the component ID). The writer owns sequence allocation, deduplication, authorization, and post-commit wakeup.

Preserve `trace_context` fields `trace_id`, `run_id`, `caused_by_event_id`, and `correlation_key`. External deduplication uses `external_source`, `external_id`, and optional `external_version`.

## Pull thread events

`kickside.core.threads:events_pullable` implements `kickside.data:pullable`. A pull takes `config.thread_id`, a non-negative integer `cursor` (the last consumed sequence), a positive integer `limit`, and a non-empty `idempotency_key`. Reads use the caller's READ access.

From the upcoming release that includes [kickside#70](https://github.com/kicksideai/kickside/pull/70), `event_type` can appear at the top level of the request or in `config`. The top-level value takes precedence when both are present. Each supplied value must be a non-empty string; an invalid top-level value returns `invalid_request`, and an invalid configured value returns `invalid_config`. Omitting both keeps the read unfiltered.

```json
{
  "config": { "thread_id": "<component-id>" },
  "event_type": "example.records:changed",
  "cursor": 0,
  "limit": 100,
  "idempotency_key": "read-page-1"
}
```

In the current item shape, `payload` is the decoded event body and follows the declared event body schema. Event metadata sits alongside it:

| Field | Value |
| --- | --- |
| `item_key`, `dedup_key` | Event ID, stable across replay |
| `op` | `upsert` |
| `event_type`, `role` | Event type and role |
| `external_identity` | `{source, id, version}` when external source and ID are present; version is optional |
| `occurred_at` | Event timestamp in UTC RFC3339 form |
| `seq` | Thread sequence |

The page returns `items`, `next_cursor`, and `has_more`. The next cursor is the last returned sequence, or the request cursor for an empty page. If retention removes events after the requested cursor, the page reports `source_gap` with `max_pruned_seq` and `earliest_seq`, returns no items, and keeps the cursor unchanged.

## Concurrent writers

An optional `subject` names a stream within the thread. It is non-empty, at most 256 bytes, and contains no control characters. Its `subject_version` begins at 1 and survives event retention through the stored stream head.

`threads:find` with `thread_id` and `subject` returns the current subject version, or 0 for an absent subject. Appends accept `expect = {subject = name, version = number}`, `expect = {head = number}`, or both. A stale expectation returns CONFLICT and rolls back all writes in the batch. Exact duplicate retries return the stored events and original subject versions.

## Project committed state

Declare `meta.projections` items on the kind with `kind`, `worker_ref`, and optional `input_mode`: `prefetch_events` or `cursor_only` (the default). `func://` targets `function.lua`; `proc://` targets a supervised `process.lua`. Workers declare `meta.type: projection.worker`; they do not select a custom actor or security frame.

A worker receives `{thread_id, trace_context, worker_input_mode, cursor, projection, range}`, plus `events` in `prefetch_events` mode. It can return `body` and `last_seq` after read-model writes commit; `last_seq` defaults to the end of the loaded range and must lie inside it. Keep writes idempotent: leased work can run again. Release SQL connections before returning or spawning a child process. Check retention gaps before advancing a cursor.

Call `component.set_meta` for derived display state. A returned `meta` field does not update public component metadata. Read endpoints query committed tables rather than running projections.

When the writer needs acknowledgment, use `catch_up_projection` with the enclosing RFC3339 work deadline. Retention never prunes past the lowest retention pin or projection cursor; `retention.event_days` sets the age cutoff. A `component.<id>` notification tells the frontend to refetch state.
