# ============================================================
# CIPHER — FULL RESET + NEW BOT WIRING
# Kills all stuck Hermes processes
# Writes token under EVERY name variant Hermes might check
# Tests the bot
# Launches a fresh Hermes session inheriting the token
# ============================================================
# Bot: @theone1BotFather_bot
# ============================================================

$Token          = "8776583139:AAFcBWAsgsIQ4zMIMZ0A82ShImhDpSifLI8"
$TelegramUserId = "7615833146"

Write-Host ""
Write-Host "=== Killing stuck Hermes processes ===" -ForegroundColor Yellow

Get-CimInstance Win32_Process -ErrorAction SilentlyContinue |
    Where-Object { $_.CommandLine -match "hermes" -and $_.Name -notmatch "powershell" } |
    ForEach-Object {
        Write-Host "  Stop PID $($_.ProcessId): $($_.Name)" -ForegroundColor Yellow
        Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue
    }

Start-Sleep -Seconds 2

# ── Permanent + process env (all variants) ────────────────
Write-Host ""
Write-Host "=== Setting env vars (all variants) ===" -ForegroundColor Cyan

$names = @("TELEGRAM_BOT_TOKEN","TELEGRAM_TOKEN","BOT_TOKEN")
foreach ($n in $names) {
    Set-Item -Path "env:$n" -Value $Token
    [Environment]::SetEnvironmentVariable($n, $Token, "User")
}

$chatNames = @("TELEGRAM_CHAT_ID","TELEGRAM_USER_ID","TELEGRAM_HOME_CHAT")
foreach ($n in $chatNames) {
    Set-Item -Path "env:$n" -Value $TelegramUserId
    [Environment]::SetEnvironmentVariable($n, $TelegramUserId, "User")
}

Write-Host "  Env vars set under all variant names." -ForegroundColor Green

# ── Rewrite .env files cleanly ────────────────────────────
Write-Host ""
Write-Host "=== Rewriting .env files ===" -ForegroundColor Cyan

$envBlock = @"
TELEGRAM_BOT_TOKEN=$Token
TELEGRAM_TOKEN=$Token
BOT_TOKEN=$Token
TELEGRAM_CHAT_ID=$TelegramUserId
TELEGRAM_USER_ID=$TelegramUserId
TELEGRAM_HOME_CHAT=$TelegramUserId
"@

foreach ($f in @("$env:LOCALAPPDATA\hermes\.env","$env:USERPROFILE\.hermes\.env")) {
    $dir = Split-Path $f -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }

    $existing = if (Test-Path $f) { Get-Content $f -ErrorAction SilentlyContinue } else { @() }
    $kept     = $existing | Where-Object { $_ -notmatch "^\s*(TELEGRAM_|BOT_TOKEN)" -and $_ -ne "" }
    $kept    += $envBlock -split "`r?`n"

    Set-Content -Path $f -Value (($kept | Where-Object { $_ -ne "" }) -join "`r`n") -Encoding UTF8
    Write-Host "  Wrote: $f" -ForegroundColor Green
}

# ── Patch Hermes config.yaml ──────────────────────────────
$configYaml = "$env:LOCALAPPDATA\hermes\config.yaml"
if (Test-Path $configYaml) {
    Write-Host ""
    Write-Host "=== Patching Hermes config.yaml ===" -ForegroundColor Cyan
    try { hermes config set telegram.bot_token $Token          2>$null } catch {}
    try { hermes config set telegram.chat_id   $TelegramUserId 2>$null } catch {}
    try { hermes config set telegram.home_chat $TelegramUserId 2>$null } catch {}
    Write-Host "  config.yaml patched." -ForegroundColor Green
}

# ── Verify bot ────────────────────────────────────────────
Write-Host ""
Write-Host "=== Verifying new bot ===" -ForegroundColor Cyan

try {
    $me = Invoke-RestMethod "https://api.telegram.org/bot$Token/getMe" -TimeoutSec 15 -ErrorAction Stop

    if ($me.ok) {
        Write-Host "Bot alive: @$($me.result.username)" -ForegroundColor Green

        Invoke-RestMethod -Uri "https://api.telegram.org/bot$Token/sendMessage" -Method Post -Body @{
            chat_id = $TelegramUserId
            text    = "Cipher v2 bot wired ✅`nBot: @$($me.result.username)`nTime: $(Get-Date)`n`nAll env variants set. Fresh Hermes launching."
        } -TimeoutSec 15 | Out-Null

        Write-Host "Confirmation message sent." -ForegroundColor Green
    } else {
        Write-Host "Token rejected." -ForegroundColor Red
        return
    }
} catch {
    Write-Host "Telegram test failed: $($_.Exception.Message)" -ForegroundColor Red
    return
}

# ── Fire heartbeat once ───────────────────────────────────
Write-Host ""
Write-Host "=== Triggering CipherHeartbeat ===" -ForegroundColor Cyan
try {
    Start-ScheduledTask -TaskName CipherHeartbeat -ErrorAction Stop
    Write-Host "CipherHeartbeat fired." -ForegroundColor Green
} catch {
    Write-Host "(CipherHeartbeat not installed yet — skip)" -ForegroundColor Yellow
}

# ── IMPORTANT: open Telegram and press /start on the NEW bot ──
Write-Host ""
Write-Host "============================================================" -ForegroundColor Magenta
Write-Host " IMPORTANT: open @theone1BotFather_bot in Telegram" -ForegroundColor Magenta
Write-Host " and press /start so the bot can message you." -ForegroundColor Magenta
Write-Host "============================================================" -ForegroundColor Magenta

# ── Launch fresh Hermes ───────────────────────────────────
Write-Host ""
Write-Host "Launching fresh Hermes (token in process env)..." -ForegroundColor Cyan
Write-Host ""

hermes
