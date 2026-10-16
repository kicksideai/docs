# Connect a provider

Connections authorize external accounts for agents and automations. Model credentials use **System → Models** instead.

1. Open **Connections** and choose **Connect app**.
2. Select an installed provider. If the provider is absent, install its package from **System → Modules**.
3. Complete the provider's form. OAuth opens an authorization flow; credential-based providers collect their declared fields. An OAuth provider may need administrator application configuration first.
4. Return to Connections and inspect the connection's status.
5. Select the connection in the agent capability or automation that uses it. Share the resource with other users when they need access.

{{ screenshot:kickside/connections.png }}

Installing a provider makes its tools and setup form available. It does not authorize an external account. See [connections](../using/connections.md) for sharing and renewal.
