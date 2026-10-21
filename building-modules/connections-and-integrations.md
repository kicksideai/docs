# Connections and integrations

`kickside.connection` owns the connection registries and common lifecycle. Providers are independent packages whose resources are Components.

| Contract | Provider methods |
| --- | --- |
| `kickside.connection:connection` | `get_status`, `test_connection`, `discover_resources` |
| `kickside.connection:reply_provider` | `send_reply`, `update_reply`, `send_status` |

The platform implements `kickside.connection:connections` and `kickside.connection:reply_providers`; providers implement the resource behavior.

## Declare a provider

Declare a `contract.binding` with `meta.provider`, `meta.class: [connection]`, and a `meta.credential_schema`. Add `reply_provider` to the class when the provider replies. Each instance-bound contract entry declares `context_required: [component_id]`.

The credential schema drives the Connect form and its server-side allowlist, including required fields, types, options, and conditional requirements. Store credentials in private component context or the OAuth owner's encrypted storage. Use `kickside.connection:base_connection` for shared status and deletion behavior.

Stored connection states are `connected`, `needs_reauth`, and `disabled`; `expired` and `error` are read-time projections. Discover resources through the provider contract and return normalized identifiers and labels.

## Transport and execution

OAuth owns the authorization protocol; the provider declares its connector. Public callbacks verify their signature or token before admitting a delivery. The Channel or Automation owner resolves the stored execution identity before tools and outbound effects. The external sender and connection owner do not replace that identity.

Read credentials through the actor-validated component service. Route API handlers, tools, and Blocks through the same transport and domain helpers. Test credential validation, discovery, renewal, reply, deletion, and denied resource access.

## Reply delivery keys

From the upcoming release that includes [kickside#77](https://github.com/kicksideai/kickside/pull/77), `send_reply` accepts an optional, non-empty `idempotency_key` alongside `resource_id`, `content`, and the existing optional fields. Keep the same key for every attempt of one delivery. A provider with native send idempotency uses it to return the existing message on a retry. Omitting the key preserves the existing send behavior.

The shared reply sender derives a separate key for each content chunk as `<idempotency_key>#<chunk-index>`, starting at 1. Each retry of the same chunk retains that key.

Discord maps the key to a deterministic message `nonce` with `enforce_nonce: true` from the upcoming release that includes [providers#19](https://github.com/kicksideai/providers/pull/19). Discord deduplicates matching nonces from the same author within its deduplication window. The provider key does not by itself promise indefinite replay; writable destinations use the [write receipt contract](contracts-and-ports.md#writable-destinations) for recorded results.
