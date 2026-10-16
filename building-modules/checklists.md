# Module review checklist

## Declarations and state

- Package, namespace, entry, contract, and Component identities have distinct roles.
- Persisted references use exact IDs; discovery uses canonical kinds and metadata.
- Each public metadata field has one owner. Configuration and credentials remain private.
- Cross-module behavior uses contracts instead of another module's SQL.
- Product defaults live in registry declarations.

## Access and execution

- HTTP endpoints use the intended authenticated or verified public router.
- Member policies enumerate exact endpoint IDs and retain published requirements.
- Component READ, WRITE, DELETE, or ADMIN applies to each resource operation.
- Durable owners resolve current execution identity; selection authority is distinct from effect access.
- Errors preserve native classification and reach the caller.

## Durable behavior

- Events have registered types and declared input/output direction.
- Component WRITE authorizes domain outputs; framework attestations use `system_only`.
- Projection writes are idempotent and acknowledge only committed state.
- Writable destinations declare delivery semantics, stable identity, origin, and idempotency.
- Blocking work retains the enclosing deadline.
- Deletion uses the owning lifecycle and preserves retryable fences.

## Verification and packaging

- Tests exercise allowed and denied actors, repeated delivery, failure, rollback, and deletion.
- SQL behavior passes SQLite and PostgreSQL with fresh dependency resolution.
- Forward migrations preserve existing data and published interfaces.
- Frontend source builds into the declared served bundle and follows [Wippy guidance](frontend.md).
- The manifest excludes harness and local state; required built assets are committed.
- The module Makefile's gates pass and `git diff --check` is clean.

See [testing](testing.md) and [packaging](publishing.md).
