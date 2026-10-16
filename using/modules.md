# Modules and the Hub

**System → Modules** shows the Hub catalog and installed package graph. An administrator reviews the dependency and requirement plan before applying an install or update.

{{ screenshot:kickside/modules.png }}

A module can contribute navigation, views, agent capabilities, providers, converters, Blocks, or backend services. Capability bundles collect package roots for setup; inspect the package list to see what a bundle installs.

After applying a plan, wait for migrations to finish and check the contributed feature. Review dependent resources and workflows before removing a package. Removing a renderer or component implementation can affect existing resources.

Root application self-update through this surface is limited by the application's deployment requirements. See [install a module](../getting-started/first-module.md) and the [module catalog](../reference/modules.md).
