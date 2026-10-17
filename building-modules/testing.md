# Testing and migrations

The standalone `test/` harness supplies the host resources the module declares as requirements. Keep it outside the published source tree.

## Register tests

A case is a `function.lua` with `meta.type: test`, `method: run`, and `imports.test: wippy.test:test`. Execute the runner wrapper; declaring cases alone does not run them.

```lua
local test = require("test")
local registry = require("registry")
local function cases()
    test.describe("wiring", function()
        test.it("loads the Inbox destination", function()
            local entry, err = registry.get("kickside.inbox.sink:inbox_sink")
            test.is_nil(err)
            test.not_nil(entry)
        end)
    end)
end
local run_cases = test.run_cases(cases)
return { run = function(options) return run_cases(options) end }
```

The entry also declares the `registry` runtime module and the required package dependency. Check case counts and fail when the runner finds no tests.

## Harness and engines

The harness declares database, authenticated router, gateway, process host, environment storage, and bootloader resources. `ns.dependency.parameters` supplies each module requirement. Local replacements resolve the module under test; refresh dependency resolution before gating.

SQLite enables `foreign_keys: true`. Use an isolated database for each run. A PostgreSQL profile supplies a distinct scratch database and its local connection values. Run both engines for schema or repository changes.

The bootloader completes migrations before tests through `lifecycle.startup: complete`. Test behavior and wiring rather than adding readiness polling.

Cover denied and allowed actors, duplicate writes, retries, rollback, deletion, and committed public metadata. Browser checks cover routing, shell integration, realtime, OAuth, and the served bundle where a module harness cannot.

## Migrations

Declare a migration `function.lua` with `meta.type: migration`, a UTC timestamp, and a host-supplied target database. Ordering uses timestamp then entry ID; `depends_on` does not order migrations.

Use engine-specific SQLite and PostgreSQL branches. A fresh creation declares its final columns, constraints, and indexes. Forward migrations preserve existing data and published interfaces. Changes that retire a stored shape include a forward-only, idempotent, resumable migration in the owning module. Test it with data from the previous published version on both engines. Existing installations receive it through Hub Update all and restart. Parameterize writes and release connections on every path. Product defaults belong in registry declarations or normal domain events.

Use the module Makefile's verification and PostgreSQL targets. The template provides `make setup`, `make lint typecheck build test`, `make postgres-up`, `make test-pg`, and `make postgres-down`.
