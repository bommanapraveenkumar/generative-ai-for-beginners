import { start } from 'odata-mcp-proxy';

// Documented programmatic bootstrap: same as running `odata-mcp-proxy`.
// Config: api-config.json in this directory. Credentials: .env or default-env.json.
await start();
