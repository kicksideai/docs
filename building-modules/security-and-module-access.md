# Security and module access

The authenticated router runs `token_auth` then `endpoint_firewall`. The firewall evaluates `access` against the exact endpoint registry ID. Names and suffixes do not grant access. Public login, OAuth, and provider callbacks use an intentional public router and their own validation.

## Module policies and groups

A selectable module policy is a public `security.policy` with empty `groups`, title, surface, and `meta.intent: module_access`. It includes private companion policies for declared runtime capabilities. Module endpoint grants enumerate exact IDs.

The published `user_security_scope` requirement declares `meta.value_kind: security.scope` and defaults to `kickside.security.groups:members`. Retain its ID and existing targets; append new targets when adding a policy. An existing host binding takes precedence on update. Modules using the shared Contract member interface declare `meta.member_scope: kickside.contract.http:user_security_scope`.

Administrators compose groups in **System → Security** and assign them in **System → Users**. Effective scope unions assigned policies, with deny precedence. The platform Members composition selects module-access policies; optional tool policies require explicit selection.

## Resource authority

Navigation, registry discovery, contract implementations, views, and MCP use the same security scope. Resource ACLs remain a second required check. Component READ, WRITE, DELETE, and ADMIN protect the corresponding operations; direct grants cascade through the subtree.

`app.security:user` supplies the signed-in baseline. `app.security:members` includes Core and platform Members. Users management is a separate selectable capability; own profile access does not require account administration.

Access reductions revoke affected sessions. Allow-only expansions appear at the next login or token issue. MCP resolves the owner's current groups per invocation within the credential's issuance ceiling and restrictions; reissue a credential to expand its authority.

## Execution authority

Selecting another principal needs native `security.actor.delegate` permission. Component ADMIN alone grants no delegation. The operator and selected principal both need the declared resources when installing an Automation. Deferred owners resolve live authority before effects; captured credential and link restrictions remain attached.

Bot accounts are ordinary User principals with immutable classification. They cannot authenticate or receive credentials, even with an administrative membership. Membership grants execution access; Act-as policies grant operator selection authority. Neither replaces the other.

Test endpoint admission, registry visibility, Component ACLs, contract calls, and MCP under allowed and denied groups. See [published endpoint declarations](../reference/security.md) and [execution identity](execution-identity-and-jobs.md).
