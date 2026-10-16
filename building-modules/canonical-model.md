# Canonical model

| Primitive | Owns |
| --- | --- |
| Component | A resource's identity, ownership, access, placement, public metadata, and private context |
| Contract | A stable callable interface |
| Binding | A concrete implementation of one or more contracts |
| Thread | A durable event stream, normally at the component ID |
| Projection | An idempotent fold into committed read state |
| Job | A leased unit of scheduled work with a deadline |
| Automation | Ongoing configured behavior with drives and rounds |
| Block | One typed executable capability |
| Flow | One durable Dataflow graph execution |
| Workflow | A user-owned visual definition with immutable published versions |
| Port | A Block output route or an Automation source/destination declaration |

## Separate state by purpose

Public component metadata is the render snapshot: titles, status, counts, and other safe display fields. Private context stores configuration and resource selections. Domain tables store the module's records. Thread events store durable facts. A projection derives read tables and public metadata from those facts.

Give each derived state field one owner. Change public metadata through `component.set_meta`; change private context through the component service. Credentials and execution identity never belong in public metadata or event bodies.

## Use the caller's authority

Synchronous calls retain the caller's actor and scope. Deferred owners store a canonical execution identity and resolve live authority before work. Module policy access and component record access remain separate checks.

Use contracts to cross module boundaries. An API, tool, Block, and writable destination call the same domain writer rather than maintaining separate write logic. Realtime notifications wake clients to refetch committed state.

See [components](component-development.md), [events](threads-events-projections.md), and [execution identity](execution-identity-and-jobs.md).
