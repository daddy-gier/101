# CLAWED — Cipher Local Agent for Windows / Unreal Dev

Fully free, local AI agent setup using Ollama + Hermes.
No cloud APIs. No costs. Runs on your already-downloaded models.

---

## Your Models (already downloaded)

| Model | Size | Use |
|---|---|---|
| `gpt-oss:20b` | 13 GB | Best quality — use this |
| `qwen2.5-coder:7b` | 4.7 GB | Fallback if gpt-oss missing |
| `qwen2.5:7b` | 4.7 GB | General fallback |

---

## Scripts — run order

### Step 1 — Set up Ollama + Cipher model + patch Hermes
```
.\scripts\01_setup_ollama_cipher.ps1
```
- Starts Ollama if needed
- Creates `gpt-oss:20b-64k` wrapper (64K context, Cipher identity)
- Patches Hermes config to point at local Ollama
- Sends a Telegram test

### Step 2 — Install heartbeat (hourly Telegram reports)
```
.\scripts\02_install_heartbeat.ps1
```
- Creates Windows Scheduled Task: `CipherHeartbeat`
- Runs every 5 minutes
- Sends Telegram once per hour
- Alerts immediately if Ollama or Hermes Gateway goes down

### Step 3 — Finish the Unreal audit chunk (read-only)
```
.\scripts\03_audit_chunk_finisher.ps1
```
- Scans `Saved\Logs` for errors/warnings
- Scans `Source` folder (Build.cs, Target.cs, .cpp/.h counts)
- Scans `Content` folder (asset counts, maps, folder sizes)
- Writes three report files and updates progress files
- Sends Telegram before/after each phase
- **Does not edit, move, delete, or build anything**

### Step 4 — Start Cipher in Hermes
```
hermes
```
Then paste the startup prompt from `scripts\04_cipher_hermes_prompt.txt`.

---

## How to run scripts in PowerShell

Open a **fresh** PowerShell window (not inside Hermes):
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
cd "$env:USERPROFILE\path\to\CLAWED"
.\scripts\01_setup_ollama_cipher.ps1
```

---

## Verify heartbeat is installed
```powershell
Get-ScheduledTask -TaskName CipherHeartbeat
```

## Check heartbeat log
```powershell
notepad "$env:USERPROFILE\Desktop\CLAWED_PC_AUDIT_REAL\CIPHER_BRAIN\heartbeat\cipher_heartbeat.log"
```

## Check audit reports
```powershell
Get-ChildItem "$env:USERPROFILE\Desktop\CLAWED_PC_AUDIT_REAL" -File |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 20 Name, Length, LastWriteTime
```

---

## Why Cipher doesn't respond / common fixes

| Problem | Fix |
|---|---|
| `model not found` in Hermes | Run `01_setup_ollama_cipher.ps1` to recreate the wrapper |
| Hermes stuck "reflecting/contemplating" | Use `/steer` command from `04_cipher_hermes_prompt.txt` |
| Telegram `403 Forbidden` | Unblock the bot in Telegram: open the bot chat, press Start |
| CipherHeartbeat missing | Run `02_install_heartbeat.ps1` |
| Audit files not appearing | Run `03_audit_chunk_finisher.ps1` directly — bypass Hermes |
| Context at 87-90% | Hermes is compressing — wait, then use `/steer` |

---

## Cipher vs ForgeMind

Your agent's name is **Cipher**. If Hermes calls itself ForgeMind or anything else, paste this into the chat:

```
Your name is Cipher. Do not call yourself ForgeMind.
```

The `01_setup_ollama_cipher.ps1` script bakes the Cipher identity into the Ollama model system prompt so it sticks automatically.
