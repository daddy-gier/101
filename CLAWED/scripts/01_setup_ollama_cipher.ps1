# ============================================================
# CIPHER SETUP — Ollama Model + Hermes Config
# Run this in a fresh PowerShell window (NOT inside Hermes)
# ============================================================
# What this does:
#   1. Starts Ollama if not running
#   2. Checks which models you have
#   3. Creates the gpt-oss:20b-64k wrapper if missing
#   4. Patches Hermes config to use local Ollama endpoint
#   5. Sends a Telegram test message
# ============================================================

$ErrorActionPreference = "Continue"

$OllamaBase     = "http://127.0.0.1:11434/v1"
$WrapperModel   = "gpt-oss:20b-64k"
$FallbackModel  = "qwen2.5-coder:7b"        # already downloaded
$ContextSize    = "65536"
$TelegramUserId = "7615833146"
$ModelDir       = "$env:USERPROFILE\ollama-models"
$Modelfile      = "$ModelDir\Modelfile.gpt-oss-20b-64k"

Write-Host ""
Write-Host "=== CIPHER / OLLAMA SETUP ===" -ForegroundColor Cyan
Write-Host ""

# ── Step 1: Ensure Ollama is running ────────────────────────
function Test-Ollama {
    try {
        Invoke-RestMethod "http://127.0.0.1:11434/api/tags" -TimeoutSec 5 | Out-Null
        return $true
    } catch { return $false }
}

if (-not (Test-Ollama)) {
    Write-Host "Starting Ollama..." -ForegroundColor Yellow
    Start-Process -WindowStyle Hidden ollama -ArgumentList "serve"
    Start-Sleep -Seconds 8
}

if (Test-Ollama) {
    Write-Host "Ollama is running." -ForegroundColor Green
} else {
    Write-Host "Ollama did not start. Install from https://ollama.com" -ForegroundColor Red
    exit 1
}

# ── Step 2: Show available models ───────────────────────────
Write-Host ""
Write-Host "Models currently in Ollama:" -ForegroundColor Cyan
ollama list

$allModels = ollama list

# ── Step 3: Choose base model ───────────────────────────────
$BaseModel = ""

if ($allModels -match "gpt-oss:20b") {
    $BaseModel = "gpt-oss:20b"
    Write-Host "Using base: gpt-oss:20b" -ForegroundColor Green
} elseif ($allModels -match "qwen2.5-coder:7b") {
    $BaseModel = "qwen2.5-coder:7b"
    Write-Host "gpt-oss:20b not found. Falling back to: qwen2.5-coder:7b" -ForegroundColor Yellow
} elseif ($allModels -match "qwen2.5:7b") {
    $BaseModel = "qwen2.5:7b"
    Write-Host "Using base: qwen2.5:7b" -ForegroundColor Yellow
} else {
    Write-Host "No known base model found. Pulling qwen2.5-coder:7b..." -ForegroundColor Yellow
    ollama pull qwen2.5-coder:7b
    $BaseModel = "qwen2.5-coder:7b"
}

# ── Step 4: Build wrapper model ─────────────────────────────
New-Item -ItemType Directory -Force -Path $ModelDir | Out-Null

@"
FROM $BaseModel
PARAMETER num_ctx 65536
SYSTEM "You are Cipher, a local terminal-based AI coding agent. You specialize in Unreal Engine C++, Blueprints, game development, and PowerShell automation. You run fully offline on local Ollama. You never use paid APIs. Always read files before editing. Always make backups before patching. Your name is Cipher."
"@ | Set-Content $Modelfile -Encoding UTF8

Write-Host ""
Write-Host "Creating wrapper model: $WrapperModel" -ForegroundColor Cyan
ollama create $WrapperModel -f $Modelfile

Write-Host ""
Write-Host "Verifying model:" -ForegroundColor Cyan
ollama list | Select-String "gpt-oss|qwen|cipher"

# ── Step 5: Patch Hermes config ─────────────────────────────
Write-Host ""
Write-Host "Patching Hermes config..." -ForegroundColor Cyan

$hermesConfigs = @{
    "model.default"                              = $WrapperModel
    "model.model"                                = $WrapperModel
    "model.name"                                 = $WrapperModel
    "model.base_url"                             = $OllamaBase
    "model.context_length"                       = $ContextSize
    "model.max_context_length"                   = $ContextSize
    "model.compatibility"                        = "chat_completions"
    "model.api_mode"                             = "chat_completions"
    "auxiliary.compression.model"                = $WrapperModel
    "auxiliary.compression.provider"             = "custom"
    "auxiliary.compression.base_url"             = $OllamaBase
    "auxiliary.compression.context_length"       = $ContextSize
    "auxiliary.compression.max_context_length"   = $ContextSize
    "auxiliary.compression.compatibility"        = "chat_completions"
    "auxiliary.compression.api_mode"             = "chat_completions"
}

foreach ($kv in $hermesConfigs.GetEnumerator()) {
    try { hermes config set $kv.Key $kv.Value 2>$null } catch {}
}

Write-Host "Hermes config patched." -ForegroundColor Green

# ── Step 6: Telegram test ────────────────────────────────────
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

$token = Get-TelegramToken

if ($token) {
    try {
        Invoke-RestMethod -Uri "https://api.telegram.org/bot$token/sendMessage" -Method Post -Body @{
            chat_id                  = $TelegramUserId
            text                     = "Cipher setup complete ✅`nModel: $WrapperModel`nEndpoint: $OllamaBase`nTime: $(Get-Date)"
            disable_web_page_preview = $true
        } -TimeoutSec 15 | Out-Null
        Write-Host "Telegram test sent." -ForegroundColor Green
    } catch {
        Write-Host "Telegram failed: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "Telegram token not found. Set TELEGRAM_BOT_TOKEN in hermes .env" -ForegroundColor Yellow
}

# ── Done ─────────────────────────────────────────────────────
Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host " DONE. Start Cipher with:" -ForegroundColor Green
Write-Host ""
Write-Host "   hermes" -ForegroundColor Yellow
Write-Host ""
Write-Host " Then ask: Who are you, what model, what endpoint?" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Green
