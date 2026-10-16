# Agents

Agents combine a prompt, a model, and capabilities. Open **Agents** to create an agent or edit one you can access.

## Configure an agent

- **Prompt** defines the instructions.
- **Model** selects a specific provider model or a model class. A class resolves to the model assigned in **System → Models**.
- **Capabilities** adds groups of tools and their resource settings. Configure each selected knowledge base or connection.
- **Routing** selects delegation or redirect targets and instructions for using them.

**Tools and combinations** provides individual tool selection. Available capabilities come from installed modules; access to a capability does not grant access to every resource it can use.

{{ screenshot:kickside/agent-editor.png }}

Save changes, select the agent in chat, and run a task that exercises the changed capability. A model failure requires checking the model profile; a resource refusal requires checking the resource's sharing and the user's module access.

[Create your first agent](../getting-started/first-agent.md) covers the initial configuration.
