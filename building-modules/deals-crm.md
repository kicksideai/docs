# Compose a CRM application

This design uses a fictional Deals module. It describes a module architecture, not a schema included in a fresh CRM installation.

1. Declare the package dependencies and host database, router, server, and security requirements.
2. Define the business objects, fields, relations, and collections through CRM's module schema declarations.
3. Choose the independently shared Component roots. Store high-volume domain records in module-owned tables or through CRM's record contracts.
4. Declare exact domain event types and each kind's inputs/outputs. Component WRITE governs domain output events.
5. Fold committed events into an idempotent board read model and update its public status metadata.
6. Publish an Automation event source for a won deal and a writable destination for imported records. Preserve origin, stable identity, delivery keys, and receipts.
7. Publish a Workflow version for onboarding, then configure a Data Sync trigger using that exact version. Use Inbox Review for a human approval step.
8. Add an agent trait and tools that call the same domain writer as the API and destination.
9. Serve a board web component through the module's static and view declarations. Refetch committed state on Component notifications.
10. Verify a write, duplicate delivery, board refresh, trigger, parked review, resumed Flow, denied actor, and cleanup on both database engines.

CRM delivery recovery retains the sink's receipt and lease protocol. An ambiguous write cannot become a success through an unverified retry.

See [CRM contracts](https://github.com/kicksideai/crm/blob/main/docs/module.md), [Automation delivery](automations-and-dataflows.md), and [Flow composition](blocks-flows-workflows.md).
