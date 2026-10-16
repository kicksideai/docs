# Build a module

A module is an independently versioned Hub package. It declares registry entries and implements shared contracts for the behavior it owns.

Start from the [module template](https://github.com/kicksideai/module). Its README and Makefile define initialization, build, test, and release commands. It includes a contract binding, writable destination, authenticated API, web component, migration, and standalone database harness.

## Initialize the scaffold

Install Wippy, Git, Make, Node.js 22 or newer, and npm. Clone the template into a new directory:

```sh
git clone https://github.com/kicksideai/module.git notes-module
cd notes-module
```

This example uses the fictional organization `meadow-demo` and a Notes module:

```sh
make init ORG=meadow-demo MODULE_NAME=notes TITLE="Notes" GITHUB_OWNER=meadow-demo
make setup
make lint typecheck build test
```

Choose your own organization and package name when creating a real module. Initialization updates namespace, routes, SQL names, test identity, and bundle metadata together. It runs once; a later attempt with different identity values fails. The initial behavior remains the template's writable log example until you implement the domain.

## Build path

1. Read [discovery and addressing](discovery-addressing-and-context.md) and the [canonical model](canonical-model.md).
2. Set the package identity and [module layout](module-layout.md).
3. Declare host resources as requirements, then implement the domain behavior through [components](component-development.md) and [contracts](contracts-and-ports.md).
4. Add [events and projections](threads-events-projections.md) where the feature needs durable facts or read models.
5. Add [security policies](security-and-module-access.md) and test both allowed and denied paths.
6. Add a [frontend](frontend.md), [agent capability](agents-skills-models.md), or [Block](blocks-flows-workflows.md) when the feature needs it.
7. Run the module's [tests and migrations](testing.md), review the [checklists](checklists.md), and follow [packaging](publishing.md).

Use [application patterns](application-patterns.md) to choose resource boundaries, [recipes](recipes.md) for extension tasks, and the [Deals CRM walkthrough](deals-crm.md) for a composed application.

The published module template's security example can differ from current module policies. Use the exact endpoint and group rules in this handbook; endpoint names do not grant access.

The module template includes a status page that reads the persisted log entry count through its own API. This example shows a new installation with no log entries.

{{ screenshot:module/starter.png }}
