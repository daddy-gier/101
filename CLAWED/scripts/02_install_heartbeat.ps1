# ============================================================
# CIPHER HEARTBEAT INSTALLER
# Installs Windows Scheduled Task: CipherHeartbeat
# Runs every 5 minutes — sends Telegram once per hour
# and immediately if Ollama or Hermes Gateway goes down
# ============================================================
# Run in a fresh PowerShell window (as your normal user)
# ============================================================

$ErrorActionPreference = "Continue"

$Root           = "$env:USERPROFILE\Desktop\CLAWED_PC_AUDIT_REAL"
$Brain          = "$Root\CIPHER_BRAIN"
$HeartbeatDir   = "$Brain\heartbeat"
$ScriptPath     = "$HeartbeatDir\cipher_heartbeat.ps1"
$TaskName       = "CipherHeartbeat"
$TelegramUserId = "7615833146"

New-Item -ItemType Directory -Force -Path $HeartbeatDir | Out-Null

# ── Write the heartbeat script ───────────────────────────────
$HeartbeatScript = @'
$ErrorActionPreference = "Continue"

$Root           = "$env:USERPROFILE\Desktop\CLAWED_PC_AUDIT_REAL"
$Brain          = "$Root\CIPHER_BRAIN"
$HeartbeatDir   = "$Brain\heartbeat"
$LogPath        = "$HeartbeatDir\cipher_heartbeat.log"
$StatusPath     = "$HeartbeatDir\CIPHER_HEARTBEAT_STATUS.md"
$LastHourlyPath = "$HeartbeatDir\last_hourly_status.txt"
$TelegramUserId = "7615833146"

New-Item -ItemType Directory -Force -Path $HeartbeatDir | Out-Null

function Log {
    param([string]$Message)
    Add-Content -Path $LogPath -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Message"
}

function Get-TelegramToken {
    if (![string]::IsNullOrWhiteSpace($env:TELEGRAM_BOT_TOKEN)) { return $env:TELEGRAM_BOT_TOKEN }
    foreach ($file in @("$env:LOCALAPPDATA\hermes\.env","$env:USERPROFILE\.hermes\.env")) {
        if (Test-Path $file) {
            foreach ($line in Get-Content $file -ErrorAction SilentlyContinue) {
                if ($line -match "^\s*(TELEGRAM_BOT_TOKEN|TELEGRAM_TOKEN|BOT_TOKEN)\s*=\s*(.+)\s*$") {
                    return $Matches[2].Trim().Trim('"').Trim("'")
                }
            }
        }
    }
    return $null
}

function Send-Telegram {
    param([string]$Text)
    $token = Get-TelegramToken
    if ([string]::IsNullOrWhiteSpace($token)) { Log "Telegram token missing."; return $false }
    if ($Text.Length -gt 3900) { $Text = $Text.Substring(0,3900) + "`n...[truncated]" }
    try {
        $r = Invoke-RestMethod -Uri "https://api.telegram.org/bot$token/sendMessage" -Method Post -Body @{
            chat_id = $TelegramUserId; text = $Text; disable_web_page_preview = $true
        } -TimeoutSec 30 -ErrorAction Stop
        if ($r.ok) { Log "Telegram sent."; return $true }
    } catch { Log "Telegram error: $($_.Exception.Message)" }
    return $false
}

function Test-Ollama {
    try { Invoke-RestMethod "http://127.0.0.1:11434/api/tags" -TimeoutSec 5 | Out-Null; return $true }
    catch { return $false }
}

function Start-Ollama {
    if (Test-Ollama) { Log "Ollama OK."; return "OK" }
    Log "Ollama down. Restarting."
    try {
        Start-Process -WindowStyle Hidden ollama -ArgumentList "serve"
        Start-Sleep -Seconds 8
        if (Test-Ollama) { Log "Ollama restarted."; return "RESTARTED" }
    } catch { Log "Ollama restart error: $($_.Exception.Message)" }
    return "FAILED"
}

function Test-HermesGateway {
    $p = Get-CimInstance Win32_Process -ErrorAction SilentlyContinue |
        Where-Object { $_.CommandLine -match "hermes" -and $_.CommandLine -match "gateway" }
    return [bool]$p
}

