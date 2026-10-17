# Execution identity and jobs

`kickside.execution:execution_identity` constructs and resolves execution identity. Synchronous work uses the caller's frame; deferred owners capture their principal and resolve current authority at execution boundaries.

## Identity ownership

The persisted v2 object has `version`, `principal = {kind, id}`, `authorized_by`, and `captured_at`, with optional `component_id` (root), `credential_id`, and `link_id`. `to_row(identity)` returns `{actor_id, actor_context}`; `from_row(actor_id, actor_context)` restores it.

`capture()` selects the caller. Selecting another principal requires native `security.actor.delegate` authority; component ADMIN alone is insufficient. Selection and effect access are separate grants. Live resolution rejects deleted, suspended, or unauthorized principals.

Component's `_execution_identity` is reserved private context. Change it with `component.set_execution_identity(component_id, principal, request_id, expected_identity_generation)`, which uses the protected `SET_EXECUTION_IDENTITY` path and requires ADMIN plus act-as authority for the selected principal. Ordinary context commands cannot replace it. Automation coordinates its own identity command and expected generation.

## Job ownership

Jobs carry no execution identity. The worker resolves the identity held by its domain owner; projection cursors, Workflow runs, and Automation drives retain their own owner records.

`kickside.core.jobs:jobs` enqueue requires `namespace`, `scope`, `key`, `owner_locator = {kind, id}`, the worker entry ID as `job_type`, and an `immutable_payload` table. Optional fields include an RFC3339 `scheduled_at`, `thread_id`, `trace_context`, `max_attempts`, and `priority`. Enqueue refuses `actor_id`, `actor_context`, `payload`, and `worker_ref`; the worker receives `input.payload` and `input.job.deadline`. Pass the enclosing deadline to blocking waits.

When a job and durable fact must commit together, the domain owner uses `jobs.enqueue_tx` and the thread writer on the same transaction, then notifies after commit. Public enqueue does not accept a `thread_event` field.

Automations, projections, and Workflows own their job slots. Use their public contracts rather than adding another scheduler. Work that waits for another job can declare an awaited job class for reserved worker capacity.

Test delegation refusals, changed memberships, suspended principals, retry behavior, and deadline settlement. See [security](security-and-module-access.md) and [Automation delivery](automations-and-dataflows.md).
