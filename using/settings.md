# Settings

Open **System → Settings**, select a block, and edit the values it presents. Installed modules supply the blocks, fields, defaults, and custom editors.

The settings database stores administrator overrides. Resetting a value removes its override and uses the module's declared default. Settings supports global values; any resource-specific inheritance belongs to the module that implements it.

Secret fields mask stored values in the list. An empty secret draft keeps the stored value. Model profiles use **System → Models**; branding uses **System → Appearance**.

Listener addresses, database engines, and registry history use runtime deployment configuration. The settings page edits registered application settings.

See the developer [settings reference](../building-modules/settings.md).
