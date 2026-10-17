# Security and endpoint access

This reference follows the public source declarations for KickSide 0.2.14 and
the modules in the [catalog](modules.md). Optional modules contribute their own
policies and endpoints. Host requirements bind routers and groups at install
time, so a source declaration is not a snapshot of one installation’s bindings.

## Groups and authorization

| Group | Role |
| --- | --- |
| `app.security:admin` | Root administration |
| `app.security:user` | Signed-in baseline: shell, sessions, own profile, agent selection, Jobs, and Core capabilities |
| `app.security:members` | Application default membership, including Core and platform Members |
| `kickside.security.groups:members` | Platform composition of installed public `module_access` policies and policies that declare the Contract member scope |
| `kickside.security.scopes:set_<hash>` | Projected scope for a distinct assigned group set |

Policies union across assigned groups; denies take precedence. Members excludes
**Users management**, while directory discovery and sharing remain available.
For narrower access, remove Members and assign composed groups explicitly.
Access reductions revoke affected sessions. Allow-only expansions do not revoke
sessions; new tokens resolve the updated access. Durable MCP credentials retain
their issuance ceiling, component restrictions, and revocation generations;
reissue a credential to expand its authority.

The authenticated router runs `token_auth` and `endpoint_firewall`, checking
`access` on the exact endpoint ID. The handler also enforces its resource ACL.
Public login, OAuth, webhook, and MCP routes enforce their own protocol admission.
A route being public does not make its operations anonymous.

## Module policies

Public `security.policy` entries with `meta.intent: module_access` contribute
to platform Members. Private companion policies grant the module’s declared
runtime operations. Policies with `meta.intent: tool_access` are separate
selectable capabilities; the default composition does not select them.
`meta.intent: module_management` marks account administration (**Users
management**), which Members also does not select.

The published member-scope requirement defaults to
`kickside.security.groups:members`; an explicit existing host binding wins.
Modules using the shared Contract member interface declare
`meta.member_scope: kickside.contract.http:user_security_scope`. Preserve
requirement IDs and targets when extending policies.

