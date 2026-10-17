# MCP credentials

KickSide exposes selected tools to external clients through the Model Context Protocol. This differs from connecting KickSide to an external MCP server.

1. Open **MCP** and choose **New credential**.
2. Enter a name, choose capabilities, and select the permitted components or scopes.
3. Create the credential and copy its token from the creation dialog. The token appears once.
4. Configure the client with the endpoint displayed in MCP and the token as its bearer credential.
5. Test one permitted tool and verify its result.

Keep the token in the client's secret configuration. Delete a credential to revoke it; create another when a replacement is needed.

Each invocation resolves the credential owner's current groups and applies the credential's restrictions. Component permissions remain required. Selecting a capability does not grant every workspace resource.

Tools return structured objects. The MCP transport encodes successful objects as JSON in text content and includes structured error metadata for failures. List and search tools return compact rows plus their declared paging fields; request additional row fields with `fields` when the tool offers it, or use its get operation for the complete object. A failed tool call carries `isError`; inspect its structured error before acting on the result.

Use the `kickside/mcp-client` connection provider for the reverse direction. See [connections](connections.md).
