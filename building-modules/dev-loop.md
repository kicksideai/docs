# Development loop

Use the module Makefile for dependency setup, lint, frontend builds, and tests. Resolve local source through the harness's `workspace.replacements`; refresh dependencies before verification.

1. Read the published declarations for the subsystem you extend.
2. Add a failing regression for a behavior fix.
3. Change the owning source and registry entries.
4. Build the module's served frontend when its source changes.
5. Run the focused test and directly affected suite.
6. Run the module gate before releasing a batch.
7. Inspect the result in a fresh published host when shell or integration behavior matters.

Runtime source watching and registry updates follow the application's configured development profile. A source edit and a published package update are different operations. Do not edit generated locks or served JavaScript by hand.

Use exact entry IDs to inspect declarations. Keep runtime state and test databases isolated from an existing installation. See [testing](testing.md) and [packaging](publishing.md).
