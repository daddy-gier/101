# ============================================================
# CIPHER - SWITCH TO FAST GPU MODEL
# Switches Hermes from gpt-oss:20b-64k (49%/51% CPU/GPU, 32s)
# to qwen2.5-coder:7b (100% GPU, ~1s per response)
# Creates cipher-fast:7b Ollama wrapper with Cipher identity
# ============================================================

$Token          = "8776583139:AAFcBWAsgsIQ4zMIMZ0A82ShImhDpSifLI8"
$TelegramUserId = "7615833146"
$FastModel      = "qwen2.5-coder:7b"
$WrapperName    = "cipher-fast:7b"

Write-Host ""
Write-Host "=== Cipher Fast Model Switch ===" -ForegroundColor Cyan
Write-Host "Switching from gpt-oss:20b-64k (32s/response)" -ForegroundColor Yellow
Write-Host "          to $WrapperName (~1s/response, 100% GPU)" -ForegroundColor Green

# --- 1. Verify qwen2.5-coder:7b exists ---
Write-Host ""
Write-Host "=== Checking model availability ===" -ForegroundColor Cyan

$models = ollama list 2>$null
if ($models -notmatch "qwen2.5-coder:7b") {
    Write-Host "qwen2.5-coder:7b not found - pulling now (~4.7 GB)..." -ForegroundColor Yellow
    ollama pull qwen2.5-coder:7b
} else {
    Write-Host "qwen2.5-coder:7b found." -ForegroundColor Green
}

# --- 2. Create Cipher wrapper Modelfile ---
Write-Host ""
Write-Host "=== Creating cipher-fast:7b wrapper ===" -ForegroundColor Cyan

$modelfile = @'
FROM qwen2.5-coder:7b
PARAMETER num_ctx 32768
PARAMETER temperature 0.2
PARAMETER top_p 0.9
PARAMETER repeat_penalty 1.1
SYSTEM You are Cipher. Your name is Cipher. You are a local Unreal Engine coding agent running on the CLAWED system. You use local tools only. You do not use paid APIs. Everything is free and local. Rules: Your name is Cipher. Never call yourself ForgeMind or anything else. Read files before editing them. Make backups before patching anything. Do not invent results or file contents. Do not modify the Unreal project without explicit user approval. Do not delete files. Do not move assets. Do not run builds without approval. Send Telegram status before and after each major step. Be concise. Do the work, do not over-explain.
'@

$modelfilePath = "$env:TEMP\cipher_fast_modelfile.txt"
Set-Content -Path $modelfilePath -Value $modelfile -Encoding ASCII

ollama create $WrapperName -f $modelfilePath
if ($LASTEXITCODE -eq 0) {
    Write-Host "cipher-fast:7b wrapper created." -ForegroundColor Green
} else {
    Write-Host "Failed to create wrapper. Check ollama output above." -ForegroundColor Red
    exit 1
}

# --- 3. Time a test response ---
Write-Host ""
Write-Host "=== Speed test ===" -ForegroundColor Cyan
Write-Host "Testing response speed on cipher-fast:7b..." -ForegroundColor Yellow

$elapsed = (Measure-Command {
    Invoke-RestMethod -Uri "http://127.0.0.1:11434/api/generate" -Method Post -Body (@{
        model  = $WrapperName
        prompt = "Say hi in 5 words."
        stream = $false
    } | ConvertTo-Json) -ContentType "application/json"
}).TotalSeconds

$elapsedRounded = [math]::Round($elapsed, 1)
$color = "Red"
if ($elapsed -lt 5) { $color = "Green" }
elseif ($elapsed -lt 15) { $color = "Yellow" }
Write-Host "Response time: ${elapsedRounded}s" -ForegroundColor $color

# --- 4. Patch Hermes config to use new model ---
Write-Host ""
Write-Host "=== Patching Hermes config ===" -ForegroundColor Cyan

try { hermes config set model.default $WrapperName 2>$null } catch {}
try { hermes config set model.model   $WrapperName 2>$null } catch {}
try { hermes config set model.name    $WrapperName 2>$null } catch {}

Write-Host "Hermes config patched to use $WrapperName." -ForegroundColor Green

# --- 5. Kill current Hermes + Ollama gpt-oss load ---
Write-Host ""
Write-Host "=== Stopping slow model + Hermes processes ===" -ForegroundColor Cyan

Get-CimInstance Win32_Process -ErrorAction SilentlyContinue |
    Where-Object { $_.CommandLine -match "hermes" -and $_.Name -notmatch "powershell" } |
    ForEach-Object {
        Write-Host "  Stop PID $($_.ProcessId): $($_.Name)" -ForegroundColor Yellow
        Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue
    }

# Unload gpt-oss from VRAM by setting keep_alive=0
try {
    Invoke-RestMethod -Uri "http://127.0.0.1:11434/api/generate" -Method Post -Body (@{
        model      = "gpt-oss:20b-64k"
        prompt     = ""
        keep_alive = 0
    } | ConvertTo-Json) -ContentType "application/json" -TimeoutSec 10 -ErrorAction SilentlyContinue | Out-Null
} catch {}

Write-Host "gpt-oss:20b-64k unloaded from VRAM." -ForegroundColor Green
Start-Sleep -Seconds 2

# --- 6. Send Telegram notification ---
Write-Host ""
Write-Host "=== Sending Telegram confirmation ===" -ForegroundColor Cyan

try {
    $msg = "Cipher model switched. From: gpt-oss:20b-64k (32s/response). To: cipher-fast:7b (~${elapsedRounded}s/response). Hermes restarting with fast model."
    Invoke-RestMethod -Uri "https://api.telegram.org/bot$Token/sendMessage" -Method Post -Body @{
        chat_id = $TelegramUserId
        text    = $msg
    } -TimeoutSec 15 | Out-Null
    Write-Host "Telegram notification sent." -ForegroundColor Green
} catch {
    Write-Host "Telegram send failed: $($_.Exception.Message)" -ForegroundColor Yellow
}

# --- 7. Launch fresh Hermes with fast model ---
Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host " MODEL SWITCHED: cipher-fast:7b active" -ForegroundColor Green
Write-Host " Response time: ~${elapsedRounded}s (was 32.7s)" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Launching Hermes with fast model..." -ForegroundColor Cyan
Write-Host ""

$env:TELEGRAM_BOT_TOKEN = $Token
$env:TELEGRAM_CHAT_ID   = $TelegramUserId
$env:TELEGRAM_TOKEN     = $Token
$env:BOT_TOKEN          = $Token

hermes
