# Packaging and installation

A Hub package has an `organization/module` identity and an independently declared root namespace.

## Manifest

`wippy.yaml` declares organization, module, description, license, repository, keywords, embedded built assets, and exclusions. The publisher selects an immutable release version; the manifest does not pin one.

Declare dependencies as `ns.dependency` with `*` or a `>=` compatibility range. The application lock records resolved versions. Module root locks are generated local state.

Host inputs are `ns.requirement` entries with exact rewrite targets for databases, authenticated routers, servers, process hosts, or security groups. A module does not choose a host-owned resource default. The published member-scope requirement follows the platform default described in [security](security-and-module-access.md).

Exclude `test/**`, `test:**`, local `.wippy`, package caches, source maps, and test metadata. Commit the generated `static` bundle the package serves.

## Verification and release

Run the module Makefile's gates. For the template, run `make setup` followed by `make lint typecheck build test`; SQL changes also run its PostgreSQL targets.

Authenticate with `wippy auth login` and check `wippy auth status`. Use the Wippy CLI or the repository's release workflow to package a reviewed commit. `wippy publish --help` lists version, visibility, module type, and embed options. Inspect a dry run before publishing, and choose public visibility only when the package is ready for public distribution.

Publish dependencies before dependent packages. A published release is immutable; changes require a new version.

## Installation

Use **System → Modules** to review transitive dependencies and host requirements before applying a plan. Check the deployed registry, UI assets, endpoints, and existing component data after migrations complete.

The shell refreshes its catalog after Hub install, uninstall, and migration completion events. Root application self-update through this surface is limited by the application's deployment requirements.
