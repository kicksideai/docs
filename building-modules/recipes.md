# Extension recipes

## Add a resource kind

Declare a Component binding with its class, lifecycle, create/manage views, and exact contracts. Register instances through Component. Put configuration in private context and derived display fields in public metadata. Implement idempotent deletion for owned data and test sharing, denied access, updates, and teardown.

## Add a provider

Implement the Connection contract and Reply Provider contract when needed. Declare credential schema, required component context, normalized resource discovery, and tools. Delegate OAuth to the OAuth owner. Test authorization, discovery, renewal, reply, and deletion.

## Add a knowledge engine

Implement the Knowledge store lifecycle and publish one engine descriptor with config, views, query binding, and source workers. Materialize durable content facts through those workers. Test the complete create/ingest/query/delete path through the Knowledge API.

## Add a human review

Compose the Inbox Review Block in a Flow. Inbox owns assignment and the decision record; Blocks/Dataflow owns the committed park and signal. Resume through the native signal identity and test a nested wait across restart.

## Add a tool or Block

Declare a tool function and schemas; its trait supplies prompt and configuration. Public tools can become virtual Blocks. A distinct non-tool Block declares its own exact execution target and schemas. Route both through the same domain service under the caller's authority.

## Add ongoing or scheduled work

Declare Automation source and destination ports and implement the appropriate kind contracts. Let the engine own drives, rounds, cadence, receipts, and controls. For one domain-owned deadline, enqueue a Job through the existing owner, with atomic fact/job commit when required.

See [checklists](checklists.md) before release.
