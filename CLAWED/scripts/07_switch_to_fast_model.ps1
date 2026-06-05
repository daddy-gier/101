# ============================================================
# CIPHER FAST MODEL SWITCH - SAFE FIXED VERSION
# Creates cipher-fast:7b from qwen2.5-coder:7b
# No hardcoded Telegram token.
# Uses env/.env tokens only if already configured.
# ============================================================

$ErrorActionPreference = "Continue"

$FastModel = "qwen2.5-coder:7b"
$WrapperName = "cipher-fast:7b"
$Root = "$env:USERPROFILE\Desktop\CLAWED_PC_AUDIT_REAL"
$ReportRoot = Join-Path $Root "CIPHER_MODEL_SWITCH"
$Report = Join-Path $ReportRoot "FAST_MODEL_SWITCH_REPORT.md"
$Now = Get-Date

New-Item -ItemType Directory -Force -Path $ReportRoot | Out-Null

Write-Host ""
Write-Host "=== Cipher Fast Model Switch ===" -ForegroundColor Cyan
Write-Host "Target model: $WrapperName" -ForegroundColor Yellow

# ------------------------------------------------------------
# 1. Make sure Ollama is running
# ------------------------------------------------------------

try {
    Invoke-RestMethod "http://127.0.0.1:11434/api/tags" -TimeoutSec 5 | Out-Null
    Write-Host "Ollama API is alive." -ForegroundColor Green
}
catch {
    Write-Host "Ollama not responding. Starting ollama serve..." -ForegroundColor Yellow
    Start-Process -WindowStyle Hidden -FilePath "ollama" -ArgumentList "serve"
    Start-Sleep -Seconds 8
}

# ------------------------------------------------------------
# 2. Verify qwen model exists
# ------------------------------------------------------------

$models = ollama list 2>$null

if ($models -notmatch [regex]::Escape($FastModel)) {
    Write-Host "$FastModel not found. Pulling now..." -ForegroundColor Yellow
    ollama pull $FastModel
}
else {
    Write-Host "$FastModel found." -ForegroundColor Green
}

# ------------------------------------------------------------
# 3. Create Cipher wrapper model
# ------------------------------------------------------------

$ModelfilePath = Join-Path $ReportRoot "Modelfile.cipher-fast-7b"

@"
FROM $FastModel
PARAMETER num_ctx 32768
PARAMETER temperature 0.2
PARAMETER top_p 0.9
PARAMETER repeat_penalty 1.1
SYSTEM """
You are Cipher.
You are Lee Gier's local Unreal Engine, Money Ops, and automation assistant.
Use local/free tools first.
Do not use paid APIs.
Do not fake progress.
Do not replace useful files with placeholders.
Read files before editing them.
Make backups before patching important files.
Do not expose secrets, passwords, API keys, or tokens.
Do not delete or wipe files.
Do not spend money.
Preserve useful project content and append improvements.
"""
"@ | Set-Content -Path $ModelfilePath -Encoding UTF8

Write-Host "Creating Ollama wrapper: $WrapperName" -ForegroundColor Cyan
ollama create $WrapperName -f $ModelfilePath

if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to create $WrapperName." -ForegroundColor Red
    exit 1
}

# ------------------------------------------------------------
# 4. Speed test
# ------------------------------------------------------------

Write-Host "Testing model speed..." -ForegroundColor Cyan

$Body = @{
    model = $WrapperName
    prompt = "Say ready."
    stream = $false
} | ConvertTo-Json -Depth 10

try {
    $elapsed = (Measure-Command {
        $resp = Invoke-RestMethod `
            -Uri "http://127.0.0.1:11434/api/generate" `
            -Method Post `
            -ContentType "application/json" `
            -Body $Body `
            -TimeoutSec 120
    }).TotalSeconds

    $SpeedText = "$([math]::Round($elapsed, 2)) seconds"
    Write-Host "Response time: $SpeedText" -ForegroundColor Green
}
catch {
    $SpeedText = "Speed test failed: $($_.Exception.Message)"
    Write-Host $SpeedText -ForegroundColor Yellow
}

# ------------------------------------------------------------
# 5. Set OpenClaw model if available
# ------------------------------------------------------------

if (Get-Command openclaw -ErrorAction SilentlyContinue) {
    Write-Host "Setting OpenClaw model to ollama/$WrapperName..." -ForegroundColor Cyan
    openclaw models set "ollama/$WrapperName"

    Write-Host "Restarting OpenClaw gateway..." -ForegroundColor Cyan
    openclaw gateway stop
    Start-Sleep -Seconds 3
    Start-Process -WindowStyle Minimized -FilePath "powershell.exe" -ArgumentList "-NoExit", "-Command", "openclaw gateway"
}

# ------------------------------------------------------------
# 6. Try to set Hermes model using config command if supported
# ------------------------------------------------------------

if (Get-Command hermes -ErrorAction SilentlyContinue) {
    Write-Host "Trying to set Hermes model to $WrapperName..." -ForegroundColor Cyan

    try { hermes config set model $WrapperName } catch {}
    try { hermes config set general.model $WrapperName } catch {}
    try { hermes config set model.default $WrapperName } catch {}
}

# ------------------------------------------------------------
# 7. Write report
# ------------------------------------------------------------

@"
# CIPHER FAST MODEL SWITCH REPORT

## Updated
$Now

## Target
$WrapperName

## Base Model
$FastModel

## Speed Test
$SpeedText

## What Changed
- Verified/pulled $FastModel.
- Created Ollama wrapper $WrapperName.
- Attempted OpenClaw model switch.
- Attempted Hermes model switch.
- No hardcoded Telegram token used.

## Notes
The Claude/GitHub raw script was not used because it was malformed and contained a hardcoded Telegram bot token.

## Next Manual Test
Run:

openclaw models status
ollama list

Then test Hermes/OpenClaw with:

say ready
"@ | Set-Content $Report -Encoding UTF8

Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host " CIPHER FAST MODEL SWITCH COMPLETE" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host "Report:" -ForegroundColor Yellow
Write-Host $Report -ForegroundColor Cyan
