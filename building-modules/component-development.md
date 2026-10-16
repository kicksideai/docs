# Components

A component row stores `component_id`, `impl_id`, private context, placement, timestamps, and public metadata. The runtime component ID is distinct from the registry binding ID in `impl_id`.

## Declare a kind

A component kind is a `contract.binding` implementing `kickside.contract:component`. Its metadata declares class, title, icon, and optional events, projections, retention, and provisioning. Add `kickside.contract:deletable` when the kind owns tables or files.

On-demand resources register through `kickside.component:component_service`. Provisioned kinds declare `meta.provision` and a `meta.class` array. Autoinit creates deterministic per-user or system resources; the first class identifies the provisioned kind.

A kind needs `meta.component.create.view` to appear in a creation picker and `meta.component.manage.view` to declare its management view.

## Read and write

Import `kickside.component:component` as `component` and use the actor-bound client:

| Operation | Interface |
| --- | --- |
| Open a resource | `component.open(id, required_access, target_contract_id)` |
| Read private context and its revision | `component.read_context(id, required_access)` |
| Change safe display fields | `component.set_meta(id, fields, opts)` |
| Change context | `component.update(id, commands, opts)` |
| Query visible resources | Component service `list`, `query`, or `count` |
| Create a resource | Component service `register` with `impl_id`, `private_context`, and `meta` |

Context updates use `SET_CONTEXT` or `PATCH_CONTEXT`. An `expected_revision` makes the batch a compare-and-set; stale revisions return CONFLICT without writing. Public metadata rejects credential, token, private-context, and identity keys.

## Access and lifecycle

`component.ACCESS` uses READ=1, WRITE=2, DELETE=4, ADMIN=8, READ_WRITE=3, and FULL=15. Creation grants the creator FULL access. Sharing requires ADMIN and cascades through the subtree; child creation requires WRITE on the parent.

Delete through the component service. Its fence precedes the kind's idempotent backing-data cleanup and thread purge, followed by unregister. A failed cleanup remains retryable through the durable lifecycle owner. Placement and ownership are separate: removing a workspace pointer does not delete the backing resource.

Test creation, sharing, denied access, concurrent context updates, repeated deletion, and public metadata. See [security](security-and-module-access.md).
