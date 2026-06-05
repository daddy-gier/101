# ============================================================
# CIPHER CLAWED AUDIT CHUNK FINISHER
# Read-only scan: Saved Logs + Source + Content
# Sends Telegram before/after each phase
# Does NOT edit, move, delete, or build anything
# ============================================================
# Run in a fresh PowerShell window (NOT inside Hermes)
# ============================================================

$ErrorActionPreference = "Continue"

$Root           = "$env:USERPROFILE\Desktop\CLAWED_PC_AUDIT_REAL"
$ProjectRoot    = "$env:USERPROFILE\Documents\Unreal Projects\ALLMINErebuiltagain"
$LogsDir        = "$ProjectRoot\Saved\Logs"
$SourceDir      = "$ProjectRoot\Source"
$ContentDir     = "$ProjectRoot\Content"
$TelegramUserId = "7615833146"

New-Item -ItemType Directory -Force -Path $Root | Out-Null

# ── Helpers ──────────────────────────────────────────────────
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
    if ([string]::IsNullOrWhiteSpace($token)) { Write-Warning "Telegram token not found."; return }
    if ($Text.Length -gt 3900) { $Text = $Text.Substring(0,3900) + "`n...[truncated]" }
    try {
        Invoke-RestMethod -Uri "https://api.telegram.org/bot$token/sendMessage" -Method Post -Body @{
            chat_id = $TelegramUserId; text = $Text; disable_web_page_preview = $true
        } -TimeoutSec 30 | Out-Null
    } catch {
        Add-Content "$Root\TELEGRAM_ERRORS.md" "[$(Get-Date)] $($_.Exception.Message)"
    }
}

function Section {
    param([string]$Path,[string]$Title,[string]$Body)
    Add-Content $Path "`n## $Title`n$Body"
}

Send-Telegram "Cipher audit chunk starting ⏳`nScanning: Saved Logs, Source, Content`nProject: ALLMINErebuiltagain"

# ============================================================
# STEP 1 — SAVED LOGS
# ============================================================
Send-Telegram "Cipher: Step 1/3 — Saved Logs audit starting."
$report1 = "$Root\SAVED_LOGS_ERROR_AUDIT.md"

@"
# SAVED LOGS ERROR AUDIT
Generated: $(Get-Date)
Scope: $LogsDir
Safety: Read-only. No files modified.
"@ | Set-Content $report1 -Encoding UTF8

if (Test-Path $LogsDir) {
    $logFiles = Get-ChildItem $LogsDir -File -Include "*.log","*.txt" -Recurse -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending

    Section $report1 "Log Files Found" (
        ($logFiles | Select-Object Name,Length,LastWriteTime | Format-Table -AutoSize | Out-String).Trim()
    )

    $keywords = "Error|Warning|Critical|Fatal|Crash|Exception|Plugin|Python|Blueprint|Compile|Missing|Failed|Assertion"
    $hits = @()

    foreach ($lf in ($logFiles | Select-Object -First 20)) {
        $found = Select-String -Path $lf.FullName -Pattern $keywords -CaseSensitive:$false -ErrorAction SilentlyContinue |
            Select-Object -First 60
        if ($found) { $hits += $found }
    }

    if ($hits.Count -gt 0) {
        $body = ($hits | ForEach-Object {
            "$($_.Filename):$($_.LineNumber)  $($_.Line.Trim())"
        }) -join "`n"
        Section $report1 "Keyword Matches (Error/Warning/etc)" $body
    } else {
        Section $report1 "Keyword Matches" "None found in newest 20 log files."
    }
} else {
    Section $report1 "Result" "Logs folder not found: $LogsDir"
}

Send-Telegram "Cipher: Step 1/3 complete — SAVED_LOGS_ERROR_AUDIT.md written."

# ============================================================
# STEP 2 — SOURCE MODULE
# ============================================================
Send-Telegram "Cipher: Step 2/3 — Source module audit starting."
$report2 = "$Root\SOURCE_MODULE_AUDIT.md"

