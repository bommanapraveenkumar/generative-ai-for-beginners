# my-sap-mcp-server

Self-contained Node.js MCP server that exposes a SAP OData V2 API as MCP tools via `odata-mcp-proxy`. You describe the service in `api-config.json`; the proxy generates the tools.

Requires Node.js 18 or later.

## Setup

```bash
cd my-sap-mcp-server
npm install
cp .env.example .env
```

Edit `.env` and replace every placeholder with your own SAP OData host and OAuth2 client-credentials. This project does not ship real SAP credentials.

On SAP BTP Cloud Foundry, skip `.env` and bind Destination / Connectivity / XSUAA instead. The proxy reads `VCAP_SERVICES`. For local BTP-style testing you can also use a gitignored `default-env.json`.

## Run

HTTP (default in `.env.example`): health at `http://localhost:4004/health`, MCP at `http://localhost:4004/mcp`.

```bash
npm start
```

Reload on file changes (HTTP):

```bash
npm run dev
```

stdio (Claude Desktop / MCP clients that spawn a process):

```bash
MCP_TRANSPORT=stdio npm start
```

Equivalent CLI (same package, no custom tools):

```bash
npx odata-mcp-proxy
```

## Required environment variables

Used when `VCAP_SERVICES` is not set. Prefix comes from the `destination` field in `api-config.json` (`SAP_ODATA`).

| Variable | Purpose |
| --- | --- |
| `SAP_ODATA_BASE_URL` | SAP host, for example `https://your-sap-host.example.com` |
| `SAP_ODATA_TOKEN_URL` | OAuth2 token endpoint |
| `SAP_ODATA_CLIENT_ID` | OAuth2 client id |
| `SAP_ODATA_CLIENT_SECRET` | OAuth2 client secret |

Optional: `MCP_TRANSPORT` (`http` or `stdio`, default `http`), `PORT` (default `4004`), `LOG_LEVEL`, `REQUEST_TIMEOUT`, `API_CONFIG_FILE`.

## Configure the OData service

`api-config.json` is a starter SAP Gateway service (`API_BUSINESS_PARTNER` / `A_BusinessPartner`). Change `pathPrefix`, `entitySets`, and `destination` to match your catalog. For each destination, set `{PREFIX}_BASE_URL`, `{PREFIX}_TOKEN_URL`, `{PREFIX}_CLIENT_ID`, and `{PREFIX}_CLIENT_SECRET`.

The sample registers read-only tools `A_BusinessPartner_list` and `A_BusinessPartner_get`. Destinations are resolved on the first tool call, not at process start.

## Claude Desktop

Point the client at this folder with stdio transport:

```json
{
  "mcpServers": {
    "my-sap-mcp-server": {
      "command": "node",
      "args": ["server.mjs"],
      "cwd": "/absolute/path/to/my-sap-mcp-server",
      "env": {
        "MCP_TRANSPORT": "stdio"
      }
    }
  }
}
```

Keep SAP credentials in `.env` in `cwd`, or add them under `env`.

Package reference: [odata-mcp-proxy on npm](https://www.npmjs.com/package/odata-mcp-proxy).
