# Glossary

| Term | Meaning |
| --- | --- |
| Agent | Prompt, model, capabilities, and routing assembled for execution |
| Capability | A trait and its tools/configuration offered in the agent editor |
| Skill | A versioned procedure bundle with files |
| Model class | A role resolved to an assigned provider model |
| Connection | An authorized external-service resource |
| Component | Runtime resource with identity, access, lifecycle, and metadata |
| Component kind | Registry binding stored as the resource's `impl_id` |
| Contract | Stable callable interface declared in the registry |
| Binding | Concrete implementation of contract methods |
| Registry | Typed declarations, not the store of user-created resource instances |
| Public metadata | Safe Component render snapshot |
| Private context | Protected Component configuration and state |
| Thread | Durable immutable event log |
| Projection | Idempotent fold from facts to committed read state |
| Job | Leased scheduled work with an execution deadline |
| Block | One typed executable step |
| Flow | Durable Dataflow graph execution |
| Workflow | Visual definition with immutable published versions |
| Automation | Ongoing configured behavior driven by bounded rounds |
| Port | Block output route or Automation source/destination |
| Principal | Identity under which work executes |
| Authorizer | Account whose authority configures a selected execution principal |
| Group | Composition of policies assigned to accounts |
| Module access | Policy authority to discover and use a feature |
| Component ACL | Record authority, checked in addition to module access |
| Hub ID | Published `organization/module` package identity |
| Requirement | Host-supplied input with exact registry rewrite targets |
