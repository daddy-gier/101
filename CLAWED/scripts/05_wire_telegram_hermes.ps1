# ============================================================
# CIPHER — TELEGRAM + HERMES FULL WIRING
# Sets token everywhere Hermes looks, tests Telegram,
# fires heartbeat, restarts Hermes Gateway
# ============================================================
# NOTE: Token below is the LIVE token. Rotate via @BotFather
# once integration is verified, then re-run this script with
# the new value in $Token.
# ============================================================

$Token          = "8870411603:AAFvmf7DLVqMliyjceM5_F7jp0XCQNmuc3g"
$TelegramUserId = "7615833146"

# ── 1. Set env vars (current + permanent user-level) ──
Write-Host ""
Write-Host "=== Setting environment variables ===" -ForegroundColor Cyan

$env:TELEGRAM_BOT_TOKEN = $Token
$env:TELEGRAM_CHAT_ID   = $TelegramUserId
[Environment]::SetEnvironmentVariable("TELEGRAM_BOT_TOKEN", $Token,          "User")
[Environment]::SetEnvironmentVariable("TELEGRAM_CHAT_ID",   $TelegramUserId, "User")
[Environment]::SetEnvironmentVariable("TELEGRAM_USER_ID",   $TelegramUserId, "User")

Write-Host "Env vars set (process + permanent user)" -ForegroundColor Green

# ── 2. Patch all Hermes .env files ─────────────────────
Write-Host ""
Write-Host "=== Patching Hermes .env files ===" -ForegroundColor Cyan

$envFiles = @(
    "$env:LOCALAPPDATA\hermes\.env",
    "$env:USERPROFILE\.hermes\.env"
)

foreach ($file in $envFiles) {
    $dir = Split-Path $file -Parent
    if (-not (Test-Path $dir))  { New-Item -ItemType Directory -Force -Path $dir  | Out-Null }
    if (-not (Test-Path $file)) { New-Item -ItemType File      -Force -Path $file | Out-Null }

    $lines    = @(Get-Content $file -ErrorAction SilentlyContinue)
    $newLines = @()
    $hadToken = $false
    $hadChat  = $false

    foreach ($line in $lines) {
        if ($line -match "^\s*(TELEGRAM_BOT_TOKEN|TELEGRAM_TOKEN|BOT_TOKEN)\s*=") {
            $newLines += "TELEGRAM_BOT_TOKEN=$Token"
            $hadToken = $true
        } elseif ($line -match "^\s*(TELEGRAM_CHAT_ID|TELEGRAM_USER_ID|TELEGRAM_HOME_CHAT)\s*=") {
            $newLines += "TELEGRAM_CHAT_ID=$TelegramUserId"
            $hadChat = $true
        } else {
            $newLines += $line
        }
    }

    if (-not $hadToken) { $newLines += "TELEGRAM_BOT_TOKEN=$Token" }
    if (-not $hadChat)  { $newLines += "TELEGRAM_CHAT_ID=$TelegramUserId" }

    Set-Content -Path $file -Value ($newLines -join "`r`n") -Encoding UTF8
    Write-Host "  Patched: $file" -ForegroundColor Green
}

# ── 3. Patch Hermes config.yaml (if present) ──────────
$configYaml = "$env:LOCALAPPDATA\hermes\config.yaml"
if (Test-Path $configYaml) {
    Write-Host ""
    Write-Host "=== Updating Hermes config ===" -ForegroundColor Cyan
    try { hermes config set telegram.bot_token $Token          2>$null } catch {}
    try { hermes config set telegram.chat_id   $TelegramUserId 2>$null } catch {}
    try { hermes config set telegram.home_chat $TelegramUserId 2>$null } catch {}
    Write-Host "  Hermes config patched." -ForegroundColor Green
}

# ── 4. Verify token with Telegram ─────────────────────
Write-Host ""
Write-Host "=== Verifying token with Telegram ===" -ForegroundColor Cyan

try {
    $me = Invoke-RestMethod "https://api.telegram.org/bot$Token/getMe" -TimeoutSec 15 -ErrorAction Stop
    if ($me.ok) {
        Write-Host "Bot alive: @$($me.result.username)" -ForegroundColor Green

        $msg = @"
Cipher fully wired ✅
Bot: @$($me.result.username)
Time: $(Get-Date)

- Process env: set
- User env: set permanently
- Hermes .env: patched
- Hermes config: patched
- Heartbeat: about to fire
- Gateway: restarting
"@

        Invoke-RestMethod -Uri "https://api.telegram.org/bot$Token/sendMessage" -Method Post -Body @{
            chat_id = $TelegramUserId
            text    = $msg
        } -TimeoutSec 15 | Out-Null

        Write-Host "Test message sent." -ForegroundColor Green
    } else {
        Write-Host "Token rejected by Telegram." -ForegroundColor Red
        return
    }
} catch {
    Write-Host "Telegram test failed: $($_.Exception.Message)" -ForegroundColor Red
    return
}

# ── 5. Trigger heartbeat now ──────────────────────────
Write-Host ""
Write-Host "=== Triggering CipherHeartbeat ===" -ForegroundColor Cyan
try {
    Start-ScheduledTask -TaskName CipherHeartbeat -ErrorAction Stop
    Write-Host "CipherHeartbeat fired." -ForegroundColor Green
} catch {
    Write-Host "CipherHeartbeat not installed. Run 02_install_heartbeat.ps1 first." -ForegroundColor Yellow
}

# ── 6. Restart Hermes Gateway ─────────────────────────
Write-Host ""
Write-Host "=== Restarting Hermes Gateway ===" -ForegroundColor Cyan

Get-CimInstance Win32_Process -ErrorAction SilentlyContinue |
    Where-Object { $_.CommandLine -match "hermes" -and $_.CommandLine -match "gateway" } |
    ForEach-Object {
        Write-Host "  Stopping gateway PID $($_.ProcessId)" -ForegroundColor Yellow
        Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue
    }

Start-Sleep -Seconds 2

Start-Process powershell.exe `
    -ArgumentList "-NoExit","-Command","`$env:TELEGRAM_BOT_TOKEN='$Token'; `$env:TELEGRAM_CHAT_ID='$TelegramUserId'; hermes gateway" `
    -WindowStyle Minimized

Write-Host "Gateway restarted with token in process env." -ForegroundColor Green

# ── Done ──────────────────────────────────────────────
Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host " TELEGRAM + HERMES WIRED" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host " Check Telegram for the confirmation message." -ForegroundColor Cyan
Write-Host " Future PowerShell windows will already have the token." -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Green
