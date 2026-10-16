# Agents, skills, and models

## Traits and tools

A capability in the agent editor is an `agent.trait` registry entry. It supplies a prompt fragment, optional build or per-step prompt function, and tool IDs. `meta.public: true` offers it in the picker; private traits are resolver-attached.

A configured trait declares `meta.context_schema` and its configuration web component. The editor saves the values in `trait_contexts` keyed by the exact trait ID. The resolver validates this configuration before launch.

A tool is a `function.lua` with `meta.type: tool`, input/output schemas, LLM alias and description, and a function entrypoint. Its imports and permitted runtime modules remain explicit. Use `kickside.agents:tools` for normalized, actor-visible discovery.

The resolver assembles the agent's prompt, model selection, configured traits, tools, and routing. Tools execute under the caller's actor and scope. A trait's configuration selects resources; it does not grant access to them.

## Skills

`kickside.skills` stores skills, versions, and files. The `skill_runtime` contract exposes `activate`, `list_files`, and `read_file`. Runtime activation supplies the selected version's procedure and files to the agent; it does not create a separate execution principal.

## Models and artifacts

`kickside.models` discovers provider profiles and models in its catalog and binds `wippy.llm:model_resolver`. Model classes resolve roles to assigned provider models. Keep credentials in the provider's protected configuration.

The artifact capability uses the installed component and renderer catalog. Uploads owns its stored content. A module adds an artifact renderer or tool through its registry declarations and preserves resource checks at invocation.

Test capability discovery, context validation, tool access, missing model configuration, and the actual result under a non-administrator identity.
