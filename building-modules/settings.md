# Settings declarations

The settings module discovers three registry surfaces:

| `meta.type` | Purpose |
| --- | --- |
| `kickside.settings:definition` | A typed field |
| `kickside.settings:block` | A Settings navigation block or custom editor |
| `ui.settings_tab` | A System tab |

Definition fields belong at the entry's top level, not under `meta`: namespace, key, value type, default, description, title, category, order, scope, editability, visibility, and optional validation/UI fields.

```yaml
- name: setting.token_expiration
  kind: registry.entry
  meta: { type: 'kickside.settings:definition' }
  namespace: kickside.users
  key: token_expiration
  value_type: duration
  default: 24h
  title: Session lifetime
  scope: global
```

This declaration is the Users setting shape; another module uses its own namespace and key.

## Values and validation

Value types are `string`, `int`, `bool`, `duration`, `json`, and `secret`. Unsupported types or misplaced required fields make a definition unavailable. Duration is a parseable string; boolean is a real boolean; JSON is a table.

`visible: false` hides a field from the form but does not prevent reads or writes. `editable: false` blocks writes. `read_access: admin` restricts direct reads. `schema` guides client controls; server invariants use coercion and `validate_func`.

The database stores administrator overrides only. `unset` removes one and restores the registry default. Global is the implemented scope; module-specific inheritance is separate.

## Contracts and UI

`kickside.settings:settings` exposes `get`, `get_namespace`, `set`, `unset`, and `list`. Writes require access to `kickside.settings.api:put_settings.endpoint`; listing requires `kickside.settings.api:list_settings.endpoint`. Direct contract calls repeat these boundaries.

Blocks claim a namespace or namespace list. Unclaimed visible namespaces get generated blocks. A custom block's component tag must resolve to a view declaration; its bundle can be served by a different owning module.

Secrets are encrypted with `ENCRYPTION_KEY`. `get` returns plaintext to an authorized caller; `list` returns secret-presence metadata rather than the value. The UI's empty secret draft keeps the stored value. Keep credentials out of public defaults.