@"
# SOURCE MODULE AUDIT
Generated: $(Get-Date)
Scope: $SourceDir
Safety: Read-only. No files modified.
"@ | Set-Content $report2 -Encoding UTF8

if (Test-Path $SourceDir) {
    $folders  = Get-ChildItem $SourceDir -Directory -Recurse -ErrorAction SilentlyContinue
    $buildCs  = Get-ChildItem $SourceDir -Filter "*.Build.cs"  -Recurse -ErrorAction SilentlyContinue
    $targetCs = Get-ChildItem $SourceDir -Filter "*.Target.cs" -Recurse -ErrorAction SilentlyContinue
    $cpp      = Get-ChildItem $SourceDir -Filter "*.cpp"       -Recurse -ErrorAction SilentlyContinue
    $headers  = Get-ChildItem $SourceDir -Filter "*.h"         -Recurse -ErrorAction SilentlyContinue

    Section $report2 "Folders" (
        ($folders | Select-Object FullName,LastWriteTime | Format-Table -AutoSize | Out-String).Trim()
    )
    Section $report2 "File Counts" ".cpp: $($cpp.Count)   .h: $($headers.Count)   Build.cs: $($buildCs.Count)   Target.cs: $($targetCs.Count)"

    Section $report2 "Build.cs Files" (
        ($buildCs | Select-Object FullName,Length,LastWriteTime | Format-Table -AutoSize | Out-String).Trim()
    )
    foreach ($f in $buildCs) {
        Section $report2 "Build.cs Preview: $($f.Name)" (
            (Get-Content $f.FullName -ErrorAction SilentlyContinue | Select-Object -First 80) -join "`n"
        )
    }

    Section $report2 "Target.cs Files" (
        ($targetCs | Select-Object FullName,Length,LastWriteTime | Format-Table -AutoSize | Out-String).Trim()
    )
    foreach ($f in $targetCs) {
        Section $report2 "Target.cs Preview: $($f.Name)" (
            (Get-Content $f.FullName -ErrorAction SilentlyContinue | Select-Object -First 40) -join "`n"
        )
    }

    Section $report2 "Notes" "Review module dependencies before attempting any compile. No source was modified."
} else {
    Section $report2 "Result" "Source folder not found: $SourceDir"
}

Send-Telegram "Cipher: Step 2/3 complete — SOURCE_MODULE_AUDIT.md written."

# ============================================================
# STEP 3 — CONTENT FOLDER
# ============================================================
Send-Telegram "Cipher: Step 3/3 — Content folder scan starting."
$report3 = "$Root\CONTENT_FOLDER_SCAN.md"

@"
# CONTENT FOLDER SCAN
Generated: $(Get-Date)
Scope: $ContentDir
Safety: Read-only. No files modified.
"@ | Set-Content $report3 -Encoding UTF8

if (Test-Path $ContentDir) {
    $topFolders = Get-ChildItem $ContentDir -Directory -ErrorAction SilentlyContinue
    $allFiles   = Get-ChildItem $ContentDir -File -Recurse -ErrorAction SilentlyContinue

    $extCounts = $allFiles | Group-Object Extension | Sort-Object Count -Descending
    $maps      = $allFiles | Where-Object Extension -ieq ".umap"
    $uassets   = $allFiles | Where-Object Extension -ieq ".uasset"

    $folderSizes = $topFolders | ForEach-Object {
        $sub = Get-ChildItem $_.FullName -File -Recurse -ErrorAction SilentlyContinue
        [PSCustomObject]@{
            Folder       = $_.Name
            Files        = $sub.Count
            SizeMB       = [math]::Round((($sub | Measure-Object Length -Sum).Sum / 1MB), 1)
            LastModified = $_.LastWriteTime
        }
    } | Sort-Object SizeMB -Descending

    Section $report3 "Top-Level Content Folders" (
        ($topFolders | Select-Object FullName,LastWriteTime | Format-Table -AutoSize | Out-String).Trim()
    )
    Section $report3 "Asset Counts by Extension" (
        ($extCounts | Format-Table Count,Name -AutoSize | Out-String).Trim()
    )
    Section $report3 "Total Counts" ".uasset: $($uassets.Count)   .umap: $($maps.Count)   All files: $($allFiles.Count)"
    Section $report3 "Map Files (.umap)" (
        ($maps | Select-Object FullName,Length,LastWriteTime | Format-Table -AutoSize | Out-String).Trim()
    )
    Section $report3 "Folder Sizes (Top-Level)" (
        ($folderSizes | Format-Table -AutoSize | Out-String).Trim()
    )
    Section $report3 "Notes" "Inventory only. No assets were moved, imported, or modified."
} else {
    Section $report3 "Result" "Content folder not found: $ContentDir"
}

