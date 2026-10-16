# Execution identity and jobs

`kickside.execution:execution_identity` constructs and resolves execution identity. Synchronous work uses the caller's frame; deferred owners capture their principal and resolve current authority at execution boundaries.

## Identity ownership

The persisted v2 object carries version, principal, authorizer, capture time, and optional root, credential, and link restrictions. `to_row` and `from_row` own its SQL representation.

`capture()` selects the caller. Selecting another principal requires native `security.actor.delegate` authority; component ADMIN alone is insufficient. Selection and effect access are separate grants. Live resolution rejects deleted, suspended, or unauthorized principals.

Component's `_execution_identity` is reserved private context. Change it through the protected `SET_EXECUTION_IDENTITY` token path. Ordinary context commands cannot replace it. Automation coordinates its own identity command and expected generation.

## Job ownership

Jobs carry no execution identity. The worker resolves the identity held by its domain owner; projection cursors, Workflow runs, and Automation drives retain their own owner records.

`kickside.core.jobs:jobs` accepts namespace, scope, key, worker entry ID as `job_type`, and `immutable_payload`. Scheduling uses an RFC3339 `scheduled_at`; the worker receives `input.payload` and `input.job.deadline`. Pass the enclosing deadline to blocking waits.

When a job and durable fact must commit together, the domain owner uses `jobs.enqueue_tx` and the thread writer on the same transaction, then notifies after commit. Public enqueue does not accept a `thread_event` field.

Automations, projections, and Workflows own their job slots. Use their public contracts rather than adding another scheduler. Work that waits for another job can declare an awaited job class for reserved worker capacity.

Test delegation refusals, changed memberships, suspended principals, retry behavior, and deadline settlement. See [security](security-and-module-access.md) and [Automation delivery](automations-and-dataflows.md).