| Surface | Public policy declaration | Purpose |
| --- | --- | --- |
| Component | [`kickside.component.security:module_access`](https://github.com/kicksideai/kickside/blob/main/core/component/src/security/module_access/_index.yaml) | `module_access` |
| Contract | [`kickside.contract.security:module_access`](https://github.com/kicksideai/kickside/blob/main/core/contract/src/security/module_access/_index.yaml) | `module_access` |
| Core | [`kickside.core.security:module_access`](https://github.com/kicksideai/kickside/blob/main/core/core/src/security/module_access/_index.yaml) | `module_access` |
| Execution | [`kickside.execution.security:module_access`](https://github.com/kicksideai/kickside/blob/main/core/execution/src/security/module_access/_index.yaml) | `module_access` |
| Jobs | [`kickside.core.jobs.security:module_access`](https://github.com/kicksideai/kickside/blob/main/core/jobs/src/security/module_access/_index.yaml) | `module_access` |
| Agents | [`kickside.agents.security:module_access`](https://github.com/kicksideai/kickside/blob/main/platform/agents/src/security/module_access/_index.yaml) | `module_access` |
| Automation | [`kickside.automation.security:module_access`](https://github.com/kicksideai/kickside/blob/main/platform/automation/src/security/module_access/_index.yaml) | `module_access` |
| Blocks | [`kickside.blocks.security:module_access`](https://github.com/kicksideai/kickside/blob/main/platform/blocks/src/security/module_access/_index.yaml) | `module_access` |
| Channel | [`kickside.channel.security:module_access`](https://github.com/kicksideai/kickside/blob/main/platform/channel/src/security/module_access/_index.yaml) | `module_access` |
| Connection | [`kickside.connection.security:module_access`](https://github.com/kicksideai/kickside/blob/main/platform/connection/src/security/module_access/_index.yaml) | `module_access` |
| Dm | [`kickside.dm.security:module_access`](https://github.com/kicksideai/kickside/blob/main/platform/dm/src/security/module_access/_index.yaml) | `module_access` |
| Hub | [`kickside.hub.security:module_access`](https://github.com/kicksideai/kickside/blob/main/platform/hub/src/security/module_access/_index.yaml) | `module_access` |
| Identity | [`kickside.identity.security:module_access`](https://github.com/kicksideai/kickside/blob/main/platform/identity/src/security/module_access/_index.yaml) | `module_access` |
| Inbox | [`kickside.inbox.security:module_access`](https://github.com/kicksideai/kickside/blob/main/platform/inbox/src/security/module_access/_index.yaml) | `module_access` |
| Knowledge | [`kickside.knowledge.security:module_access`](https://github.com/kicksideai/kickside/blob/main/platform/knowledge/src/security/module_access/_index.yaml) | `module_access` |
| Mcp | [`kickside.mcp.security:module_access`](https://github.com/kicksideai/kickside/blob/main/platform/mcp/src/security/module_access/_index.yaml) | `module_access` |
| Models | [`kickside.models.security:module_access`](https://github.com/kicksideai/kickside/blob/main/platform/models/src/security/module_access/_index.yaml) | `module_access` |
| Oauth | [`kickside.oauth.security:module_access`](https://github.com/kicksideai/kickside/blob/main/platform/oauth/src/security/module_access/_index.yaml) | `module_access` |
| Realtime | [`kickside.realtime.security:module_access`](https://github.com/kicksideai/kickside/blob/main/platform/realtime/src/security/module_access/_index.yaml) | `module_access` |
| Renderers | [`kickside.renderers.security:module_access`](https://github.com/kicksideai/kickside/blob/main/platform/renderers/src/security/module_access/_index.yaml) | `module_access` |
| Security | [`kickside.security.security:module_access`](https://github.com/kicksideai/kickside/blob/main/platform/security/src/security/module_access/_index.yaml) | `module_access` |
| Self Reflection | [`kickside.self_reflection.security:module_access`](https://github.com/kicksideai/kickside/blob/main/platform/self-reflection/src/security/module_access/_index.yaml) | `module_access` |
| Self Reflection tools | [`kickside.self_reflection.security:tool_access`](https://github.com/kicksideai/kickside/blob/main/platform/self-reflection/src/security/module_access/_index.yaml) | `tool_access` |
| Sessions | [`kickside.sessions.security:module_access`](https://github.com/kicksideai/kickside/blob/main/platform/sessions/src/security/module_access/_index.yaml) | `module_access` |
| Settings | [`kickside.settings.security:module_access`](https://github.com/kicksideai/kickside/blob/main/platform/settings/src/security/module_access/_index.yaml) | `module_access` |
| Skills | [`kickside.skills.security:module_access`](https://github.com/kicksideai/kickside/blob/main/platform/skills/src/security/module_access/_index.yaml) | `module_access` |
| Sync | [`kickside.sync.security:module_access`](https://github.com/kicksideai/kickside/blob/main/platform/sync/src/security/module_access/_index.yaml) | `module_access` |
| Transfer | [`kickside.transfer.security:module_access`](https://github.com/kicksideai/kickside/blob/main/platform/transfer/src/security/module_access/_index.yaml) | `module_access` |
| Transform | [`kickside.transform.security:module_access`](https://github.com/kicksideai/kickside/blob/main/platform/transform/src/security/module_access/_index.yaml) | `module_access` |
| Ui | [`kickside.ui.security:module_access`](https://github.com/kicksideai/kickside/blob/main/platform/ui/src/security/module_access/_index.yaml) | `module_access` |
| Uploads | [`kickside.uploads.security:module_access`](https://github.com/kicksideai/kickside/blob/main/platform/uploads/src/security/module_access/_index.yaml) | `module_access` |
| User directory | [`kickside.users.security:directory_access`](https://github.com/kicksideai/kickside/blob/main/platform/users/src/security/module_access/_index.yaml) | `module_access` |
| Users management | [`kickside.users.security:module_access`](https://github.com/kicksideai/kickside/blob/main/platform/users/src/security/module_access/_index.yaml) | `module_management` |
| Webhooks | [`kickside.webhooks.security:module_access`](https://github.com/kicksideai/kickside/blob/main/platform/webhooks/src/security/module_access/_index.yaml) | `module_access` |
| Widgets | [`kickside.widgets.security:module_access`](https://github.com/kicksideai/kickside/blob/main/platform/widgets/src/security/module_access/_index.yaml) | `module_access` |
| Workflows | [`kickside.workflows.security:module_access`](https://github.com/kicksideai/kickside/blob/main/platform/workflows/src/security/module_access/_index.yaml) | `module_access` |
| Agent Onboarding | [`kickside.agent_onboarding.security:module_access`](https://github.com/kicksideai/components/blob/main/agent-onboarding/src/security/module_access/_index.yaml) | `module_access` |
| Dashboard | [`kickside.dashboard.security:module_access`](https://github.com/kicksideai/components/blob/main/dashboard/src/security/module_access/_index.yaml) | `module_access` |
| Research | [`kickside.research.security:module_access`](https://github.com/kicksideai/components/blob/main/research/src/security/module_access/_index.yaml) | `module_access` |
| SSO | [`kickside.sso.security:module_access`](https://github.com/kicksideai/components/blob/main/sso/src/security/module_access/_index.yaml) | `module_access` |
| Asr | [`kickside.asr.security:module_access`](https://github.com/kicksideai/providers/blob/main/asr/src/security/module_access/_index.yaml) | `module_access` |
| Atlassian | [`kickside.atlassian.security:module_access`](https://github.com/kicksideai/providers/blob/main/atlassian/src/security/module_access/_index.yaml) | `module_access` |
| Bitbucket | [`kickside.bitbucket.security:module_access`](https://github.com/kicksideai/providers/blob/main/bitbucket/src/security/module_access/_index.yaml) | `module_access` |
| Code Execution | [`kickside.code_execution.security:module_access`](https://github.com/kicksideai/providers/blob/main/code_execution/src/security/module_access/_index.yaml) | `module_access` |
| Discord | [`kickside.discord.security:module_access`](https://github.com/kicksideai/providers/blob/main/discord/src/security/module_access/_index.yaml) | `module_access` |
| Fireflies | [`kickside.fireflies.security:module_access`](https://github.com/kicksideai/providers/blob/main/fireflies/src/security/module_access/_index.yaml) | `module_access` |
| Github | [`kickside.github.security:module_access`](https://github.com/kicksideai/providers/blob/main/github/src/security/module_access/_index.yaml) | `module_access` |
| Gitlab | [`kickside.gitlab.security:module_access`](https://github.com/kicksideai/providers/blob/main/gitlab/src/security/module_access/_index.yaml) | `module_access` |
| Google | [`kickside.google.security:module_access`](https://github.com/kicksideai/providers/blob/main/google/src/security/module_access/_index.yaml) | `module_access` |
| Hubspot | [`kickside.hubspot.security:module_access`](https://github.com/kicksideai/providers/blob/main/hubspot/src/security/module_access/_index.yaml) | `module_access` |
| Kb10 | [`kickside.kb10.security:module_access`](https://github.com/kicksideai/providers/blob/main/kb10/src/security/module_access/_index.yaml) | `module_access` |
| Llm Ocr | [`kickside.llm_ocr.security:module_access`](https://github.com/kicksideai/providers/blob/main/llm-ocr/src/security/module_access/_index.yaml) | `module_access` |
| Mcp Client | [`kickside.mcp_client.security:module_access`](https://github.com/kicksideai/providers/blob/main/mcp-client/src/security/module_access/_index.yaml) | `module_access` |
| Memory | [`kickside.memory.security:module_access`](https://github.com/kicksideai/providers/blob/main/memory/src/security/module_access/_index.yaml) | `module_access` |
| Phantombuster | [`kickside.phantombuster.security:module_access`](https://github.com/kicksideai/providers/blob/main/phantombuster/src/security/module_access/_index.yaml) | `module_access` |
| Simplefin | [`kickside.simplefin.security:module_access`](https://github.com/kicksideai/providers/blob/main/simplefin/src/security/module_access/_index.yaml) | `module_access` |
| Slack | [`kickside.slack.security:module_access`](https://github.com/kicksideai/providers/blob/main/slack/src/security/module_access/_index.yaml) | `module_access` |
| Sso Github | [`kickside.sso.providers.github.security:module_access`](https://github.com/kicksideai/providers/blob/main/sso-github/src/security/module_access/_index.yaml) | `module_access` |
| Sso Google | [`kickside.sso.providers.google.security:module_access`](https://github.com/kicksideai/providers/blob/main/sso-google/src/security/module_access/_index.yaml) | `module_access` |
| Sso Microsoft | [`kickside.sso.providers.microsoft.security:module_access`](https://github.com/kicksideai/providers/blob/main/sso-microsoft/src/security/module_access/_index.yaml) | `module_access` |
| Sso Oidc | [`kickside.sso.providers.oidc.security:module_access`](https://github.com/kicksideai/providers/blob/main/sso-oidc/src/security/module_access/_index.yaml) | `module_access` |
| Telegram | [`kickside.telegram.security:module_access`](https://github.com/kicksideai/providers/blob/main/telegram/src/security/module_access/_index.yaml) | `module_access` |
| Webscout | [`kickside.webscout.security:module_access`](https://github.com/kicksideai/providers/blob/main/webscout/src/security/module_access/_index.yaml) | `module_access` |
| Webscout Brave | [`kickside.webscout.providers.brave.security:module_access`](https://github.com/kicksideai/providers/blob/main/webscout-brave/src/security/module_access/_index.yaml) | `module_access` |
| Webscout Tavily | [`kickside.webscout.providers.tavily.security:module_access`](https://github.com/kicksideai/providers/blob/main/webscout-tavily/src/security/module_access/_index.yaml) | `module_access` |
| Doc2Md | [`kickside.convert.doc2md.security:module_access`](https://github.com/kicksideai/converters/blob/main/doc2md/src/security/module_access/_index.yaml) | `module_access` |
| Html2Pdf | [`kickside.convert.html2pdf.security:module_access`](https://github.com/kicksideai/converters/blob/main/html2pdf/src/security/module_access/_index.yaml) | `module_access` |
| Pdf2Image | [`kickside.convert.pdf2image.security:module_access`](https://github.com/kicksideai/converters/blob/main/pdf2image/src/security/module_access/_index.yaml) | `module_access` |
| CRM | [`kickside.crm.security:module_access`](https://github.com/kicksideai/crm/blob/main/src/security/module_access/_index.yaml) | `module_access` |
| Db Schema | [`chestor.db_schema.security:module_access`](https://github.com/kicksideai/chestor/blob/main/db-schema/src/security/module_access/_index.yaml) | `module_access` |
| Db Schema tools | [`chestor.db_schema.security:module_tools`](https://github.com/kicksideai/chestor/blob/main/db-schema/src/security/module_access/_index.yaml) | `tool_access` |
| Graph | [`chestor.graph.security:module_access`](https://github.com/kicksideai/chestor/blob/main/graph/src/security/module_access/_index.yaml) | `module_access` |
| Graph tools | [`chestor.graph.security:module_tools`](https://github.com/kicksideai/chestor/blob/main/graph/src/security/module_access/_index.yaml) | `tool_access` |
| Journal | [`chestor.journal.security:module_access`](https://github.com/kicksideai/chestor/blob/main/journal/src/security/module_access/_index.yaml) | `module_access` |
| Journal tools | [`chestor.journal.security:module_tools`](https://github.com/kicksideai/chestor/blob/main/journal/src/security/module_access/_index.yaml) | `tool_access` |
| Roadmap | [`chestor.roadmap.security:module_access`](https://github.com/kicksideai/chestor/blob/main/roadmap/src/security/module_access/_index.yaml) | `module_access` |
| Roadmap tools | [`chestor.roadmap.security:module_tools`](https://github.com/kicksideai/chestor/blob/main/roadmap/src/security/module_access/_index.yaml) | `tool_access` |
| Workspace | [`chestor.workspace.security:module_access`](https://github.com/kicksideai/chestor/blob/main/workspace/src/security/module_access/_index.yaml) | `module_access` |
| Workspace tools | [`chestor.workspace.security:module_tools`](https://github.com/kicksideai/chestor/blob/main/workspace/src/security/module_access/_index.yaml) | `tool_access` |

## Endpoint inventory

Paths below are relative to the declared router. KickSide mounts the authenticated
API at `/api/v1` and the public API at `/api/public`. A host-supplied router is
shown by its requirement ID; it can have a different mount in another host.
Endpoint links open the owning source declaration. Consult that module’s docs
for request/result schemas and operation-specific access checks.

| Registry ID | Method | Relative path | Router or host requirement |
| --- | --- | --- | --- |
| [`app.api.websocket:ws_endpoint.endpoint`](https://github.com/kicksideai/kickside/blob/main/app/src/app/api/websocket/_index.yaml) | `GET` | `/ws/join` | `app:api` |
| [`app.env:public_env_endpoint`](https://github.com/kicksideai/kickside/blob/main/app/src/app/env/_index.yaml) | `GET` | `/env/public.js` | `app:api.public` |
| [`app.health:endpoint`](https://github.com/kicksideai/kickside/blob/main/app/src/app/health/_index.yaml) | `GET` | `/health` | `app:api.public` |
| [`app.login:endpoint`](https://github.com/kicksideai/kickside/blob/main/app/src/app/login/_index.yaml) | `GET` | `/login` | `app:web` |
| [`app.seo:robots.endpoint`](https://github.com/kicksideai/kickside/blob/main/app/src/app/seo/_index.yaml) | `GET` | `/robots.txt` | `wippy.facade:web_router` |
| [`app.seo:llms.endpoint`](https://github.com/kicksideai/kickside/blob/main/app/src/app/seo/_index.yaml) | `GET` | `/llms.txt` | `wippy.facade:web_router` |
| [`kickside.component.api:access_model.endpoint`](https://github.com/kicksideai/kickside/blob/main/core/component/src/api/_index.yaml) | `GET` | `/components/access-model` | `kickside.component:api_router` |
| [`kickside.component.api:list_component_access.endpoint`](https://github.com/kicksideai/kickside/blob/main/core/component/src/api/_index.yaml) | `GET` | `/component-access/grants/{id}` | `kickside.component:api_router` |
| [`kickside.component.api:share_component.endpoint`](https://github.com/kicksideai/kickside/blob/main/core/component/src/api/_index.yaml) | `POST` | `/component-access/share/{id}` | `kickside.component:api_router` |
| [`kickside.component.api:adopt_component.endpoint`](https://github.com/kicksideai/kickside/blob/main/core/component/src/api/_index.yaml) | `POST` | `/component-access/adopt/{id}` | `kickside.component:api_router` |
| [`kickside.core.projections.api:register_projection.endpoint`](https://github.com/kicksideai/kickside/blob/main/core/core/src/projections/api/_index.yaml) | `POST` | `/threads/{id}/projections` | `kickside.core.projections:api_router` |
| [`kickside.core.projections.api:remove_projection.endpoint`](https://github.com/kicksideai/kickside/blob/main/core/core/src/projections/api/_index.yaml) | `POST` | `/threads/{id}/projections/remove` | `kickside.core.projections:api_router` |
| [`kickside.core.projections.api:pause_projection.endpoint`](https://github.com/kicksideai/kickside/blob/main/core/core/src/projections/api/_index.yaml) | `PUT` | `/threads/{id}/projections/pause` | `kickside.core.projections:api_router` |
| [`kickside.core.projections.api:resume_projection.endpoint`](https://github.com/kicksideai/kickside/blob/main/core/core/src/projections/api/_index.yaml) | `PUT` | `/threads/{id}/projections/resume` | `kickside.core.projections:api_router` |
| [`kickside.core.projections.api:list_projection_cursors.endpoint`](https://github.com/kicksideai/kickside/blob/main/core/core/src/projections/api/_index.yaml) | `GET` | `/threads/{id}/projections` | `kickside.core.projections:api_router` |
| [`kickside.core.retention.api:get_thread_retention.endpoint`](https://github.com/kicksideai/kickside/blob/main/core/core/src/retention/api/_index.yaml) | `GET` | `/threads/{id}/retention` | `kickside.core.retention:api_router` |
| [`kickside.core.retention.api:upsert_thread_retention.endpoint`](https://github.com/kicksideai/kickside/blob/main/core/core/src/retention/api/_index.yaml) | `PUT` | `/threads/{id}/retention` | `kickside.core.retention:api_router` |
| [`kickside.core.threads.api:list_jobs.endpoint`](https://github.com/kicksideai/kickside/blob/main/core/core/src/threads/api/_index.yaml) | `GET` | `/jobs` | `kickside.core.threads:api_router` |
| [`kickside.core.threads.api:list_job_runs.endpoint`](https://github.com/kicksideai/kickside/blob/main/core/core/src/threads/api/_index.yaml) | `GET` | `/job-runs` | `kickside.core.threads:api_router` |
| [`kickside.core.threads.api:create_thread.endpoint`](https://github.com/kicksideai/kickside/blob/main/core/core/src/threads/api/_index.yaml) | `POST` | `/threads` | `kickside.core.threads:api_router` |
| [`kickside.core.threads.api:get_thread.endpoint`](https://github.com/kicksideai/kickside/blob/main/core/core/src/threads/api/_index.yaml) | `GET` | `/threads/{id}` | `kickside.core.threads:api_router` |
| [`kickside.core.threads.api:update_thread.endpoint`](https://github.com/kicksideai/kickside/blob/main/core/core/src/threads/api/_index.yaml) | `PATCH` | `/threads/{id}` | `kickside.core.threads:api_router` |
| [`kickside.core.threads.api:delete_thread.endpoint`](https://github.com/kicksideai/kickside/blob/main/core/core/src/threads/api/_index.yaml) | `DELETE` | `/threads/{id}` | `kickside.core.threads:api_router` |
| [`kickside.core.threads.api:list_threads.endpoint`](https://github.com/kicksideai/kickside/blob/main/core/core/src/threads/api/_index.yaml) | `GET` | `/threads` | `kickside.core.threads:api_router` |
| [`kickside.core.threads.api:list_classes.endpoint`](https://github.com/kicksideai/kickside/blob/main/core/core/src/threads/api/_index.yaml) | `GET` | `/thread-classes` | `kickside.core.threads:api_router` |
| [`kickside.core.threads.api:list_children.endpoint`](https://github.com/kicksideai/kickside/blob/main/core/core/src/threads/api/_index.yaml) | `GET` | `/threads/{id}/children` | `kickside.core.threads:api_router` |
| [`kickside.core.threads.api:get_graph.endpoint`](https://github.com/kicksideai/kickside/blob/main/core/core/src/threads/api/_index.yaml) | `GET` | `/threads/{id}/graph` | `kickside.core.threads:api_router` |
| [`kickside.core.threads.api:post_message.endpoint`](https://github.com/kicksideai/kickside/blob/main/core/core/src/threads/api/_index.yaml) | `POST` | `/threads/{id}/messages` | `kickside.core.threads:api_router` |
| [`kickside.core.threads.api:post_event.endpoint`](https://github.com/kicksideai/kickside/blob/main/core/core/src/threads/api/_index.yaml) | `POST` | `/threads/{id}/events` | `kickside.core.threads:api_router` |
| [`kickside.core.threads.api:list_events.endpoint`](https://github.com/kicksideai/kickside/blob/main/core/core/src/threads/api/_index.yaml) | `GET` | `/threads/{id}/events` | `kickside.core.threads:api_router` |
| [`kickside.core.threads.api:ingest_events_batch.endpoint`](https://github.com/kicksideai/kickside/blob/main/core/core/src/threads/api/_index.yaml) | `POST` | `/threads/{id}/events/batch` | `kickside.core.threads:api_router` |
| [`kickside.agents.api:list_user_agents.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/agents/src/api/_index.yaml) | `GET` | `/user-agents` | `kickside.agents:api_router` |
| [`kickside.agents.api:get_user_agent.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/agents/src/api/_index.yaml) | `GET` | `/user-agents/{id}` | `kickside.agents:api_router` |
| [`kickside.agents.api:create_user_agent.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/agents/src/api/_index.yaml) | `POST` | `/user-agents` | `kickside.agents:api_router` |
| [`kickside.agents.api:update_user_agent.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/agents/src/api/_index.yaml) | `PUT` | `/user-agents/{id}` | `kickside.agents:api_router` |
| [`kickside.agents.api:delete_user_agent.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/agents/src/api/_index.yaml) | `DELETE` | `/user-agents/{id}` | `kickside.agents:api_router` |
| [`kickside.agents.api:list_agents.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/agents/src/api/_index.yaml) | `GET` | `/agents/list` | `kickside.agents:api_router` |
| [`kickside.agents.api:agents_by_name.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/agents/src/api/_index.yaml) | `GET` | `/agents/by-name` | `kickside.agents:api_router` |
| [`kickside.agents.api:list_traits.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/agents/src/api/_index.yaml) | `GET` | `/agents/traits` | `kickside.agents:api_router` |
| [`kickside.agents.api:list_namespaces.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/agents/src/api/_index.yaml) | `GET` | `/agents/namespaces` | `kickside.agents:api_router` |
| [`kickside.agents.api:list_tools.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/agents/src/api/_index.yaml) | `GET` | `/agents/tools` | `kickside.agents:api_router` |
| [`kickside.agents.api:list_memory_options.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/agents/src/api/_index.yaml) | `GET` | `/agents/memory-options` | `kickside.agents:api_router` |
| [`kickside.automation.api:list_types.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/automation/src/api/_index.yaml) | `GET` | `/automations/types` | `kickside.automation:api_router` |
| [`kickside.automation.api:list_sources.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/automation/src/api/_index.yaml) | `GET` | `/automations/sources` | `kickside.automation:api_router` |
| [`kickside.automation.api:list_sinks.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/automation/src/api/_index.yaml) | `GET` | `/automations/sinks` | `kickside.automation:api_router` |
| [`kickside.automation.api:list.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/automation/src/api/_index.yaml) | `GET` | `/automations` | `kickside.automation:api_router` |
| [`kickside.automation.api:install.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/automation/src/api/_index.yaml) | `POST` | `/automations` | `kickside.automation:api_router` |
| [`kickside.automation.api:install_selected.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/automation/src/api/_index.yaml) | `POST` | `/automations/selected` | `kickside.automation:api_router` |
| [`kickside.automation.api:delete.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/automation/src/api/_index.yaml) | `DELETE` | `/automations/{id}` | `kickside.automation:api_router` |
| [`kickside.automation.api:read_state.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/automation/src/api/_index.yaml) | `GET` | `/automations/{id}/state` | `kickside.automation:api_router` |
| [`kickside.automation.api:read_config.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/automation/src/api/_index.yaml) | `GET` | `/automations/{id}/config` | `kickside.automation:api_router` |
| [`kickside.automation.api:export.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/automation/src/api/_index.yaml) | `GET` | `/automations/{id}/export` | `kickside.automation:api_router` |
| [`kickside.automation.api:import.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/automation/src/api/_index.yaml) | `POST` | `/automations/import` | `kickside.automation:api_router` |
| [`kickside.automation.api:reconfigure.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/automation/src/api/_index.yaml) | `PUT` | `/automations/{id}` | `kickside.automation:api_router` |
| [`kickside.automation.api:update_meta.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/automation/src/api/_index.yaml) | `PATCH` | `/automations/{id}` | `kickside.automation:api_router` |
| [`kickside.automation.api:status.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/automation/src/api/_index.yaml) | `GET` | `/automations/{id}/status` | `kickside.automation:api_router` |
| [`kickside.automation.api:history.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/automation/src/api/_index.yaml) | `GET` | `/automations/{id}/history` | `kickside.automation:api_router` |
| [`kickside.automation.api:health.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/automation/src/api/_index.yaml) | `GET` | `/automations/health` | `kickside.automation:api_router` |
| [`kickside.automation.api:get_execution_identity.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/automation/src/api/_index.yaml) | `GET` | `/automations/{id}/identity` | `kickside.automation:api_router` |
| [`kickside.automation.api:set_execution_identity.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/automation/src/api/_index.yaml) | `POST` | `/automations/{id}/identity` | `kickside.automation:api_router` |
| [`kickside.automation.api:drive_control.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/automation/src/api/_index.yaml) | `POST` | `/automations/{id}/control` | `kickside.automation:api_router` |
| [`kickside.automation.api:call_action.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/automation/src/api/_index.yaml) | `POST` | `/automations/{id}/actions/{method}` | `kickside.automation:api_router` |
| [`kickside.automation.api:source_samples.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/automation/src/api/_index.yaml) | `POST` | `/automations/source-samples` | `kickside.automation:api_router` |
| [`kickside.connection.api:list_connections.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/connection/src/api/_index.yaml) | `GET` | `/connections` | `kickside.connection:api_router` |
| [`kickside.connection.api:create_connection.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/connection/src/api/_index.yaml) | `POST` | `/connections` | `kickside.connection:api_router` |
| [`kickside.connection.api:discover_providers.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/connection/src/api/_index.yaml) | `GET` | `/connections/providers/discover` | `kickside.connection:api_router` |
| [`kickside.connection.api:provider_badges.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/connection/src/api/_index.yaml) | `GET` | `/connections/providers/badges` | `kickside.connection:api_router` |
| [`kickside.connection.api:delete_connection.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/connection/src/api/_index.yaml) | `DELETE` | `/connections/{id}` | `kickside.connection:api_router` |
| [`kickside.connection.api:update_connection.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/connection/src/api/_index.yaml) | `PUT` | `/connections/{id}` | `kickside.connection:api_router` |
| [`kickside.connection.api:discover_resources.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/connection/src/api/_index.yaml) | `POST` | `/connections/{id}/discover_resources` | `kickside.connection:api_router` |
| [`kickside.hub.api:hub_auth_status.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/hub/src/api/_index.yaml) | `GET` | `/hub/auth` | `kickside.hub:api_router` |
| [`kickside.hub.api:hub_auth_set.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/hub/src/api/_index.yaml) | `POST` | `/hub/auth` | `kickside.hub:api_router` |
| [`kickside.hub.api:hub_auth_clear.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/hub/src/api/_index.yaml) | `DELETE` | `/hub/auth` | `kickside.hub:api_router` |
| [`kickside.hub.api:required_setup_status.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/hub/src/api/_index.yaml) | `GET` | `/hub/required-setup` | `kickside.hub:api_router` |
| [`kickside.hub.api:required_setup_apply.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/hub/src/api/_index.yaml) | `POST` | `/hub/required-setup` | `kickside.hub:api_router` |
| [`kickside.hub.instruments:requirement_resolution.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/hub/src/instruments/_index.yaml) | `POST` | `/onboarding/requirement-resolution` | `kickside.hub:api_router` |
| [`kickside.hub.instruments:recommendations.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/hub/src/instruments/_index.yaml) | `POST` | `/onboarding/module-recommendations` | `kickside.hub:api_router` |
| [`kickside.identity.api:generate_link_code.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/identity/src/api/_index.yaml) | `POST` | `/identity/link-codes` | `kickside.identity:api_router` |
| [`kickside.identity.api:list_links.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/identity/src/api/_index.yaml) | `GET` | `/identity/links` | `kickside.identity:api_router` |
| [`kickside.identity.api:unlink.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/identity/src/api/_index.yaml) | `POST` | `/identity/unlink` | `kickside.identity:api_router` |
| [`kickside.inbox.api:list_inbox.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/inbox/src/api/_index.yaml) | `GET` | `/inbox` | `kickside.inbox:api_router` |
| [`kickside.inbox.api:list_item_types.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/inbox/src/api/_index.yaml) | `GET` | `/inbox/item-types` | `kickside.inbox:api_router` |
| [`kickside.inbox.api:create_item.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/inbox/src/api/_index.yaml) | `POST` | `/inbox` | `kickside.inbox:api_router` |
| [`kickside.inbox.api:resolve_item.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/inbox/src/api/_index.yaml) | `POST` | `/inbox/{id}/{action}` | `kickside.inbox:api_router` |
| [`kickside.inbox.api:delete_item.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/inbox/src/api/_index.yaml) | `DELETE` | `/inbox/{id}` | `kickside.inbox:api_router` |
| [`kickside.knowledge.api:list_kb.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/knowledge/src/api/_index.yaml) | `GET` | `/knowledge/list` | `kickside.knowledge:api_router` |
| [`kickside.knowledge.api:list_engines.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/knowledge/src/api/_index.yaml) | `GET` | `/knowledge/engines` | `kickside.knowledge:api_router` |
| [`kickside.knowledge.api:create_kb.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/knowledge/src/api/_index.yaml) | `POST` | `/knowledge/create` | `kickside.knowledge:api_router` |
| [`kickside.knowledge.api:get_kb.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/knowledge/src/api/_index.yaml) | `GET` | `/knowledge/{id}` | `kickside.knowledge:api_router` |
| [`kickside.knowledge.api:delete_kb.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/knowledge/src/api/_index.yaml) | `DELETE` | `/knowledge/{id}` | `kickside.knowledge:api_router` |
| [`kickside.knowledge.api:update_kb.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/knowledge/src/api/_index.yaml) | `PUT` | `/knowledge/{id}` | `kickside.knowledge:api_router` |
| [`kickside.knowledge.api:upload_token.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/knowledge/src/api/_index.yaml) | `POST` | `/knowledge/{id}/upload-token` | `kickside.knowledge:api_router` |
| [`kickside.knowledge.api:ingest_content.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/knowledge/src/api/_index.yaml) | `POST` | `/knowledge/{id}/ingest` | `kickside.knowledge:api_router` |
| [`kickside.knowledge.api:delete_content.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/knowledge/src/api/_index.yaml) | `DELETE` | `/knowledge/{id}/content` | `kickside.knowledge:api_router` |
| [`kickside.knowledge.api:ingest_existing_upload.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/knowledge/src/api/_index.yaml) | `POST` | `/knowledge/{id}/ingest-upload` | `kickside.knowledge:api_router` |
| [`kickside.knowledge.api:search.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/knowledge/src/api/_index.yaml) | `POST` | `/knowledge/{id}/search` | `kickside.knowledge:api_router` |
| [`kickside.knowledge.api:ask.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/knowledge/src/api/_index.yaml) | `POST` | `/knowledge/{id}/ask` | `kickside.knowledge:api_router` |
| [`kickside.knowledge.api:list_embedding_models.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/knowledge/src/api/_index.yaml) | `GET` | `/knowledge/models` | `kickside.knowledge:api_router` |
| [`kickside.knowledge.api:organize.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/knowledge/src/api/_index.yaml) | `POST` | `/knowledge/organize` | `kickside.knowledge:api_router` |
| [`kickside.mcp.api:serve_mcp.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/mcp/src/api/_index.yaml) | `POST` | `/mcp` | `kickside.mcp:public_router` |
| [`kickside.mcp.api:serve_mcp.get.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/mcp/src/api/_index.yaml) | `GET` | `/mcp` | `kickside.mcp:public_router` |
| [`kickside.mcp.api:serve_mcp.delete.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/mcp/src/api/_index.yaml) | `DELETE` | `/mcp` | `kickside.mcp:public_router` |
| [`kickside.mcp.api:create_credential.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/mcp/src/api/_index.yaml) | `POST` | `/mcp/credentials` | `kickside.mcp:api_router` |
| [`kickside.mcp.api:update_credential.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/mcp/src/api/_index.yaml) | `PATCH` | `/mcp/credentials/{id}` | `kickside.mcp:api_router` |
| [`kickside.mcp.api:list_credentials.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/mcp/src/api/_index.yaml) | `GET` | `/mcp/credentials` | `kickside.mcp:api_router` |
| [`kickside.mcp.api:revoke_credential.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/mcp/src/api/_index.yaml) | `POST` | `/mcp/credentials/{id}/revoke` | `kickside.mcp:api_router` |
| [`kickside.mcp.api:delete_credential.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/mcp/src/api/_index.yaml) | `DELETE` | `/mcp/credentials/{id}` | `kickside.mcp:api_router` |
| [`kickside.mcp.api:list_tools.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/mcp/src/api/_index.yaml) | `GET` | `/mcp/tools` | `kickside.mcp:api_router` |
| [`kickside.mcp.api:list_components.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/mcp/src/api/_index.yaml) | `GET` | `/mcp/components` | `kickside.mcp:api_router` |
| [`kickside.mcp.api:list_presets.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/mcp/src/api/_index.yaml) | `GET` | `/mcp/presets` | `kickside.mcp:api_router` |
| [`kickside.mcp.oauth:well_known_resource.standard_endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/mcp/src/oauth/_index.yaml) | `GET` | `/oauth-protected-resource/api/public/mcp` | `well_known_router` |
| [`kickside.mcp.oauth:well_known_resource.root_endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/mcp/src/oauth/_index.yaml) | `GET` | `/oauth-protected-resource` | `kickside.mcp.oauth:well_known_router` |
| [`kickside.mcp.oauth:well_known_auth_server.standard_endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/mcp/src/oauth/_index.yaml) | `GET` | `/oauth-authorization-server/api/public/mcp/oauth` | `well_known_router` |
| [`kickside.mcp.oauth:well_known_auth_server.root_endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/mcp/src/oauth/_index.yaml) | `GET` | `/oauth-authorization-server` | `kickside.mcp.oauth:well_known_router` |
| [`kickside.mcp.oauth:well_known_resource.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/mcp/src/oauth/_index.yaml) | `GET` | `/mcp/.well-known/oauth-protected-resource` | `kickside.mcp:public_router` |
| [`kickside.mcp.oauth:well_known_auth_server.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/mcp/src/oauth/_index.yaml) | `GET` | `/mcp/oauth/.well-known/oauth-authorization-server` | `kickside.mcp:public_router` |
| [`kickside.mcp.oauth:register.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/mcp/src/oauth/_index.yaml) | `POST` | `/mcp/oauth/register` | `kickside.mcp:public_router` |
| [`kickside.mcp.oauth:token.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/mcp/src/oauth/_index.yaml) | `POST` | `/mcp/oauth/token` | `kickside.mcp:public_router` |
| [`kickside.mcp.oauth:authorize.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/mcp/src/oauth/_index.yaml) | `GET` | `/mcp/oauth/authorize` | `kickside.mcp:public_router` |
| [`kickside.mcp.oauth:context.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/mcp/src/oauth/_index.yaml) | `GET` | `/mcp/oauth/context` | `kickside.mcp:api_router` |
| [`kickside.mcp.oauth:consent.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/mcp/src/oauth/_index.yaml) | `POST` | `/mcp/oauth/consent` | `kickside.mcp:api_router` |
| [`kickside.models.api:list_models.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/models/src/api/_index.yaml) | `GET` | `/models/list` | `kickside.models:api_router` |
| [`kickside.models.api:list_model_classes.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/models/src/api/_index.yaml) | `GET` | `/models/classes` | `kickside.models:api_router` |
| [`kickside.models.api:models_by_name.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/models/src/api/_index.yaml) | `GET` | `/models/by-name` | `kickside.models:api_router` |
| [`kickside.models.api.admin:admin.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/models/src/api/admin/_index.yaml) | `GET` | `/models/admin` | `kickside.models:api_router` |
| [`kickside.models.api.admin:create_profile.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/models/src/api/admin/_index.yaml) | `POST` | `/models/provider-profiles` | `kickside.models:api_router` |
| [`kickside.models.api.admin:update_profile.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/models/src/api/admin/_index.yaml) | `PUT` | `/models/provider-profiles/{id}` | `kickside.models:api_router` |
| [`kickside.models.api.admin:delete_profile.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/models/src/api/admin/_index.yaml) | `DELETE` | `/models/provider-profiles/{id}` | `kickside.models:api_router` |
| [`kickside.models.api.admin:discover_profile.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/models/src/api/admin/_index.yaml) | `POST` | `/models/provider-profiles/{id}/discover` | `kickside.models:api_router` |
| [`kickside.models.api.admin:test_profile.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/models/src/api/admin/_index.yaml) | `POST` | `/models/provider-profiles/{id}/test` | `kickside.models:api_router` |
| [`kickside.models.api.admin:test_card.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/models/src/api/admin/_index.yaml) | `POST` | `/models/cards/test` | `kickside.models:api_router` |
| [`kickside.models.api.admin:upsert_card.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/models/src/api/admin/_index.yaml) | `PUT` | `/models/cards` | `kickside.models:api_router` |
| [`kickside.models.api.admin:delete_card.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/models/src/api/admin/_index.yaml) | `DELETE` | `/models/cards` | `kickside.models:api_router` |
| [`kickside.oauth.api:discover_providers.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/oauth/src/api/_index.yaml) | `GET` | `/oauth/providers/discover` | `kickside.oauth:api_router` |
| [`kickside.oauth.api:get_connection_details.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/oauth/src/api/_index.yaml) | `GET` | `/oauth/connections/{component_id}` | `kickside.oauth:api_router` |
| [`kickside.oauth.api:get_provider_info.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/oauth/src/api/_index.yaml) | `GET` | `/oauth/providers/{provider_name}` | `kickside.oauth:api_router` |
| [`kickside.oauth.api:init_connection.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/oauth/src/api/_index.yaml) | `POST` | `/oauth/providers/{provider_name}/init` | `kickside.oauth:api_router` |
| [`kickside.oauth.api:update_connection.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/oauth/src/api/_index.yaml) | `PUT` | `/oauth/connections/{component_id}` | `kickside.oauth:api_router` |
| [`kickside.oauth.api.public:oauth_callback.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/oauth/src/api/public/_index.yaml) | `POST` | `/oauth/callback` | `kickside.oauth:public_api_router` |
| [`kickside.oauth.api.public:oauth_callback_page.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/oauth/src/api/public/_index.yaml) | `GET` | `/oauth/callback` | `kickside.oauth:public_api_router` |
| [`kickside.renderers.api:list_renderers.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/renderers/src/api/_index.yaml) | `GET` | `/renderers` | `kickside.renderers:api_router` |
| [`kickside.security.api:projection_status.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/security/src/api/_index.yaml) | `GET` | `/security/projection` | `kickside.security:api_router` |
| [`kickside.security.api:delegation_save.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/security/src/api/_index.yaml) | `POST` | `/security/delegations` | `kickside.security:api_router` |
| [`kickside.security.api:delegation_revoke.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/security/src/api/_index.yaml) | `DELETE` | `/security/delegations` | `kickside.security:api_router` |
| [`kickside.security.api:delegation_list.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/security/src/api/_index.yaml) | `GET` | `/security/delegations` | `kickside.security:api_router` |
| [`kickside.security.api:list_scopes.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/security/src/api/_index.yaml) | `GET` | `/security/scopes` | `kickside.security:api_router` |
| [`kickside.security.api:list_policies.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/security/src/api/_index.yaml) | `GET` | `/security/policies` | `kickside.security:api_router` |
| [`kickside.security.api:save_scope.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/security/src/api/_index.yaml) | `POST` | `/security/scopes` | `kickside.security:api_router` |
| [`kickside.security.api:delete_scope.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/security/src/api/_index.yaml) | `DELETE` | `/security/scopes` | `kickside.security:api_router` |
| [`kickside.sessions.api:start_token.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/sessions/src/api/_index.yaml) | `POST` | `/sessions/start-token` | `kickside.sessions:api_router` |
| [`kickside.sessions.api:favorite.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/sessions/src/api/_index.yaml) | `POST` | `/sessions/favorite` | `kickside.sessions:api_router` |
| [`kickside.settings.api:get_about.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/settings/src/api/_index.yaml) | `GET` | `/settings/about` | `kickside.settings:api_router` |
| [`kickside.settings.api:list_settings.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/settings/src/api/_index.yaml) | `GET` | `/settings` | `kickside.settings:api_router` |
| [`kickside.settings.api:list_blocks.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/settings/src/api/_index.yaml) | `GET` | `/settings/blocks` | `kickside.settings:api_router` |
| [`kickside.settings.api:put_settings.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/settings/src/api/_index.yaml) | `PUT` | `/settings` | `kickside.settings:api_router` |
| [`kickside.skills.api:list_skills.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/skills/src/api/_index.yaml) | `GET` | `/skills` | `kickside.skills:api_router` |
| [`kickside.skills.api:get_skill.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/skills/src/api/_index.yaml) | `GET` | `/skills/{id}` | `kickside.skills:api_router` |
| [`kickside.skills.api:list_versions.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/skills/src/api/_index.yaml) | `GET` | `/skills/{id}/versions` | `kickside.skills:api_router` |
| [`kickside.skills.api:create_skill.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/skills/src/api/_index.yaml) | `POST` | `/skills` | `kickside.skills:api_router` |
| [`kickside.skills.api:refine_skill.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/skills/src/api/_index.yaml) | `PATCH` | `/skills/{id}` | `kickside.skills:api_router` |
| [`kickside.skills.api:delete_skill.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/skills/src/api/_index.yaml) | `DELETE` | `/skills/{id}` | `kickside.skills:api_router` |
| [`kickside.skills.api:read_file.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/skills/src/api/_index.yaml) | `GET` | `/skills/{id}/file` | `kickside.skills:api_router` |
| [`kickside.transfer.api:list_exportable.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/transfer/src/api/_index.yaml) | `GET` | `/transfer/exportable` | `kickside.transfer:api_router` |
| [`kickside.transfer.api:export.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/transfer/src/api/_index.yaml) | `POST` | `/transfer/export` | `kickside.transfer:api_router` |
| [`kickside.transfer.api:import.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/transfer/src/api/_index.yaml) | `POST` | `/transfer/import` | `kickside.transfer:api_router` |
| [`kickside.transform.api:assist.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/transform/src/api/_index.yaml) | `POST` | `/transform/assist` | `kickside.transform:api_router` |
| [`kickside.transform.api:validate.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/transform/src/api/_index.yaml) | `POST` | `/transform/validate` | `kickside.transform:api_router` |
| [`kickside.transform.api:snippet.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/transform/src/api/_index.yaml) | `POST` | `/transform/snippet` | `kickside.transform:api_router` |
| [`kickside.ui.api:list_nav.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/ui/src/api/_index.yaml) | `GET` | `/nav/list` | `kickside.ui:api_router` |
| [`kickside.ui.api:list_contributions.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/ui/src/api/_index.yaml) | `GET` | `/ui/contributions` | `kickside.ui:api_router` |
| [`kickside.ui.api:list_settings_tabs.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/ui/src/api/_index.yaml) | `GET` | `/settings/tabs` | `kickside.ui:api_router` |
| [`kickside.ui.api:list_account_items.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/ui/src/api/_index.yaml) | `GET` | `/account/items` | `kickside.ui:api_router` |
| [`kickside.ui.api:mark_splash_seen.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/ui/src/api/_index.yaml) | `POST` | `/ui/splash/{id}/seen` | `kickside.ui:api_router` |
| [`kickside.ui.api:mark_splash_unseen.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/ui/src/api/_index.yaml) | `DELETE` | `/ui/splash/{id}/seen` | `kickside.ui:api_router` |
| [`kickside.ui.api:reset_splashes.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/ui/src/api/_index.yaml) | `DELETE` | `/ui/splash/seen` | `kickside.ui:api_router` |
| [`kickside.ui.api:set_config.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/ui/src/api/_index.yaml) | `PUT` | `/nav/config` | `kickside.ui:api_router` |
| [`kickside.ui.api:upload_logo.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/ui/src/api/_index.yaml) | `POST` | `/nav/logo` | `kickside.ui:api_router` |
| [`kickside.ui.api:get_branding.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/ui/src/api/_index.yaml) | `GET` | `/branding` | `kickside.ui:public_api_router` |
| [`kickside.ui.api:get_logo.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/ui/src/api/_index.yaml) | `GET` | `/branding/logo` | `kickside.ui:public_api_router` |
| [`kickside.uploads.api:complete_handler.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/uploads/src/api/_index.yaml) | `POST` | `/uploads/complete` | `kickside.uploads:api_router` |
| [`kickside.uploads.api:delete_handler.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/uploads/src/api/_index.yaml) | `DELETE` | `/uploads/{uuid}` | `kickside.uploads:api_router` |
| [`kickside.uploads.api:get_handler.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/uploads/src/api/_index.yaml) | `GET` | `/uploads/{uuid}` | `kickside.uploads:api_router` |
| [`kickside.uploads.api:list_handler.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/uploads/src/api/_index.yaml) | `GET` | `/uploads/list` | `kickside.uploads:api_router` |
| [`kickside.uploads.api:presigned_handler.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/uploads/src/api/_index.yaml) | `POST` | `/uploads/presigned` | `kickside.uploads:api_router` |
| [`kickside.uploads.api:upload_handler.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/uploads/src/api/_index.yaml) | `POST` | `/uploads` | `kickside.uploads:api_router` |
| [`kickside.uploads.api:raw_handler.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/uploads/src/api/_index.yaml) | `GET` | `/uploads/{uuid}/raw` | `kickside.uploads:api_router` |
| [`kickside.uploads.api:artifacts_handler.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/uploads/src/api/_index.yaml) | `GET` | `/uploads/{uuid}/artifacts` | `kickside.uploads:api_router` |
| [`kickside.uploads.api:artifact_raw_handler.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/uploads/src/api/_index.yaml) | `GET` | `/uploads/{uuid}/artifacts/{artifact_id}/raw` | `kickside.uploads:api_router` |
| [`kickside.users.api:bot_accounts_create.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/users/src/api/_index.yaml) | `POST` | `/users/bots` | `kickside.users:api_router` |
| [`kickside.users.api:bot_accounts_list.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/users/src/api/_index.yaml) | `GET` | `/users/bots` | `kickside.users:api_router` |
| [`kickside.users.api:run_as_candidates.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/users/src/api/_index.yaml) | `GET` | `/users/run-as-candidates` | `kickside.users:api_router` |
| [`kickside.users.api:login.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/users/src/api/_index.yaml) | `POST` | `/user/token` | `kickside.users:public_router` |
| [`kickside.users.api:me.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/users/src/api/_index.yaml) | `GET` | `/user/me` | `kickside.users:api_router` |
| [`kickside.users.api:update_me.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/users/src/api/_index.yaml) | `PUT` | `/user/me` | `kickside.users:api_router` |
| [`kickside.users.api:logout.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/users/src/api/_index.yaml) | `POST` | `/user/logout` | `kickside.users:api_router` |
| [`kickside.users.api:list_assignable_scopes.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/users/src/api/_index.yaml) | `GET` | `/users/assignable-scopes` | `kickside.users:api_router` |
| [`kickside.users.api:get_profile.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/users/src/api/_index.yaml) | `GET` | `/profile` | `kickside.users:api_router` |
| [`kickside.users.api:put_profile.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/users/src/api/_index.yaml) | `PUT` | `/profile` | `kickside.users:api_router` |
| [`kickside.users.api:principals_search.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/users/src/api/_index.yaml) | `GET` | `/principals/search` | `kickside.users:api_router` |
| [`kickside.users.api:principals_resolve.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/users/src/api/_index.yaml) | `POST` | `/principals/resolve` | `kickside.users:api_router` |
| [`kickside.users.api:list_users.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/users/src/api/_index.yaml) | `GET` | `/users` | `kickside.users:api_router` |
| [`kickside.users.api:create_user.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/users/src/api/_index.yaml) | `POST` | `/users` | `kickside.users:api_router` |
| [`kickside.users.api:delete_user.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/users/src/api/_index.yaml) | `DELETE` | `/users/{id}` | `kickside.users:api_router` |
| [`kickside.users.api:update_user.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/users/src/api/_index.yaml) | `PUT` | `/users/{id}` | `kickside.users:api_router` |
| [`kickside.users.api:get_user_groups.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/users/src/api/_index.yaml) | `GET` | `/users/{id}/groups` | `kickside.users:api_router` |
| [`kickside.users.api:set_user_groups.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/users/src/api/_index.yaml) | `PUT` | `/users/{id}/groups` | `kickside.users:api_router` |
| [`kickside.webhooks.api:create_webhook.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/webhooks/src/api/_index.yaml) | `POST` | `/webhooks` | `kickside.webhooks:api_router` |
| [`kickside.webhooks.api:list_webhooks.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/webhooks/src/api/_index.yaml) | `GET` | `/webhooks` | `kickside.webhooks:api_router` |
| [`kickside.webhooks.api:update_webhook.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/webhooks/src/api/_index.yaml) | `PATCH` | `/webhooks/{id}` | `kickside.webhooks:api_router` |
| [`kickside.webhooks.api:revoke_webhook.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/webhooks/src/api/_index.yaml) | `POST` | `/webhooks/{id}/revoke` | `kickside.webhooks:api_router` |
| [`kickside.webhooks.api:delete_webhook.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/webhooks/src/api/_index.yaml) | `DELETE` | `/webhooks/{id}` | `kickside.webhooks:api_router` |
| [`kickside.webhooks.api.public:post_hook.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/webhooks/src/api/public/_index.yaml) | `POST` | `/hooks/{id}` | `kickside.webhooks:public_router` |
| [`kickside.widgets.api:create_view_resolver.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/widgets/src/api/_index.yaml) | `GET` | `/component-kinds/create-view` | `kickside.widgets:api_router` |
| [`kickside.workflows.api:create_workflow.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/workflows/src/api/_index.yaml) | `POST` | `/workflows` | `kickside.workflows:api_router` |
| [`kickside.workflows.api:list_workflows.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/workflows/src/api/_index.yaml) | `GET` | `/workflows` | `kickside.workflows:api_router` |
| [`kickside.workflows.api:list_published.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/workflows/src/api/_index.yaml) | `GET` | `/workflows/published` | `kickside.workflows:api_router` |
| [`kickside.workflows.api:get_state.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/workflows/src/api/_index.yaml) | `GET` | `/workflows/{id}/state` | `kickside.workflows:api_router` |
| [`kickside.workflows.api:export_definition.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/workflows/src/api/_index.yaml) | `GET` | `/workflows/{id}/export` | `kickside.workflows:api_router` |
| [`kickside.workflows.api:import_definition.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/workflows/src/api/_index.yaml) | `POST` | `/workflows/import` | `kickside.workflows:api_router` |
| [`kickside.workflows.api:get_events.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/workflows/src/api/_index.yaml) | `GET` | `/workflows/{id}/events` | `kickside.workflows:api_router` |
| [`kickside.workflows.api:apply.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/workflows/src/api/_index.yaml) | `POST` | `/workflows/{id}/apply` | `kickside.workflows:api_router` |
| [`kickside.workflows.api:set_workflow_labels.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/workflows/src/api/_index.yaml) | `POST` | `/workflows/{id}/labels` | `kickside.workflows:api_router` |
| [`kickside.workflows.api:undo.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/workflows/src/api/_index.yaml) | `POST` | `/workflows/{id}/undo` | `kickside.workflows:api_router` |
| [`kickside.workflows.api:redo.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/workflows/src/api/_index.yaml) | `POST` | `/workflows/{id}/redo` | `kickside.workflows:api_router` |
| [`kickside.workflows.api:delete_workflow.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/workflows/src/api/_index.yaml) | `DELETE` | `/workflows/{id}` | `kickside.workflows:api_router` |
| [`kickside.workflows.api:publish.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/workflows/src/api/_index.yaml) | `POST` | `/workflows/{id}/publish` | `kickside.workflows:api_router` |
| [`kickside.workflows.api:list_versions.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/workflows/src/api/_index.yaml) | `GET` | `/workflows/{id}/versions` | `kickside.workflows:api_router` |
| [`kickside.workflows.api:get_version.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/workflows/src/api/_index.yaml) | `GET` | `/workflows/{id}/versions/{n}` | `kickside.workflows:api_router` |
| [`kickside.workflows.api:diff_versions.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/workflows/src/api/_index.yaml) | `GET` | `/workflows/{id}/versions/diff` | `kickside.workflows:api_router` |
| [`kickside.workflows.api:restore_version.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/workflows/src/api/_index.yaml) | `POST` | `/workflows/{id}/versions/{n}/restore` | `kickside.workflows:api_router` |
| [`kickside.workflows.api:run.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/workflows/src/api/_index.yaml) | `POST` | `/workflows/{id}/run` | `kickside.workflows:api_router` |
| [`kickside.workflows.api:simulate.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/workflows/src/api/_index.yaml) | `POST` | `/workflows/{id}/simulate` | `kickside.workflows:api_router` |
| [`kickside.workflows.api:list_runs.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/workflows/src/api/_index.yaml) | `GET` | `/workflows/{id}/runs` | `kickside.workflows:api_router` |
| [`kickside.workflows.api:get_run.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/workflows/src/api/_index.yaml) | `GET` | `/workflows/{id}/runs/{run_id}` | `kickside.workflows:api_router` |
| [`kickside.workflows.api:run_node_data.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/workflows/src/api/_index.yaml) | `GET` | `/workflows/{id}/runs/{run_id}/nodes/{def_node_id}/data` | `kickside.workflows:api_router` |
| [`kickside.workflows.api:run_events.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/workflows/src/api/_index.yaml) | `GET` | `/workflows/{id}/runs/{run_id}/events` | `kickside.workflows:api_router` |
| [`kickside.workflows.api:run_export.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/workflows/src/api/_index.yaml) | `GET` | `/workflows/{id}/runs/{run_id}/export` | `kickside.workflows:api_router` |
| [`kickside.workflows.api:assist_edge.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/workflows/src/api/_index.yaml) | `POST` | `/workflows/{id}/assist/edge` | `kickside.workflows:api_router` |
| [`kickside.workflows.api:assist_binding.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/workflows/src/api/_index.yaml) | `POST` | `/workflows/{id}/assist/binding` | `kickside.workflows:api_router` |
| [`kickside.workflows.api:assist_schema.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/workflows/src/api/_index.yaml) | `POST` | `/workflows/assist/schema` | `kickside.workflows:api_router` |
| [`kickside.workflows.api:assist_config.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/workflows/src/api/_index.yaml) | `POST` | `/workflows/{id}/assist/config` | `kickside.workflows:api_router` |
| [`kickside.workflows.api:blocks_api.endpoint`](https://github.com/kicksideai/kickside/blob/main/platform/workflows/src/api/_index.yaml) | `GET` | `/workflows/blocks` | `kickside.workflows:api_router` |
| [`kickside.dashboard:overview.endpoint`](https://github.com/kicksideai/components/blob/main/dashboard/src/_index.yaml) | `GET` | `/dashboard/overview` | `kickside.dashboard:api_router` |
| [`kickside.research:submit.endpoint`](https://github.com/kicksideai/components/blob/main/research/src/_index.yaml) | `POST` | `/research` | `kickside.research:api_router` |
| [`kickside.research:status.endpoint`](https://github.com/kicksideai/components/blob/main/research/src/_index.yaml) | `GET` | `/research/list` | `kickside.research:api_router` |
| [`kickside.research:detail.endpoint`](https://github.com/kicksideai/components/blob/main/research/src/_index.yaml) | `GET` | `/research/{id}/events` | `kickside.research:api_router` |
| [`kickside.sso.api:list_providers.endpoint`](https://github.com/kicksideai/components/blob/main/sso/src/api/_index.yaml) | `GET` | `/sso/providers` | `kickside.sso:public_api_router` |
| [`kickside.sso.api:list_admin_providers.endpoint`](https://github.com/kicksideai/components/blob/main/sso/src/api/_index.yaml) | `GET` | `/sso/providers` | `kickside.sso:api_router` |
| [`kickside.sso.api:list_connections.endpoint`](https://github.com/kicksideai/components/blob/main/sso/src/api/_index.yaml) | `GET` | `/sso/connections` | `kickside.sso:api_router` |
| [`kickside.sso.api:link_start.endpoint`](https://github.com/kicksideai/components/blob/main/sso/src/api/_index.yaml) | `POST` | `/sso/{provider}/link` | `kickside.sso:api_router` |
| [`kickside.sso.api:unlink.endpoint`](https://github.com/kicksideai/components/blob/main/sso/src/api/_index.yaml) | `DELETE` | `/sso/{provider}/link` | `kickside.sso:api_router` |
| [`kickside.sso.api:start.endpoint`](https://github.com/kicksideai/components/blob/main/sso/src/api/_index.yaml) | `GET` | `/sso/{provider}/start` | `kickside.sso:public_api_router` |
| [`kickside.sso.api:callback.endpoint`](https://github.com/kicksideai/components/blob/main/sso/src/api/_index.yaml) | `GET` | `/sso/{provider}/callback` | `kickside.sso:public_api_router` |
| [`kickside.code_execution:sdk_reference.endpoint`](https://github.com/kicksideai/providers/blob/main/code_execution/src/_index.yaml) | `GET` | `/code-execution/sdk-reference` | `kickside.code_execution:api_router` |
| [`kickside.code_execution:assist.endpoint`](https://github.com/kicksideai/providers/blob/main/code_execution/src/_index.yaml) | `POST` | `/code-execution/assist` | `kickside.code_execution:api_router` |
| [`kickside.code_execution:recommend_tools_api.endpoint`](https://github.com/kicksideai/providers/blob/main/code_execution/src/_index.yaml) | `POST` | `/code-execution/recommend-tools` | `kickside.code_execution:api_router` |
| [`kickside.kb10.api:browse.endpoint`](https://github.com/kicksideai/providers/blob/main/kb10/src/api/_index.yaml) | `GET` | `/kb10/{id}/browse` | `kickside.kb10:api_router` |
| [`kickside.kb10.api:graph.endpoint`](https://github.com/kicksideai/providers/blob/main/kb10/src/api/_index.yaml) | `GET` | `/kb10/{id}/graph` | `kickside.kb10:api_router` |
| [`kickside.kb10.api:search.endpoint`](https://github.com/kicksideai/providers/blob/main/kb10/src/api/_index.yaml) | `GET` | `/kb10/{id}/search` | `kickside.kb10:api_router` |
| [`kickside.kb10.api:delete_node.endpoint`](https://github.com/kicksideai/providers/blob/main/kb10/src/api/_index.yaml) | `DELETE` | `/kb10/{id}/nodes/{node_id}` | `kickside.kb10:api_router` |
| [`kickside.kb10.api:concepts_create.endpoint`](https://github.com/kicksideai/providers/blob/main/kb10/src/api/_index.yaml) | `POST` | `/kb10/{id}/concepts` | `kickside.kb10:api_router` |
| [`kickside.kb10.api:concepts_update.endpoint`](https://github.com/kicksideai/providers/blob/main/kb10/src/api/_index.yaml) | `PATCH` | `/kb10/{id}/concepts/{node_id}` | `kickside.kb10:api_router` |
| [`kickside.kb10.api:concepts_move.endpoint`](https://github.com/kicksideai/providers/blob/main/kb10/src/api/_index.yaml) | `PUT` | `/kb10/{id}/concepts/{node_id}/parent` | `kickside.kb10:api_router` |
| [`kickside.kb10.api:concepts_delete.endpoint`](https://github.com/kicksideai/providers/blob/main/kb10/src/api/_index.yaml) | `DELETE` | `/kb10/{id}/concepts/{node_id}` | `kickside.kb10:api_router` |
| [`kickside.kb10.api:source.endpoint`](https://github.com/kicksideai/providers/blob/main/kb10/src/api/_index.yaml) | `GET` | `/kb10/{id}/nodes/{node_id}/source` | `kickside.kb10:api_router` |
| [`kickside.kb10.api:enrichment.endpoint`](https://github.com/kicksideai/providers/blob/main/kb10/src/api/_index.yaml) | `POST` | `/kb10/{id}/enrichment` | `kickside.kb10:api_router` |
| [`kickside.kb10.api:reembed.endpoint`](https://github.com/kicksideai/providers/blob/main/kb10/src/api/_index.yaml) | `POST` | `/kb10/{id}/reembed` | `kickside.kb10:api_router` |
| [`kickside.kb10.api:resummarize.endpoint`](https://github.com/kicksideai/providers/blob/main/kb10/src/api/_index.yaml) | `POST` | `/kb10/{id}/resummarize` | `kickside.kb10:api_router` |
| [`kickside.kb10.api:maintenance_get.endpoint`](https://github.com/kicksideai/providers/blob/main/kb10/src/api/_index.yaml) | `GET` | `/kb10/{id}/maintenance` | `kickside.kb10:api_router` |
| [`kickside.mcp_client.api:reconnect.endpoint`](https://github.com/kicksideai/providers/blob/main/mcp-client/src/api/_index.yaml) | `PUT` | `/mcp-client/connections/{id}` | `kickside.mcp_client:api_router` |
| [`kickside.simplefin.api:rotate.endpoint`](https://github.com/kicksideai/providers/blob/main/simplefin/src/api/_index.yaml) | `PUT` | `/simplefin/connections/{id}` | `kickside.simplefin:api_router` |
| [`kickside.webscout.api:list_providers.endpoint`](https://github.com/kicksideai/providers/blob/main/webscout/src/api/_index.yaml) | `GET` | `/webscout/providers` | `kickside.webscout:api_router` |
| [`kickside.crm.api:bootstrap.endpoint`](https://github.com/kicksideai/crm/blob/main/src/api/_index.yaml) | `GET` | `/workspace/crm` | `kickside.crm:api_router` |
| [`kickside.crm.api:create.endpoint`](https://github.com/kicksideai/crm/blob/main/src/api/_index.yaml) | `POST` | `/workspace/crm` | `kickside.crm:api_router` |
| [`kickside.crm.api:get.endpoint`](https://github.com/kicksideai/crm/blob/main/src/api/_index.yaml) | `GET` | `/workspace/crm/{id}` | `kickside.crm:api_router` |
| [`kickside.crm.api:panels.endpoint`](https://github.com/kicksideai/crm/blob/main/src/api/_index.yaml) | `GET` | `/workspace/crm/{id}/panels/{object_type}` | `kickside.crm:api_router` |
| [`kickside.crm.api:apply.endpoint`](https://github.com/kicksideai/crm/blob/main/src/api/_index.yaml) | `POST` | `/workspace/crm/{id}/apply` | `kickside.crm:api_router` |
| [`kickside.crm.api:schema.get.endpoint`](https://github.com/kicksideai/crm/blob/main/src/api/_index.yaml) | `GET` | `/workspace/crm/{id}/schema` | `kickside.crm:api_router` |
| [`kickside.crm.api:schema.apply.endpoint`](https://github.com/kicksideai/crm/blob/main/src/api/_index.yaml) | `POST` | `/workspace/crm/{id}/schema` | `kickside.crm:api_router` |
| [`kickside.crm.api:import_config.endpoint`](https://github.com/kicksideai/crm/blob/main/src/api/_index.yaml) | `POST` | `/workspace/crm/{id}/config/import` | `kickside.crm:api_router` |
| [`kickside.crm.api:export_config.endpoint`](https://github.com/kicksideai/crm/blob/main/src/api/_index.yaml) | `GET` | `/workspace/crm/{id}/config/export` | `kickside.crm:api_router` |
| [`kickside.crm.api:query.endpoint`](https://github.com/kicksideai/crm/blob/main/src/api/_index.yaml) | `POST` | `/workspace/crm/{id}/query` | `kickside.crm:api_router` |
| [`kickside.crm.api:resolve.endpoint`](https://github.com/kicksideai/crm/blob/main/src/api/_index.yaml) | `POST` | `/workspace/crm/{id}/resolve` | `kickside.crm:api_router` |
| [`chestor.db_schema.api:get_schema.endpoint`](https://github.com/kicksideai/chestor/blob/main/db-schema/src/api/_index.yaml) | `GET` | `/workspace/db-schema/{id}` | `chestor.db_schema:api_router` |
| [`chestor.db_schema.api:apply_schema.endpoint`](https://github.com/kicksideai/chestor/blob/main/db-schema/src/api/_index.yaml) | `POST` | `/workspace/db-schema/{id}/apply` | `chestor.db_schema:api_router` |
| [`chestor.db_schema.api:list_tables.endpoint`](https://github.com/kicksideai/chestor/blob/main/db-schema/src/api/_index.yaml) | `GET` | `/workspace/db-schema/{id}/tables` | `chestor.db_schema:api_router` |
| [`chestor.db_schema.api:list_relations.endpoint`](https://github.com/kicksideai/chestor/blob/main/db-schema/src/api/_index.yaml) | `GET` | `/workspace/db-schema/{id}/relations` | `chestor.db_schema:api_router` |
| [`chestor.db_schema.api:list_indexes.endpoint`](https://github.com/kicksideai/chestor/blob/main/db-schema/src/api/_index.yaml) | `GET` | `/workspace/db-schema/{id}/indexes` | `chestor.db_schema:api_router` |
| [`chestor.graph.api:get_graph.endpoint`](https://github.com/kicksideai/chestor/blob/main/graph/src/api/_index.yaml) | `GET` | `/workspace/graphs/{id}` | `chestor.graph:api_router` |
| [`chestor.graph.api:apply_graph.endpoint`](https://github.com/kicksideai/chestor/blob/main/graph/src/api/_index.yaml) | `POST` | `/workspace/graphs/{id}/apply` | `chestor.graph:api_router` |
| [`chestor.graph.api:undo_graph.endpoint`](https://github.com/kicksideai/chestor/blob/main/graph/src/api/_index.yaml) | `POST` | `/workspace/graphs/{id}/undo` | `chestor.graph:api_router` |
| [`chestor.graph.api:redo_graph.endpoint`](https://github.com/kicksideai/chestor/blob/main/graph/src/api/_index.yaml) | `POST` | `/workspace/graphs/{id}/redo` | `chestor.graph:api_router` |
| [`chestor.graph.api:list_nodes.endpoint`](https://github.com/kicksideai/chestor/blob/main/graph/src/api/_index.yaml) | `GET` | `/workspace/graphs/{id}/nodes` | `chestor.graph:api_router` |
| [`chestor.graph.api:list_edges.endpoint`](https://github.com/kicksideai/chestor/blob/main/graph/src/api/_index.yaml) | `GET` | `/workspace/graphs/{id}/edges` | `chestor.graph:api_router` |
| [`chestor.graph.api:list_materials.endpoint`](https://github.com/kicksideai/chestor/blob/main/graph/src/api/_index.yaml) | `GET` | `/workspace/graphs/{id}/materials` | `chestor.graph:api_router` |
| [`chestor.graph.api:get_schema.endpoint`](https://github.com/kicksideai/chestor/blob/main/graph/src/api/_index.yaml) | `GET` | `/workspace/graphs/{id}/schema` | `chestor.graph:api_router` |
| [`chestor.journal.api:get_journal.endpoint`](https://github.com/kicksideai/chestor/blob/main/journal/src/api/_index.yaml) | `GET` | `/workspace/journals/{id}` | `chestor.journal:api_router` |
| [`chestor.journal.api:get_health.endpoint`](https://github.com/kicksideai/chestor/blob/main/journal/src/api/_index.yaml) | `GET` | `/workspace/journals/{id}/health` | `chestor.journal:api_router` |
| [`chestor.journal.api:apply_events.endpoint`](https://github.com/kicksideai/chestor/blob/main/journal/src/api/_index.yaml) | `POST` | `/workspace/journals/{id}/apply` | `chestor.journal:api_router` |
| [`chestor.journal.api:append_entry.endpoint`](https://github.com/kicksideai/chestor/blob/main/journal/src/api/_index.yaml) | `POST` | `/workspace/journals/{id}/events` | `chestor.journal:api_router` |
| [`chestor.journal.api:list_events.endpoint`](https://github.com/kicksideai/chestor/blob/main/journal/src/api/_index.yaml) | `GET` | `/workspace/journals/{id}/events` | `chestor.journal:api_router` |
| [`chestor.journal.api:get_event.endpoint`](https://github.com/kicksideai/chestor/blob/main/journal/src/api/_index.yaml) | `GET` | `/workspace/journals/{id}/events/{event_id}` | `chestor.journal:api_router` |
| [`chestor.journal.api:get_updates.endpoint`](https://github.com/kicksideai/chestor/blob/main/journal/src/api/_index.yaml) | `GET` | `/workspace/journals/{id}/updates` | `chestor.journal:api_router` |
| [`chestor.journal.api:get_context_pack.endpoint`](https://github.com/kicksideai/chestor/blob/main/journal/src/api/_index.yaml) | `GET` | `/workspace/journals/{id}/context_pack` | `chestor.journal:api_router` |
| [`chestor.journal.api:get_branch.endpoint`](https://github.com/kicksideai/chestor/blob/main/journal/src/api/_index.yaml) | `GET` | `/workspace/journals/{id}/branch` | `chestor.journal:api_router` |
| [`chestor.journal.api:get_frontier.endpoint`](https://github.com/kicksideai/chestor/blob/main/journal/src/api/_index.yaml) | `GET` | `/workspace/journals/{id}/frontier` | `chestor.journal:api_router` |
| [`chestor.journal.api:get_cursors.endpoint`](https://github.com/kicksideai/chestor/blob/main/journal/src/api/_index.yaml) | `GET` | `/workspace/journals/{id}/cursors` | `chestor.journal:api_router` |
| [`chestor.journal.api:get_spans.endpoint`](https://github.com/kicksideai/chestor/blob/main/journal/src/api/_index.yaml) | `GET` | `/workspace/journals/{id}/spans` | `chestor.journal:api_router` |
| [`chestor.journal.api:get_activity.endpoint`](https://github.com/kicksideai/chestor/blob/main/journal/src/api/_index.yaml) | `GET` | `/workspace/journals/{id}/activity` | `chestor.journal:api_router` |
| [`chestor.journal.api:get_changes.endpoint`](https://github.com/kicksideai/chestor/blob/main/journal/src/api/_index.yaml) | `GET` | `/workspace/journals/{id}/changes` | `chestor.journal:api_router` |
| [`chestor.journal.api:get_tree.endpoint`](https://github.com/kicksideai/chestor/blob/main/journal/src/api/_index.yaml) | `GET` | `/workspace/journals/{id}/tree` | `chestor.journal:api_router` |
| [`chestor.journal.api:upsert_task.endpoint`](https://github.com/kicksideai/chestor/blob/main/journal/src/api/_index.yaml) | `POST` | `/workspace/journals/{id}/tasks` | `chestor.journal:api_router` |
| [`chestor.journal.api:transition_task.endpoint`](https://github.com/kicksideai/chestor/blob/main/journal/src/api/_index.yaml) | `POST` | `/workspace/journals/{id}/tasks/{task_id}/transition` | `chestor.journal:api_router` |
| [`chestor.journal.api:link_artifact.endpoint`](https://github.com/kicksideai/chestor/blob/main/journal/src/api/_index.yaml) | `POST` | `/workspace/journals/{id}/artifacts` | `chestor.journal:api_router` |
| [`chestor.journal.api:focus_task.endpoint`](https://github.com/kicksideai/chestor/blob/main/journal/src/api/_index.yaml) | `POST` | `/workspace/journals/{id}/focus` | `chestor.journal:api_router` |
| [`chestor.journal.api:search_journal.endpoint`](https://github.com/kicksideai/chestor/blob/main/journal/src/api/_index.yaml) | `POST` | `/workspace/journals/{id}/search` | `chestor.journal:api_router` |
| [`chestor.journal.api:search_journal_text.endpoint`](https://github.com/kicksideai/chestor/blob/main/journal/src/api/_index.yaml) | `POST` | `/workspace/journals/{id}/search_text` | `chestor.journal:api_router` |
| [`chestor.journal.api:update_digest.endpoint`](https://github.com/kicksideai/chestor/blob/main/journal/src/api/_index.yaml) | `PUT` | `/workspace/journals/{id}/digest` | `chestor.journal:api_router` |
| [`chestor.journal.api:create_checkpoint.endpoint`](https://github.com/kicksideai/chestor/blob/main/journal/src/api/_index.yaml) | `POST` | `/workspace/journals/{id}/checkpoints` | `chestor.journal:api_router` |
| [`chestor.journal.api:list_graphs.endpoint`](https://github.com/kicksideai/chestor/blob/main/journal/src/api/_index.yaml) | `GET` | `/workspace/journals/{id}/graphs` | `chestor.journal:api_router` |
| [`chestor.journal.api:query_graph.endpoint`](https://github.com/kicksideai/chestor/blob/main/journal/src/api/_index.yaml) | `GET` | `/workspace/journals/{id}/graphs/{graph_id}` | `chestor.journal:api_router` |
| [`chestor.journal.api:apply_graph_ops.endpoint`](https://github.com/kicksideai/chestor/blob/main/journal/src/api/_index.yaml) | `POST` | `/workspace/journals/{id}/graphs/{graph_id}/ops` | `chestor.journal:api_router` |
| [`chestor.journal.api:configure_graph.endpoint`](https://github.com/kicksideai/chestor/blob/main/journal/src/api/_index.yaml) | `PUT` | `/workspace/journals/{id}/graphs/{graph_id}/config` | `chestor.journal:api_router` |
| [`chestor.journal.api:event_graphs.endpoint`](https://github.com/kicksideai/chestor/blob/main/journal/src/api/_index.yaml) | `GET` | `/workspace/journals/{id}/events/{event_id}/graphs` | `chestor.journal:api_router` |
| [`chestor.journal.api:assemble_graph.endpoint`](https://github.com/kicksideai/chestor/blob/main/journal/src/api/_index.yaml) | `POST` | `/workspace/journals/{id}/graphs/{graph_id}/assemble` | `chestor.journal:api_router` |
| [`chestor.journal.api:get_assembly.endpoint`](https://github.com/kicksideai/chestor/blob/main/journal/src/api/_index.yaml) | `GET` | `/workspace/journals/{id}/graphs/{graph_id}/assemble` | `chestor.journal:api_router` |
| [`chestor.roadmap.api:get_roadmap.endpoint`](https://github.com/kicksideai/chestor/blob/main/roadmap/src/api/_index.yaml) | `GET` | `/workspace/roadmaps/{id}` | `chestor.roadmap:api_router` |
| [`chestor.roadmap.api:apply_roadmap.endpoint`](https://github.com/kicksideai/chestor/blob/main/roadmap/src/api/_index.yaml) | `POST` | `/workspace/roadmaps/{id}/apply` | `chestor.roadmap:api_router` |
| [`chestor.roadmap.api:undo_roadmap.endpoint`](https://github.com/kicksideai/chestor/blob/main/roadmap/src/api/_index.yaml) | `POST` | `/workspace/roadmaps/{id}/undo` | `chestor.roadmap:api_router` |
| [`chestor.roadmap.api:redo_roadmap.endpoint`](https://github.com/kicksideai/chestor/blob/main/roadmap/src/api/_index.yaml) | `POST` | `/workspace/roadmaps/{id}/redo` | `chestor.roadmap:api_router` |
| [`chestor.roadmap.api:list_initiatives.endpoint`](https://github.com/kicksideai/chestor/blob/main/roadmap/src/api/_index.yaml) | `GET` | `/workspace/roadmaps/{id}/initiatives` | `chestor.roadmap:api_router` |
| [`chestor.roadmap.api:get_dependencies.endpoint`](https://github.com/kicksideai/chestor/blob/main/roadmap/src/api/_index.yaml) | `GET` | `/workspace/roadmaps/{id}/dependencies` | `chestor.roadmap:api_router` |
| [`chestor.roadmap.api:get_critical.endpoint`](https://github.com/kicksideai/chestor/blob/main/roadmap/src/api/_index.yaml) | `GET` | `/workspace/roadmaps/{id}/critical` | `chestor.roadmap:api_router` |
| [`chestor.roadmap.api:get_schema.endpoint`](https://github.com/kicksideai/chestor/blob/main/roadmap/src/api/_index.yaml) | `GET` | `/workspace/roadmaps/{id}/schema` | `chestor.roadmap:api_router` |
| [`chestor.workspace.api:list_entries.endpoint`](https://github.com/kicksideai/chestor/blob/main/workspace/src/api/_index.yaml) | `GET` | `/workspace/entries` | `chestor.workspace:api_router` |
| [`chestor.workspace.api:list_entry_types.endpoint`](https://github.com/kicksideai/chestor/blob/main/workspace/src/api/_index.yaml) | `GET` | `/workspace/entries/types` | `chestor.workspace:api_router` |
| [`chestor.workspace.api:get_entry.endpoint`](https://github.com/kicksideai/chestor/blob/main/workspace/src/api/_index.yaml) | `GET` | `/workspace/entries/{id}` | `chestor.workspace:api_router` |
| [`chestor.workspace.api:get_breadcrumbs.endpoint`](https://github.com/kicksideai/chestor/blob/main/workspace/src/api/_index.yaml) | `GET` | `/workspace/entries/{id}/breadcrumbs` | `chestor.workspace:api_router` |
| [`chestor.workspace.api:create_entry.endpoint`](https://github.com/kicksideai/chestor/blob/main/workspace/src/api/_index.yaml) | `POST` | `/workspace/entries` | `chestor.workspace:api_router` |
| [`chestor.workspace.api:update_entry.endpoint`](https://github.com/kicksideai/chestor/blob/main/workspace/src/api/_index.yaml) | `PUT` | `/workspace/entries/{id}` | `chestor.workspace:api_router` |
| [`chestor.workspace.api:move_entry.endpoint`](https://github.com/kicksideai/chestor/blob/main/workspace/src/api/_index.yaml) | `POST` | `/workspace/entries/{id}/move` | `chestor.workspace:api_router` |
| [`chestor.workspace.api:delete_entry.endpoint`](https://github.com/kicksideai/chestor/blob/main/workspace/src/api/_index.yaml) | `DELETE` | `/workspace/entries/{id}` | `chestor.workspace:api_router` |
| [`chestor.workspace.api:grant_entry.endpoint`](https://github.com/kicksideai/chestor/blob/main/workspace/src/api/_index.yaml) | `POST` | `/workspace/entries/{id}/grant` | `chestor.workspace:api_router` |
| [`chestor.workspace.api:revoke_entry.endpoint`](https://github.com/kicksideai/chestor/blob/main/workspace/src/api/_index.yaml) | `POST` | `/workspace/entries/{id}/revoke` | `chestor.workspace:api_router` |

See [users and groups](../using/users.md) for configuration and
[module policy authoring](../building-modules/security-and-module-access.md)
for requirements, delegation, and resource authority.
