# Security and endpoint access

The tables record endpoint and policy declarations exported from a fresh KickSide 0.2.11 installation with Security 0.2.5. This installation includes optional packages used for the documentation examples, including Research and web-search modules. Router paths are relative to their configured mount; the authenticated API uses `/api/v1`.

## Groups

| Group | Role |
| --- | --- |
| `app.security:admin` | Root administration |
| `app.security:user` | Signed-in baseline: shell, sessions, own profile, agent selection, Jobs, and Core capabilities |
| `app.security:members` | Application default membership, including Core and platform Members |
| `kickside.security.groups:members` | Platform group composed from installed public module-access policies |
| `kickside.security.scopes:set_` plus the group-set hash | Projected scope for a distinct assigned group set |

Assigned policies union; denies take precedence. Members excludes **Users management**, while directory and sharing discovery remain available. Narrow a user by removing Members and assigning explicit composed groups. Access reductions revoke sessions; allow-only expansions take effect at the next login or token issue.

The authenticated router uses `token_auth` and `endpoint_firewall`. It checks `access` on an endpoint ID. A policy granting endpoint access still requires any handler-owned Component ACL. Public routes validate the admission required by their protocol.

## Endpoint policy declarations

These are direct policy resources whose actions include `access` or `*`. A resource pattern is shown as declared; it is not an inferred endpoint naming rule. Policy includes and conditions remain relevant to effective authorization.

