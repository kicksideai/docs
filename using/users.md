# Users and groups

Account management and module access are separate capabilities.

## Manage accounts

Open **System → Users** to create, edit, disable, or manage account memberships. The **Users management** policy grants these controls; ordinary member access includes principal discovery for sharing and the signed-in user's own profile, not account administration.

New accounts join the default group when `join_default_group` is true, its default. An explicit group list remains explicit. Changing bootstrap credentials does not reset an existing account password.

## Set module access

1. Open **System → Security → Scopes** and choose **New scope**, or open a custom scope to edit it. Enter its slug and label.
2. Select the public module policies it needs and save it. The composed scope supplies a group for account membership.
3. Open the user in **System → Users** and assign the group.
4. Remove Members when the user needs a narrower set than the default installation access.
5. Sign in as that user and check the visible features and permitted actions.

{{ screenshot:kickside/security.png }}

The effective scope is the union of assigned group policies. A deny overrides an allow from any group. Access reductions revoke affected sessions. Allow-only expansions appear at the next login or token issue.

Resource sharing remains a second check. Share a connection, knowledge base, or other component with the required users or groups; module access alone does not expose other users' records. Direct record grants cascade through the component subtree.

## Bot accounts and delegation

**System → Users → Bots** creates ordinary User principals classified as bots. Bots do not sign in or receive credentials. They receive only the explicit memberships selected at creation.

**System → Security → Act-as grants** lets a Security administrator grant operator groups permission to select another ordinary User for an execution root or all roots. This does not grant resource access or group membership. The shared run-as picker checks current selection authority; every submission checks it again.

See [security reference](../reference/security.md) for group identities and endpoint policies, and [execution identity](../building-modules/execution-identity-and-jobs.md) for durable work.