Send-Telegram "Cipher: Step 3/3 complete — CONTENT_FOLDER_SCAN.md written."

# ============================================================
# STEP 4 — UPDATE PROGRESS FILES
# ============================================================
$now = Get-Date

@"
# NEXT ACTIONS
Updated: $now

## Completed This Chunk
- Saved Logs audit
- Source module audit
- Content folder scan

## Next Safe Tasks
1. Review SAVED_LOGS_ERROR_AUDIT.md — identify priority fixes
2. Broader asset discovery across all drives
3. Create ASSET_INVENTORY_DETAILED.md
4. Create ASSET_IMPORT_PLAN.md
5. Draft Unreal Python dry-run import script (approval required before execution)

## Approval Needed
Required before: editing files, moving assets, running builds, importing, deleting, or changing project files.
"@ | Set-Content "$Root\NEXT_ACTIONS.md" -Encoding UTF8

@"
# FOUR DAY PROGRESS
Updated: $now

## Completed
- Saved Logs error audit
- Source module audit
- Content folder scan

## Reports Written
- SAVED_LOGS_ERROR_AUDIT.md
- SOURCE_MODULE_AUDIT.md
- CONTENT_FOLDER_SCAN.md
- NEXT_ACTIONS.md
- FOUR_DAY_PROGRESS.md
- CIPHER_SESSION_SUMMARY.md
- REAL_STATUS_REPORT.md
"@ | Set-Content "$Root\FOUR_DAY_PROGRESS.md" -Encoding UTF8

@"
# CIPHER SESSION SUMMARY
Updated: $now

Cipher completed the current read-only CLAWED audit chunk via PowerShell.

## Done
- Inspected Saved\Logs for errors/warnings
- Inspected Source folder — Build.cs and Target.cs previewed
- Scanned Content folder — asset counts, maps, folder sizes
- Wrote three new reports
- Updated NEXT_ACTIONS.md and FOUR_DAY_PROGRESS.md
- Sent Telegram status for each phase

## Safety
No Unreal project files were edited, moved, deleted, or compiled.
"@ | Set-Content "$Root\CIPHER_SESSION_SUMMARY.md" -Encoding UTF8

@"
# REAL STATUS REPORT
Updated: $now

## Status: Audit Chunk Complete

## Reports Completed
- SAVED_LOGS_ERROR_AUDIT.md
- SOURCE_MODULE_AUDIT.md
- CONTENT_FOLDER_SCAN.md

## Heartbeat
CipherHeartbeat scheduled task sends Telegram once per hour and alerts on service failures.

## Next
Broader asset discovery. Safe import plan. No project modifications without approval.
"@ | Set-Content "$Root\REAL_STATUS_REPORT.md" -Encoding UTF8

Send-Telegram "Cipher audit chunk complete ✅`nSaved Logs, Source, and Content scans done.`nReports written. Next: asset discovery + import planning."

Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host " AUDIT CHUNK COMPLETE" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Get-ChildItem $Root -File |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 15 Name,Length,LastWriteTime |
    Format-Table -AutoSize