| Policy | Effect | Endpoint resources or pattern | Groups | Conditions |
| --- | --- | --- | --- | --- |
| `app.security:admin.all_access` | allow | `*` | `app.security:admin` | [{"field": "action", "operator": "nin", "value": ["threads.output.publish"]}] |
| `app.security:ingress.endpoint_access` | allow | `*` | `app.security:ingress` | None |
| `app.security:user.app_shell_access` | allow | `app.api.websocket:ws_endpoint.endpoint`<br>`userspace.dataflow.api:*`<br>`wippy.session.api:*` | Composed by host | None |
| `app.security:user.endpoint_access` | allow | `app.api.websocket:ws_endpoint.endpoint`<br>`kickside.users.api:get_profile.endpoint`<br>`kickside.users.api:logout.endpoint`<br>`kickside.users.api:me.endpoint`<br>`kickside.users.api:put_profile.endpoint`<br>`kickside.users.api:update_me.endpoint`<br>`userspace.dataflow.api:*`<br>`wippy.session.api:*`<br>`wippy.views.api:find_by_tag.endpoint`<br>`wippy.views.api:list_components.endpoint`<br>`wippy.views.api:list_pages.endpoint`<br>`wippy.views.api:list_routes.endpoint`<br>`wippy.views.api:public_url.endpoint`<br>`wippy.views.api:render.endpoint` | `app.security:user` | None |
| `app.security:user.self_service` | allow | `kickside.users.api:me.endpoint`<br>`kickside.users.api:update_me.endpoint`<br>`kickside.users.api:logout.endpoint`<br>`kickside.users.api:get_profile.endpoint`<br>`kickside.users.api:put_profile.endpoint` | Composed by host | None |
| `app.security:user.view_registry_access` | allow | `wippy.views.api:list_pages.endpoint`<br>`wippy.views.api:list_components.endpoint`<br>`wippy.views.api:find_by_tag.endpoint`<br>`wippy.views.api:render.endpoint`<br>`wippy.views.api:public_url.endpoint`<br>`wippy.views.api:list_routes.endpoint` | Composed by host | None |
| `kickside.agents.security:agents_endpoint_access` | allow | `kickside.agents.api:agents_by_name.endpoint`<br>`kickside.agents.api:create_user_agent.endpoint`<br>`kickside.agents.api:delete_user_agent.endpoint`<br>`kickside.agents.api:get_user_agent.endpoint`<br>`kickside.agents.api:list_agents.endpoint`<br>`kickside.agents.api:list_memory_options.endpoint`<br>`kickside.agents.api:list_namespaces.endpoint`<br>`kickside.agents.api:list_tools.endpoint`<br>`kickside.agents.api:list_traits.endpoint`<br>`kickside.agents.api:list_user_agents.endpoint`<br>`kickside.agents.api:update_user_agent.endpoint` | `kickside.security.groups:members` | None |
| `kickside.automation.engine:composition_watcher_trust` | allow | `*` | `kickside.automation.engine:composition_watcher` | None |
| `kickside.automation.security:automation_endpoint_access` | allow | `kickside.automation.api:call_action.endpoint`<br>`kickside.automation.api:delete.endpoint`<br>`kickside.automation.api:drive_control.endpoint`<br>`kickside.automation.api:export.endpoint`<br>`kickside.automation.api:get_execution_identity.endpoint`<br>`kickside.automation.api:health.endpoint`<br>`kickside.automation.api:history.endpoint`<br>`kickside.automation.api:import.endpoint`<br>`kickside.automation.api:install.endpoint`<br>`kickside.automation.api:install_selected.endpoint`<br>`kickside.automation.api:list.endpoint`<br>`kickside.automation.api:list_sinks.endpoint`<br>`kickside.automation.api:list_sources.endpoint`<br>`kickside.automation.api:list_types.endpoint`<br>`kickside.automation.api:read_config.endpoint`<br>`kickside.automation.api:read_state.endpoint`<br>`kickside.automation.api:reconfigure.endpoint`<br>`kickside.automation.api:set_execution_identity.endpoint`<br>`kickside.automation.api:status.endpoint`<br>`kickside.automation.api:update_meta.endpoint` | `kickside.security.groups:members` | None |
| `kickside.automation.security:manual_task_install` | allow | `kickside.automation.manual:task` | `kickside.security.groups:members` | None |
| `kickside.component.security:component_endpoint_access` | allow | `kickside.component.api:access_model.endpoint`<br>`kickside.component.api:list_component_access.endpoint`<br>`kickside.component.api:share_component.endpoint` | `kickside.security.groups:members` | None |
| `kickside.connection.security:connection_endpoint_access` | allow | `kickside.connection.api:create_connection.endpoint`<br>`kickside.connection.api:delete_connection.endpoint`<br>`kickside.connection.api:discover_providers.endpoint`<br>`kickside.connection.api:discover_resources.endpoint`<br>`kickside.connection.api:list_connections.endpoint`<br>`kickside.connection.api:provider_badges.endpoint`<br>`kickside.connection.api:update_connection.endpoint` | `kickside.security.groups:members` | None |
| `kickside.contract.http:user_endpoint_access` | allow | `kickside.core.retention.api:get_thread_retention.endpoint`<br>`kickside.core.retention.api:upsert_thread_retention.endpoint`<br>`kickside.core.threads.api:create_thread.endpoint`<br>`kickside.core.threads.api:delete_thread.endpoint`<br>`kickside.core.threads.api:get_graph.endpoint`<br>`kickside.core.threads.api:get_thread.endpoint`<br>`kickside.core.threads.api:ingest_events_batch.endpoint`<br>`kickside.core.threads.api:list_children.endpoint`<br>`kickside.core.threads.api:list_classes.endpoint`<br>`kickside.core.threads.api:list_events.endpoint`<br>`kickside.core.threads.api:list_job_runs.endpoint`<br>`kickside.core.threads.api:list_jobs.endpoint`<br>`kickside.core.threads.api:list_threads.endpoint`<br>`kickside.core.threads.api:post_event.endpoint`<br>`kickside.core.threads.api:post_message.endpoint`<br>`kickside.core.threads.api:update_thread.endpoint` | `kickside.security.groups:members`<br>`app.security:unassigned_endpoints` | None |
| `kickside.core.security:core_endpoint_access` | allow | `kickside.core.retention.api:get_thread_retention.endpoint`<br>`kickside.core.retention.api:upsert_thread_retention.endpoint`<br>`kickside.core.threads.api:create_thread.endpoint`<br>`kickside.core.threads.api:delete_thread.endpoint`<br>`kickside.core.threads.api:get_graph.endpoint`<br>`kickside.core.threads.api:get_thread.endpoint`<br>`kickside.core.threads.api:ingest_events_batch.endpoint`<br>`kickside.core.threads.api:list_children.endpoint`<br>`kickside.core.threads.api:list_classes.endpoint`<br>`kickside.core.threads.api:list_events.endpoint`<br>`kickside.core.threads.api:list_job_runs.endpoint`<br>`kickside.core.threads.api:list_jobs.endpoint`<br>`kickside.core.threads.api:list_threads.endpoint`<br>`kickside.core.threads.api:post_event.endpoint`<br>`kickside.core.threads.api:post_message.endpoint`<br>`kickside.core.threads.api:update_thread.endpoint` | `kickside.security.groups:members` | None |
| `kickside.dashboard.security:dashboard_endpoint_access` | allow | `kickside.dashboard:dashboard_view`<br>`kickside.dashboard:ui_static` | `kickside.security.groups:members` | None |
| `kickside.dashboard.security:module_access` | allow | `kickside.dashboard:overview.endpoint` | `kickside.security.groups:members` | None |
| `kickside.hub.instruments:instruments_endpoint_access` | allow | `kickside.hub.instruments:recommendations.endpoint`<br>`kickside.hub.instruments:requirement_resolution.endpoint` | `app.security:admin` | None |
| `kickside.hub.instruments:required_setup_endpoint_access` | allow | `kickside.hub.api:required_setup_status.endpoint`<br>`kickside.hub.api:required_setup_apply.endpoint` | `app.security:admin` | None |
| `kickside.identity.security:identity_endpoint_access` | allow | `kickside.identity.api:generate_link_code.endpoint`<br>`kickside.identity.api:list_links.endpoint`<br>`kickside.identity.api:unlink.endpoint` | `kickside.security.groups:members` | None |
| `kickside.inbox.security:inbox_endpoint_access` | allow | `kickside.inbox.api:create_item.endpoint`<br>`kickside.inbox.api:delete_item.endpoint`<br>`kickside.inbox.api:list_inbox.endpoint`<br>`kickside.inbox.api:list_item_types.endpoint`<br>`kickside.inbox.api:resolve_item.endpoint` | `kickside.security.groups:members` | None |
| `kickside.mcp_client.security:module_access` | allow | `kickside.mcp_client.api:reconnect.endpoint` | Composed by host | None |
| `kickside.models.security:models_endpoint_access` | allow | `kickside.models.api:list_model_classes.endpoint`<br>`kickside.models.api:list_models.endpoint`<br>`kickside.models.api:models_by_name.endpoint` | `kickside.security.groups:members` | None |
| `kickside.oauth.security:oauth_endpoint_access` | allow | `kickside.oauth.api:discover_providers.endpoint`<br>`kickside.oauth.api:get_connection_details.endpoint`<br>`kickside.oauth.api:get_provider_info.endpoint`<br>`kickside.oauth.api:init_connection.endpoint`<br>`kickside.oauth.api:update_connection.endpoint` | `kickside.security.groups:members` | None |
| `kickside.renderers.security:module_access` | allow | `kickside.renderers.api:list_renderers.endpoint` | `kickside.security.groups:members` | None |
| `kickside.renderers:renderers_endpoint_access` | allow | `kickside.renderers:render_audio`<br>`kickside.renderers:render_code`<br>`kickside.renderers:render_docx`<br>`kickside.renderers:render_html`<br>`kickside.renderers:render_image`<br>`kickside.renderers:render_markdown`<br>`kickside.renderers:render_pdf`<br>`kickside.renderers:render_pptx`<br>`kickside.renderers:render_video`<br>`kickside.renderers:render_xlsx`<br>`kickside.renderers:resource_view`<br>`kickside.renderers:ui_static` | `kickside.security.groups:members` | None |
| `kickside.security.service:scope_projection_trust` | allow | `*` | `kickside.security.service:scope_projection_writer` | None |
| `kickside.sessions.security:module_access` | allow | `kickside.sessions.api:favorite.endpoint`<br>`kickside.sessions.api:start_token.endpoint` | Composed by host | None |
| `kickside.sso.env:seed.settings_write` | allow | `kickside.settings:settings`<br>`kickside.settings:*`<br>`kickside.settings.api:put_settings.endpoint`<br>`set` | Composed by host | None |
| `kickside.sso.security:module_access` | allow | `kickside.sso.api:link_start.endpoint`<br>`kickside.sso.api:list_connections.endpoint`<br>`kickside.sso.api:unlink.endpoint` | Composed by host | None |
| `kickside.transform.security:transform_endpoint_access` | allow | `kickside.transform.api:assist.endpoint`<br>`kickside.transform.api:snippet.endpoint`<br>`kickside.transform.api:validate.endpoint` | `kickside.security.groups:members` | None |
| `kickside.ui.security:system_onboarding_access` | allow | `kickside.ui:system_onboarding`<br>`kickside.ui.api:reset_splashes.endpoint` | `app.security:admin` | None |
| `kickside.ui.security:ui_endpoint_access` | allow | `kickside.ui.api:list_account_items.endpoint`<br>`kickside.ui.api:list_contributions.endpoint`<br>`kickside.ui.api:list_nav.endpoint`<br>`kickside.ui.api:mark_splash_seen.endpoint`<br>`kickside.ui.api:mark_splash_unseen.endpoint` | `kickside.security.groups:members` | None |
| `kickside.uploads.security:module_access` | allow | `kickside.uploads.api:artifact_raw_handler.endpoint`<br>`kickside.uploads.api:artifacts_handler.endpoint`<br>`kickside.uploads.api:complete_handler.endpoint`<br>`kickside.uploads.api:delete_handler.endpoint`<br>`kickside.uploads.api:get_handler.endpoint`<br>`kickside.uploads.api:list_handler.endpoint`<br>`kickside.uploads.api:presigned_handler.endpoint`<br>`kickside.uploads.api:raw_handler.endpoint`<br>`kickside.uploads.api:upload_handler.endpoint` | `kickside.security.groups:members` | None |
| `kickside.uploads.security:uploads_endpoint_access` | allow | `kickside.uploads:settings_storage_view`<br>`kickside.uploads:ui_static`<br>`kickside.uploads:uploads_view` | `kickside.security.groups:members` | None |
| `kickside.users.directory:directory_endpoint_access` | allow | `kickside.users.api:principals_search.endpoint`<br>`kickside.users.api:principals_resolve.endpoint` | `kickside.security.groups:members`<br>`app.security:members` | None |
| `kickside.users.profile:profile_endpoint_access` | allow | `kickside.users.api:get_profile.endpoint`<br>`kickside.users.api:put_profile.endpoint` | `kickside.security.groups:members`<br>`app.security:members` | None |
| `kickside.users.security:module_access` | allow | `kickside.users.api:list_users.endpoint`<br>`kickside.users.api:create_user.endpoint`<br>`kickside.users.api:bot_accounts_create.endpoint`<br>`kickside.users.api:bot_accounts_list.endpoint`<br>`kickside.users.api:update_user.endpoint`<br>`kickside.users.api:delete_user.endpoint`<br>`kickside.users.api:get_user_groups.endpoint`<br>`kickside.users.api:set_user_groups.endpoint`<br>`kickside.users.api:list_assignable_scopes.endpoint`<br>`kickside.ui.api:list_settings_tabs.endpoint` | Composed by host | None |
| `kickside.users.security:run_as_candidate_endpoint_access` | allow | `kickside.users.api:run_as_candidates.endpoint` | `kickside.security.groups:members`<br>`app.security:members` | None |
| `kickside.users.security:users_endpoint_access` | allow | `kickside.users.api:me.endpoint`<br>`kickside.users.api:update_me.endpoint`<br>`kickside.users.api:logout.endpoint` | `kickside.security.groups:members`<br>`app.security:members` | None |
| `kickside.widgets.security:module_access` | allow | `kickside.widgets.api:create_view_resolver.endpoint` | Composed by host | None |

