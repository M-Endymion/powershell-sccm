<#
.SYNOPSIS
    Resets Windows Update components to fix hung/stuck updates.

.DESCRIPTION
    This script performs a complete reset of Windows Update services and cache.
    It stops required services, renames the SoftwareDistribution and catroot2 folders,
    then restarts the services. Designed for SCCM / MECM deployment.

.NOTES
    Author: M-Endymion
    Version: 1.0
    Based on: Proven manual troubleshooting steps
    Last Updated: 2026-05-06

.EXAMPLE
    .\Fix-HungWindowsUpdates.ps1
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param()

# =============================================================================
# Configuration
# =============================================================================
$LogPath = "C:\Windows\CCM\Logs\Fix-HungWindowsUpdates.log"
$BackupSuffix = "_bak_$(Get-Date -Format 'yyyyMMdd_HHmmss')"

# =============================================================================
# Start Logging
# =============================================================================
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting Windows Update Reset Process..." -ForegroundColor Cyan

# =============================================================================
# Helper Function
# =============================================================================
function Stop-ServiceSafely {
    param([string]$ServiceName)
    Write-Host "Stopping service: $ServiceName" -ForegroundColor Yellow
    Stop-Service -Name $ServiceName -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2

    $Service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
    if ($Service.Status -eq 'Running') {
        Write-Host "Service $ServiceName is still running. Attempting to kill..." -ForegroundColor Red
        $Process = Get-WmiObject Win32_Service | Where-Object { $_.Name -eq $ServiceName }
        if ($Process) {
            taskkill /PID $Process.ProcessId /F | Out-Null
            Start-Sleep -Seconds 2
        }
    }
}

# =============================================================================
# Main Process
# =============================================================================
try {
    Write-Host "Phase 1: Stopping Services..." -ForegroundColor Cyan

    Stop-ServiceSafely -ServiceName "usosvc"
    Stop-ServiceSafely -ServiceName "dosvc"
    Stop-ServiceSafely -ServiceName "wuauserv"
    Stop-ServiceSafely -ServiceName "bits"
    Stop-ServiceSafely -ServiceName "cryptsvc"

    # =============================================================================
    # Rename Cache Folders
    # =============================================================================
    Write-Host "Phase 2: Renaming cache folders..." -ForegroundColor Cyan

    $Paths = @(
        @{Path = "C:\Windows\SoftwareDistribution"; Name = "SoftwareDistribution"},
        @{Path = "C:\Windows\System32\catroot2"; Name = "catroot2"}
    )

    foreach ($Item in $Paths) {
        if (Test-Path $Item.Path) {
            $NewName = "$($Item.Path)$BackupSuffix"
            Write-Host "Renaming $($Item.Name) to backup..." -ForegroundColor Yellow
            Rename-Item -Path $Item.Path -NewName (Split-Path $NewName -Leaf) -Force
            Write-Host "Renamed $($Item.Name) successfully." -ForegroundColor Green
        }
    }

    # =============================================================================
    # Restart Services
    # =============================================================================
    Write-Host "Phase 3: Restarting Services..." -ForegroundColor Cyan

    Start-Service -Name "cryptsvc"
    Start-Service -Name "bits"
    Start-Service -Name "wuauserv"
    Start-Service -Name "dosvc"
    Start-Service -Name "usosvc"

    # =============================================================================
    # Final Steps
    # =============================================================================
    Write-Host "Windows Update components have been successfully reset." -ForegroundColor Green
    Write-Host "You can now open Software Center and retry installing updates." -ForegroundColor Green
    Write-Host "Recommendation: Install updates in order from lowest to highest KB number." -ForegroundColor Yellow

    # Create detection/success marker
    $MarkerPath = "C:\Windows\CCM\Logs\Fix-HungWindowsUpdates.done"
    New-Item -Path $MarkerPath -ItemType File -Force | Out-Null

    Stop-Transcript
    exit 0
}
catch {
    Write-Error "An error occurred: $($_.Exception.Message)"
    Stop-Transcript
    exit 1
}
