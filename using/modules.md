# Modules and the Hub

**System → Modules** shows the Hub catalog and installed package graph. An administrator reviews the dependency and requirement plan before applying an install or update.

![Hub catalog with published module cards in a demonstration workspace](assets/kickside/modules.png)

A module can contribute navigation, views, agent capabilities, providers, converters, Blocks, or backend services. Capability bundles collect package roots for setup; inspect the package list to see what a bundle installs.

After applying a plan, wait for migrations to finish and check the contributed feature. Review dependent resources and workflows before removing a package. Removing a renderer or component implementation can affect existing resources.

Use **System → Modules → Update all**, review the plan, apply it, and restart from the same installation directory. Module migrations update existing data as part of the Hub update; no separate data-conversion step is required. See [install a module](../getting-started/first-module.md) and the [module catalog](../reference/modules.md).
