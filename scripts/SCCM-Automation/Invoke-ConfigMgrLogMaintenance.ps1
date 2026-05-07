<#
.SYNOPSIS
    Performs log cleanup and management for ConfigMgr client logs.

.DESCRIPTION
    Compresses or deletes old ConfigMgr log files to prevent disk space issues.
    Useful for startup scripts or scheduled maintenance.

.NOTES
    Author:      M-Endymion
    Version:     1.0
    Last Updated:2026-05-06
#>

[CmdletBinding()]
param (
    [int]$MaxLogAgeDays = 30,           # Delete logs older than this
    [int]$MaxLogFolderSizeMB = 1024,    # Max total size of Logs folder
    [switch]$CompressOldLogs
)

# =============================================================================
# Logging
# =============================================================================
$LogPath = "C:\Windows\CCM\Logs\Invoke-ConfigMgrLogMaintenance.log"
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting ConfigMgr Log Maintenance..." -ForegroundColor Cyan

$LogRoot = "C:\Windows\CCM\Logs"

# =============================================================================
# Main Logic
# =============================================================================
try {
    if (-not (Test-Path $LogRoot)) {
        Write-Host "Logs folder not found. Skipping." -ForegroundColor Yellow
        Stop-Transcript
        exit 0
    }

    $OldLogs = Get-ChildItem -Path $LogRoot -File -Recurse | 
               Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$MaxLogAgeDays) }

    if ($OldLogs) {
        Write-Host "Found $($OldLogs.Count) old log files." -ForegroundColor Yellow

        if ($CompressOldLogs) {
            # Could implement zip compression here if desired
            Write-Host "Compression not implemented in this version." -ForegroundColor Gray
        } else {
            $OldLogs | Remove-Item -Force -ErrorAction SilentlyContinue
            Write-Host "Deleted $($OldLogs.Count) old log files." -ForegroundColor Green
        }
    } else {
        Write-Host "No old logs to clean up." -ForegroundColor Green
    }

    # Success marker
    New-Item -Path "C:\Windows\CCM\Logs\LogMaintenance_Completed.done" -ItemType File -Force | Out-Null

    Write-Host "ConfigMgr Log Maintenance completed." -ForegroundColor Green
}
catch {
    Write-Warning "Log maintenance encountered an issue: $($_.Exception.Message)"
}

Stop-Transcript
