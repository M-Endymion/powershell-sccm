<#
.SYNOPSIS
    Automatically discovers and installs ConfigMgr client hotfixes (.msp files).

.DESCRIPTION
    Scans a specified hotfix folder and applies all .msp files using ccmsetup.
    Designed for use during client health checks or startup scripts.

.NOTES
    Author:      M-Endymion
    Version:     1.0
    Last Updated:2026-05-06
#>

[CmdletBinding()]
param (
    [string]$HotfixFolder = "C:\ConfigMgrHotfixes",
    [switch]$Fix
)

# =============================================================================
# Logging
# =============================================================================
$LogPath = "C:\Windows\CCM\Logs\Install-ConfigMgrHotfixes.log"
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting ConfigMgr Hotfix Installation..." -ForegroundColor Cyan

# =============================================================================
# Main Logic
# =============================================================================
try {
    if (-not (Test-Path $HotfixFolder)) {
        Write-Host "Hotfix folder not found: $HotfixFolder" -ForegroundColor Yellow
        Stop-Transcript
        exit 0
    }

    $Hotfixes = Get-ChildItem -Path $HotfixFolder -Filter "*.msp" -Recurse

    if ($Hotfixes.Count -eq 0) {
        Write-Host "No .msp hotfix files found." -ForegroundColor Green
        Stop-Transcript
        exit 0
    }

    Write-Host "Found $($Hotfixes.Count) hotfix files. Preparing to install..." -ForegroundColor Yellow

    $PatchList = $Hotfixes.FullName -join ';'

    if ($Fix) {
        Write-Host "Running ccmsetup with PATCH parameter..." -ForegroundColor Cyan
        $Result = Start-Process -FilePath "ccmsetup.exe" -ArgumentList "/REINSTALL=ALL /PATCH:`"$PatchList`"" -Wait -PassThru
        
        if ($Result.ExitCode -eq 0 -or $Result.ExitCode -eq 3010) {
            Write-Host "Hotfixes applied successfully." -ForegroundColor Green
        } else {
            Write-Warning "ccmsetup returned exit code: $($Result.ExitCode)"
        }
    } else {
        Write-Host "Hotfixes would be applied with: /PATCH:`"$PatchList`"" -ForegroundColor Gray
    }

    # Success marker
    New-Item -Path "C:\Windows\CCM\Logs\ConfigMgrHotfixes_Applied.done" -ItemType File -Force | Out-Null

    Write-Host "ConfigMgr Hotfix process completed." -ForegroundColor Green
}
catch {
    Write-Error "Hotfix installation failed: $($_.Exception.Message)"
}

Stop-Transcript
