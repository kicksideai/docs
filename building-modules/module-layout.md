# Module layout

A module has one root `ns.definition`, source entries, and a separate standalone harness.

```text
wippy.yaml
Makefile
src/_index.yaml
src/api/
src/persist/
src/migrations/
src/security/
src/traits/
src/blocks/
ui/src/
static/
test/src/
test/wippy.yaml
test/.wippy.yaml
```

Each source directory with entries declares its exact namespace in `_index.yaml`. Namespaces can follow domains or technical concerns; folder names do not determine registry identity.

API handlers call the domain service. Repository code owns SQL, projections fold durable facts, and tools or writable bindings call the same writer. Settings and product defaults are registry entries, not seed SQL.

`ui/src` is optional source; `static` is its built, committed publication artifact. Build through the module Makefile.

The manifest embeds built filesystem resources and excludes the harness, local runtime state, generated root lock, package caches, source maps, and test entries. Tests needing a database, host resources, fixtures, or bootloader live in `test/`. A shipped conformance kit is a separate product API.

See [testing](testing.md), [conventions](conventions.md), and [packaging](publishing.md).