function Start-HermesGateway {
    if (Test-HermesGateway) { Log "Gateway OK."; return "OK" }
    Log "Gateway down. Restarting."
    try {
        Start-Process powershell.exe -ArgumentList "-NoExit","-Command","hermes gateway" -WindowStyle Minimized
        Start-Sleep -Seconds 10
        if (Test-HermesGateway) { Log "Gateway restarted."; return "RESTARTED" }
    } catch { Log "Gateway restart error: $($_.Exception.Message)" }
    return "FAILED"
}

function Get-LatestReports {
    if (!(Test-Path $Root)) { return "Audit root missing." }
    $f = Get-ChildItem $Root -File -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending | Select-Object -First 12 Name,Length,LastWriteTime
    if (!$f) { return "No report files yet." }
    return ($f | Format-Table -AutoSize | Out-String).Trim()
}

function Get-ProgressSnippet {
    $paths = @(
        "$Root\FOUR_DAY_PROGRESS.md","$Root\NEXT_ACTIONS.md",
        "$Root\DAY1_PROJECT_MAP.md","$Root\UNREAL_BUILD_READINESS.md",
        "$Root\BROKEN_THINGS_TO_REPAIR.md"
    )
    $out = ""
    foreach ($p in $paths) {
        if (Test-Path $p) {
            $out += "`n--- $(Split-Path $p -Leaf) ---`n"
            $out += ((Get-Content $p -ErrorAction SilentlyContinue | Select-Object -Last 10) -join "`n") + "`n"
        }
    }
    return if ($out) { $out.Trim() } else { "No progress files yet." }
}

# ── Main heartbeat logic ─────────────────────────────────────
$now     = Get-Date
Log "Heartbeat started."

$ollama  = Start-Ollama
$gateway = Start-HermesGateway
$reports = Get-LatestReports
$prog    = Get-ProgressSnippet

Set-Content $StatusPath @"
# CIPHER HEARTBEAT STATUS
Last heartbeat: $now

## Services
- Ollama:  $ollama
- Gateway: $gateway

## Latest Reports
$reports

## Progress
$prog
"@ -Encoding UTF8

if ($ollama -ne "OK" -or $gateway -ne "OK") {
    Send-Telegram "Cipher alert ⚠️`nTime: $now`nOllama: $ollama`nGateway: $gateway" | Out-Null
}

$currentHour = Get-Date -Format "yyyy-MM-dd HH"
$lastHour    = if (Test-Path $LastHourlyPath) { Get-Content $LastHourlyPath -First 1 } else { "" }

if ($currentHour -ne $lastHour) {
    Set-Content $LastHourlyPath $currentHour -Encoding UTF8
    Send-Telegram @"
Cipher hourly ✅
Time: $now
Ollama: $ollama  Gateway: $gateway

Reports:
$reports

Progress:
$prog
"@ | Out-Null
}

Log "Heartbeat done. Ollama=$ollama Gateway=$gateway"
'@

Set-Content -Path $ScriptPath -Value $HeartbeatScript -Encoding UTF8

# ── Register the scheduled task ─────────────────────────────
try { Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue } catch {}

$action   = New-ScheduledTaskAction -Execute "powershell.exe" `
              -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`""

$trigger  = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) `
              -RepetitionInterval (New-TimeSpan -Minutes 5) `
              -RepetitionDuration (New-TimeSpan -Days 30)

$settings = New-ScheduledTaskSettingsSet `
              -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries `
              -StartWhenAvailable -MultipleInstances IgnoreNew

Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger `
    -Settings $settings -Description "Cipher 5-min heartbeat, hourly Telegram" -Force | Out-Null

Write-Host "Task registered: $TaskName" -ForegroundColor Green

# Force first run immediately (and force the hourly message)
$LastHourlyPath = "$HeartbeatDir\last_hourly_status.txt"
if (Test-Path $LastHourlyPath) { Remove-Item $LastHourlyPath -Force }

Write-Host "Running heartbeat now..." -ForegroundColor Cyan
powershell.exe -NoProfile -ExecutionPolicy Bypass -File $ScriptPath

Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host " HEARTBEAT INSTALLED" -ForegroundColor Green
Write-Host " Runs every 5 min — Telegram once per hour" -ForegroundColor Cyan
Write-Host " Script:  $ScriptPath" -ForegroundColor Gray
Write-Host " Log:     $HeartbeatDir\cipher_heartbeat.log" -ForegroundColor Gray
Write-Host " Status:  $HeartbeatDir\CIPHER_HEARTBEAT_STATUS.md" -ForegroundColor Gray
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Verify with:" -ForegroundColor Yellow
Write-Host "  Get-ScheduledTask -TaskName CipherHeartbeat"
