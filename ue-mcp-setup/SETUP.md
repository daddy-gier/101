# Unreal Engine 5.8 MCP Setup

## Step 1 — Enable the plugin in UE 5.8

1. Open Unreal Editor with your project.
2. Go to **Edit → Plugins**.
3. Search for **Unreal MCP** → enable it.
4. Also enable **AllToolsets** (same Plugins browser).
5. Restart the editor when prompted.

The MCP server now runs inside the editor at:
```
http://127.0.0.1:8000/mcp
```
(Port and path can be changed in **Edit → Editor Preferences → Model Context Protocol**.)

---

## Step 2 — Configure Claude Code

Claude Code reads `.mcp.json` from the project root **or** from the user-level config.

### Option A — project-level (per UE project)

Copy `claude-code-mcp.json` as `.mcp.json` into your UE project root:
```
C:\Users\Gierl\Documents\Unreal Projects\<YourProject>\.mcp.json
```

### Option B — user-level (works for all projects)

Add to `%APPDATA%\Claude\claude_desktop_config.json`:
```json
{
  "mcpServers": {
    "unreal-engine": {
      "type": "http",
      "url": "http://127.0.0.1:8000/mcp"
    }
  }
}
```
If the file already has other servers, just add the `"unreal-engine"` block inside the existing `mcpServers` object.

After editing, fully quit and relaunch Claude Code (no tray icon).

---

## Step 3 — Configure Hermes

Open `C:\Users\Gierl\.hermes\config.yaml` in any text editor and add or merge:
```yaml
mcp_servers:
  unreal-engine:
    url: http://127.0.0.1:8000/mcp
```

Save the file. Hermes detects config changes at runtime — you will see:
```
🔄 MCP server config changed — reloading connections...
```
followed by the `unreal-engine` server appearing in the tools list.

---

## Step 4 — Verify both are connected

**Claude Code** — run in a terminal while UE is open:
```
claude mcp list
```
You should see `unreal-engine` listed.

**Hermes** — at the Hermes prompt type:
```
/mcp
```
It should show `unreal-engine` connected with its tool count.

---

## Troubleshooting

| Symptom | Fix |
|---|---|
| "No MCP servers connected" in Hermes | Check UE is open and MCP plugin is enabled; confirm `config.yaml` was saved |
| Port conflict | Change port in UE Editor Preferences, then update the `8000` in both configs |
| Claude Code doesn't see tools | Fully quit Claude (system tray) and relaunch |
| Server shows 0 tools | Enable **AllToolsets** plugin in UE and restart the editor |
