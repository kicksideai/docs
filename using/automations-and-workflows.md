# Automations and workflows

An **Automation** is ongoing configured behavior. A **Workflow** is a versioned visual definition whose runs execute a **Flow**, one durable graph. A **Block** is a reusable step.

## Create and operate an Automation

1. Open **Automations** and select an installed kind.
2. Configure the kind's resources. Data Sync selects a source port, an optional transform, and a destination port; channel responders select their connection and agent.
3. Select the execution principal when the editor offers **Runs as**. Selecting another account requires a delegation grant; resource sharing alone does not grant it.
4. Save the configuration and enable the Automation.
5. Open its details to inspect status and available controls. Check failures before retrying an operation that writes to an external service.

In Data Sync, a transform can explicitly skip an item with a reason. Activity records the skip without a destination write or failed delivery. Returning no value without an explicit skip is a transform failure. See the [transform contract](../building-modules/automations-and-dataflows.md).

The kind declares its supported controls, such as pause, resume, run now, replay, or resync. An administrator of the Automation can inspect **Activity** delivery and control histories. **Runs as** identifies the executor; **Authorized by** identifies the configuring authorizer. The person requesting a control does not replace either identity.

## Build a Workflow

Install `kickside/workflows` to use the visual editor. Create a Workflow, add Blocks from the palette, configure them, and connect their output ports to the next steps. Use validation, publish the definition, then launch a run of that published version.

Published versions are immutable. Editing a draft does not change a running or previously published version. Open run history to inspect progress and terminal results. An accepted launch or trigger event does not prove that every step finishes.

Human-review Blocks create [Inbox](inbox.md) items and park the Flow until a response arrives. Installed modules determine available Blocks and provider-specific waits.

See the developer [composition guide](../building-modules/blocks-flows-workflows.md) and [Automation contracts](../building-modules/automations-and-dataflows.md).