## Endpoint inventory

| Registry ID | Method | Relative path | Router |
| --- | --- | --- | --- |
| `kickside.agents.api:agents_by_name.endpoint` | `GET` | `/agents/by-name` | `app:api` |
| `kickside.agents.api:create_user_agent.endpoint` | `POST` | `/user-agents` | `app:api` |
| `kickside.agents.api:delete_user_agent.endpoint` | `DELETE` | `/user-agents/{id}` | `app:api` |
| `kickside.agents.api:get_user_agent.endpoint` | `GET` | `/user-agents/{id}` | `app:api` |
| `kickside.agents.api:list_agents.endpoint` | `GET` | `/agents/list` | `app:api` |
| `kickside.agents.api:list_memory_options.endpoint` | `GET` | `/agents/memory-options` | `app:api` |
| `kickside.agents.api:list_namespaces.endpoint` | `GET` | `/agents/namespaces` | `app:api` |
| `kickside.agents.api:list_tools.endpoint` | `GET` | `/agents/tools` | `app:api` |
| `kickside.agents.api:list_traits.endpoint` | `GET` | `/agents/traits` | `app:api` |
| `kickside.agents.api:list_user_agents.endpoint` | `GET` | `/user-agents` | `app:api` |
| `kickside.agents.api:update_user_agent.endpoint` | `PUT` | `/user-agents/{id}` | `app:api` |
| `kickside.automation.api:call_action.endpoint` | `POST` | `/automations/{id}/actions/{method}` | `app:api` |
| `kickside.automation.api:delete.endpoint` | `DELETE` | `/automations/{id}` | `app:api` |
| `kickside.automation.api:drive_control.endpoint` | `POST` | `/automations/{id}/control` | `app:api` |
| `kickside.automation.api:export.endpoint` | `GET` | `/automations/{id}/export` | `app:api` |
| `kickside.automation.api:get_execution_identity.endpoint` | `GET` | `/automations/{id}/identity` | `app:api` |
| `kickside.automation.api:health.endpoint` | `GET` | `/automations/health` | `app:api` |
| `kickside.automation.api:history.endpoint` | `GET` | `/automations/{id}/history` | `app:api` |
| `kickside.automation.api:import.endpoint` | `POST` | `/automations/import` | `app:api` |
| `kickside.automation.api:install.endpoint` | `POST` | `/automations` | `app:api` |
| `kickside.automation.api:install_selected.endpoint` | `POST` | `/automations/selected` | `app:api` |
| `kickside.automation.api:list.endpoint` | `GET` | `/automations` | `app:api` |
| `kickside.automation.api:list_sinks.endpoint` | `GET` | `/automations/sinks` | `app:api` |
| `kickside.automation.api:list_sources.endpoint` | `GET` | `/automations/sources` | `app:api` |
| `kickside.automation.api:list_types.endpoint` | `GET` | `/automations/types` | `app:api` |
| `kickside.automation.api:read_config.endpoint` | `GET` | `/automations/{id}/config` | `app:api` |
| `kickside.automation.api:read_state.endpoint` | `GET` | `/automations/{id}/state` | `app:api` |
| `kickside.automation.api:reconfigure.endpoint` | `PUT` | `/automations/{id}` | `app:api` |
| `kickside.automation.api:set_execution_identity.endpoint` | `POST` | `/automations/{id}/identity` | `app:api` |
| `kickside.automation.api:status.endpoint` | `GET` | `/automations/{id}/status` | `app:api` |
| `kickside.automation.api:update_meta.endpoint` | `PATCH` | `/automations/{id}` | `app:api` |
| `kickside.component.api:access_model.endpoint` | `GET` | `/components/access-model` | `app:api` |
| `kickside.component.api:adopt_component.endpoint` | `POST` | `/component-access/adopt/{id}` | `app:api` |
| `kickside.component.api:list_component_access.endpoint` | `GET` | `/component-access/grants/{id}` | `app:api` |
| `kickside.component.api:share_component.endpoint` | `POST` | `/component-access/share/{id}` | `app:api` |
| `kickside.connection.api:create_connection.endpoint` | `POST` | `/connections` | `app:api` |
| `kickside.connection.api:delete_connection.endpoint` | `DELETE` | `/connections/{id}` | `app:api` |
| `kickside.connection.api:discover_providers.endpoint` | `GET` | `/connections/providers/discover` | `app:api` |
| `kickside.connection.api:discover_resources.endpoint` | `POST` | `/connections/{id}/discover_resources` | `app:api` |
| `kickside.connection.api:list_connections.endpoint` | `GET` | `/connections` | `app:api` |
| `kickside.connection.api:provider_badges.endpoint` | `GET` | `/connections/providers/badges` | `app:api` |
| `kickside.connection.api:update_connection.endpoint` | `PUT` | `/connections/{id}` | `app:api` |
| `kickside.core.projections.api:list_projection_cursors.endpoint` | `GET` | `/threads/{id}/projections` | `app:api` |
| `kickside.core.projections.api:pause_projection.endpoint` | `PUT` | `/threads/{id}/projections/pause` | `app:api` |
| `kickside.core.projections.api:register_projection.endpoint` | `POST` | `/threads/{id}/projections` | `app:api` |
| `kickside.core.projections.api:remove_projection.endpoint` | `POST` | `/threads/{id}/projections/remove` | `app:api` |
| `kickside.core.projections.api:resume_projection.endpoint` | `PUT` | `/threads/{id}/projections/resume` | `app:api` |
| `kickside.core.retention.api:get_thread_retention.endpoint` | `GET` | `/threads/{id}/retention` | `app:api` |
| `kickside.core.retention.api:upsert_thread_retention.endpoint` | `PUT` | `/threads/{id}/retention` | `app:api` |
| `kickside.core.threads.api:create_thread.endpoint` | `POST` | `/threads` | `app:api` |
| `kickside.core.threads.api:delete_thread.endpoint` | `DELETE` | `/threads/{id}` | `app:api` |
| `kickside.core.threads.api:get_graph.endpoint` | `GET` | `/threads/{id}/graph` | `app:api` |
| `kickside.core.threads.api:get_thread.endpoint` | `GET` | `/threads/{id}` | `app:api` |
| `kickside.core.threads.api:ingest_events_batch.endpoint` | `POST` | `/threads/{id}/events/batch` | `app:api` |
| `kickside.core.threads.api:list_children.endpoint` | `GET` | `/threads/{id}/children` | `app:api` |
| `kickside.core.threads.api:list_classes.endpoint` | `GET` | `/thread-classes` | `app:api` |
| `kickside.core.threads.api:list_events.endpoint` | `GET` | `/threads/{id}/events` | `app:api` |
| `kickside.core.threads.api:list_job_runs.endpoint` | `GET` | `/job-runs` | `app:api` |
| `kickside.core.threads.api:list_jobs.endpoint` | `GET` | `/jobs` | `app:api` |
| `kickside.core.threads.api:list_threads.endpoint` | `GET` | `/threads` | `app:api` |
| `kickside.core.threads.api:post_event.endpoint` | `POST` | `/threads/{id}/events` | `app:api` |
| `kickside.core.threads.api:post_message.endpoint` | `POST` | `/threads/{id}/messages` | `app:api` |
| `kickside.core.threads.api:update_thread.endpoint` | `PATCH` | `/threads/{id}` | `app:api` |
| `kickside.dashboard:overview.endpoint` | `GET` | `/dashboard/overview` | `app:api` |
| `kickside.hub.api:hub_auth_clear.endpoint` | `DELETE` | `/hub/auth` | `app:api` |
| `kickside.hub.api:hub_auth_set.endpoint` | `POST` | `/hub/auth` | `app:api` |
| `kickside.hub.api:hub_auth_status.endpoint` | `GET` | `/hub/auth` | `app:api` |
| `kickside.hub.api:required_setup_apply.endpoint` | `POST` | `/hub/required-setup` | `app:api` |
| `kickside.hub.api:required_setup_status.endpoint` | `GET` | `/hub/required-setup` | `app:api` |
| `kickside.hub.instruments:recommendations.endpoint` | `POST` | `/onboarding/module-recommendations` | `app:api` |
| `kickside.hub.instruments:requirement_resolution.endpoint` | `POST` | `/onboarding/requirement-resolution` | `app:api` |
| `kickside.identity.api:generate_link_code.endpoint` | `POST` | `/identity/link-codes` | `app:api` |
| `kickside.identity.api:list_links.endpoint` | `GET` | `/identity/links` | `app:api` |
| `kickside.identity.api:unlink.endpoint` | `POST` | `/identity/unlink` | `app:api` |
| `kickside.inbox.api:create_item.endpoint` | `POST` | `/inbox` | `app:api` |
| `kickside.inbox.api:delete_item.endpoint` | `DELETE` | `/inbox/{id}` | `app:api` |
| `kickside.inbox.api:list_inbox.endpoint` | `GET` | `/inbox` | `app:api` |
| `kickside.inbox.api:list_item_types.endpoint` | `GET` | `/inbox/item-types` | `app:api` |
| `kickside.inbox.api:resolve_item.endpoint` | `POST` | `/inbox/{id}/{action}` | `app:api` |
| `kickside.mcp_client.api:reconnect.endpoint` | `PUT` | `/mcp-client/connections/{id}` | `app:api` |
| `kickside.models.api.admin:admin.endpoint` | `GET` | `/models/admin` | `app:api` |
| `kickside.models.api.admin:create_profile.endpoint` | `POST` | `/models/provider-profiles` | `app:api` |
| `kickside.models.api.admin:delete_card.endpoint` | `DELETE` | `/models/cards` | `app:api` |
| `kickside.models.api.admin:delete_profile.endpoint` | `DELETE` | `/models/provider-profiles/{id}` | `app:api` |
| `kickside.models.api.admin:discover_profile.endpoint` | `POST` | `/models/provider-profiles/{id}/discover` | `app:api` |
| `kickside.models.api.admin:test_card.endpoint` | `POST` | `/models/cards/test` | `app:api` |
| `kickside.models.api.admin:test_profile.endpoint` | `POST` | `/models/provider-profiles/{id}/test` | `app:api` |
| `kickside.models.api.admin:update_profile.endpoint` | `PUT` | `/models/provider-profiles/{id}` | `app:api` |
| `kickside.models.api.admin:upsert_card.endpoint` | `PUT` | `/models/cards` | `app:api` |
| `kickside.models.api:list_model_classes.endpoint` | `GET` | `/models/classes` | `app:api` |
| `kickside.models.api:list_models.endpoint` | `GET` | `/models/list` | `app:api` |
| `kickside.models.api:models_by_name.endpoint` | `GET` | `/models/by-name` | `app:api` |
| `kickside.oauth.api.public:oauth_callback.endpoint` | `POST` | `/oauth/callback` | `app:api.public` |
| `kickside.oauth.api.public:oauth_callback_page.endpoint` | `GET` | `/oauth/callback` | `app:api.public` |
| `kickside.oauth.api:discover_providers.endpoint` | `GET` | `/oauth/providers/discover` | `app:api` |
| `kickside.oauth.api:get_connection_details.endpoint` | `GET` | `/oauth/connections/{component_id}` | `app:api` |
| `kickside.oauth.api:get_provider_info.endpoint` | `GET` | `/oauth/providers/{provider_name}` | `app:api` |
| `kickside.oauth.api:init_connection.endpoint` | `POST` | `/oauth/providers/{provider_name}/init` | `app:api` |
| `kickside.oauth.api:update_connection.endpoint` | `PUT` | `/oauth/connections/{component_id}` | `app:api` |
| `kickside.renderers.api:list_renderers.endpoint` | `GET` | `/renderers` | `app:api` |
| `kickside.security.api:delegation_list.endpoint` | `GET` | `/security/delegations` | `app:api` |
| `kickside.security.api:delegation_recover.endpoint` | `POST` | `/security/delegations/recover` | `app:api` |
| `kickside.security.api:delegation_revoke.endpoint` | `DELETE` | `/security/delegations` | `app:api` |
| `kickside.security.api:delegation_save.endpoint` | `POST` | `/security/delegations` | `app:api` |
| `kickside.security.api:delete_scope.endpoint` | `DELETE` | `/security/scopes` | `app:api` |
| `kickside.security.api:list_policies.endpoint` | `GET` | `/security/policies` | `app:api` |
| `kickside.security.api:list_scopes.endpoint` | `GET` | `/security/scopes` | `app:api` |
| `kickside.security.api:save_scope.endpoint` | `POST` | `/security/scopes` | `app:api` |
| `kickside.sessions.api:favorite.endpoint` | `POST` | `/sessions/favorite` | `app:api` |
| `kickside.sessions.api:start_token.endpoint` | `POST` | `/sessions/start-token` | `app:api` |
| `kickside.settings.api:list_blocks.endpoint` | `GET` | `/settings/blocks` | `app:api` |
| `kickside.settings.api:list_settings.endpoint` | `GET` | `/settings` | `app:api` |
| `kickside.settings.api:put_settings.endpoint` | `PUT` | `/settings` | `app:api` |
| `kickside.sso.api:callback.endpoint` | `GET` | `/sso/{provider}/callback` | `app:api.public` |
| `kickside.sso.api:link_start.endpoint` | `POST` | `/sso/{provider}/link` | `app:api` |
| `kickside.sso.api:list_admin_providers.endpoint` | `GET` | `/sso/providers` | `app:api` |
| `kickside.sso.api:list_connections.endpoint` | `GET` | `/sso/connections` | `app:api` |
| `kickside.sso.api:list_providers.endpoint` | `GET` | `/sso/providers` | `app:api.public` |
| `kickside.sso.api:start.endpoint` | `GET` | `/sso/{provider}/start` | `app:api.public` |
| `kickside.sso.api:unlink.endpoint` | `DELETE` | `/sso/{provider}/link` | `app:api` |
| `kickside.transform.api:assist.endpoint` | `POST` | `/transform/assist` | `app:api` |
| `kickside.transform.api:snippet.endpoint` | `POST` | `/transform/snippet` | `app:api` |
| `kickside.transform.api:validate.endpoint` | `POST` | `/transform/validate` | `app:api` |
| `kickside.ui.api:get_branding.endpoint` | `GET` | `/branding` | `app:api.public` |
| `kickside.ui.api:get_logo.endpoint` | `GET` | `/branding/logo` | `app:api.public` |
| `kickside.ui.api:list_account_items.endpoint` | `GET` | `/account/items` | `app:api` |
| `kickside.ui.api:list_contributions.endpoint` | `GET` | `/ui/contributions` | `app:api` |
| `kickside.ui.api:list_nav.endpoint` | `GET` | `/nav/list` | `app:api` |
| `kickside.ui.api:list_settings_tabs.endpoint` | `GET` | `/settings/tabs` | `app:api` |
| `kickside.ui.api:mark_splash_seen.endpoint` | `POST` | `/ui/splash/{id}/seen` | `app:api` |
| `kickside.ui.api:mark_splash_unseen.endpoint` | `DELETE` | `/ui/splash/{id}/seen` | `app:api` |
| `kickside.ui.api:reset_splashes.endpoint` | `DELETE` | `/ui/splash/seen` | `app:api` |
| `kickside.ui.api:set_config.endpoint` | `PUT` | `/nav/config` | `app:api` |
| `kickside.ui.api:upload_logo.endpoint` | `POST` | `/nav/logo` | `app:api` |
| `kickside.uploads.api:artifact_raw_handler.endpoint` | `GET` | `/uploads/{uuid}/artifacts/{artifact_id}/raw` | `app:api` |
| `kickside.uploads.api:artifacts_handler.endpoint` | `GET` | `/uploads/{uuid}/artifacts` | `app:api` |
| `kickside.uploads.api:complete_handler.endpoint` | `POST` | `/uploads/complete` | `app:api` |
| `kickside.uploads.api:delete_handler.endpoint` | `DELETE` | `/uploads/{uuid}` | `app:api` |
| `kickside.uploads.api:get_handler.endpoint` | `GET` | `/uploads/{uuid}` | `app:api` |
| `kickside.uploads.api:list_handler.endpoint` | `GET` | `/uploads/list` | `app:api` |
| `kickside.uploads.api:presigned_handler.endpoint` | `POST` | `/uploads/presigned` | `app:api` |
| `kickside.uploads.api:raw_handler.endpoint` | `GET` | `/uploads/{uuid}/raw` | `app:api` |
| `kickside.uploads.api:upload_handler.endpoint` | `POST` | `/uploads` | `app:api` |
| `kickside.users.api:bot_accounts_create.endpoint` | `POST` | `/users/bots` | `app:api` |
| `kickside.users.api:bot_accounts_list.endpoint` | `GET` | `/users/bots` | `app:api` |
| `kickside.users.api:create_user.endpoint` | `POST` | `/users` | `app:api` |
| `kickside.users.api:delete_user.endpoint` | `DELETE` | `/users/{id}` | `app:api` |
| `kickside.users.api:get_profile.endpoint` | `GET` | `/profile` | `app:api` |
| `kickside.users.api:get_user_groups.endpoint` | `GET` | `/users/{id}/groups` | `app:api` |
| `kickside.users.api:list_assignable_scopes.endpoint` | `GET` | `/users/assignable-scopes` | `app:api` |
| `kickside.users.api:list_users.endpoint` | `GET` | `/users` | `app:api` |
| `kickside.users.api:login.endpoint` | `POST` | `/user/token` | `app:api.public` |
| `kickside.users.api:logout.endpoint` | `POST` | `/user/logout` | `app:api` |
| `kickside.users.api:me.endpoint` | `GET` | `/user/me` | `app:api` |
| `kickside.users.api:principals_resolve.endpoint` | `POST` | `/principals/resolve` | `app:api` |
| `kickside.users.api:principals_search.endpoint` | `GET` | `/principals/search` | `app:api` |
| `kickside.users.api:put_profile.endpoint` | `PUT` | `/profile` | `app:api` |
| `kickside.users.api:run_as_candidates.endpoint` | `GET` | `/users/run-as-candidates` | `app:api` |
| `kickside.users.api:set_user_groups.endpoint` | `PUT` | `/users/{id}/groups` | `app:api` |
| `kickside.users.api:update_me.endpoint` | `PUT` | `/user/me` | `app:api` |
| `kickside.users.api:update_user.endpoint` | `PUT` | `/users/{id}` | `app:api` |
| `kickside.widgets.api:create_view_resolver.endpoint` | `GET` | `/component-kinds/create-view` | `app:api` |

See [users and groups](../using/users.md) for configuration and [module policy authoring](../building-modules/security-and-module-access.md) for requirements and runtime grants.
