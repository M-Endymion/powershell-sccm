<#
.SYNOPSIS
    Resets Windows Update cache and registry settings.

.DESCRIPTION
    Stops Windows Update related services, clears the SoftwareDistribution cache,
    resets problematic registry keys, and restarts services.
    Designed for SCCM/MECM remediation and troubleshooting hung Windows Updates.

.NOTES
    Author: M-Endymion
    Version: 1.0
    Last Updated: 2026-05-06
    Purpose: Enterprise Windows Update reset

.EXAMPLE
    .\Reset-WindowsUpdate.ps1
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param()

# =============================================================================
# Configuration
# =============================================================================
$LogPath = "C:\Windows\CCM\Logs\Reset-WindowsUpdate.log"

# =============================================================================
# Logging
# =============================================================================
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting Windows Update Reset..." -ForegroundColor Cyan

# =============================================================================
# Services
# =============================================================================
$Services = @("wuauserv", "cryptSvc", "bits", "usosvc", "dosvc")

function Stop-WUService {
    param([string]$Name)
    Write-Host "Stopping service: $Name" -ForegroundColor Yellow
    Stop-Service -Name $Name -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}

function Start-WUService {
    param([string]$Name)
    Write-Host "Starting service: $Name" -ForegroundColor Yellow
    Start-Service -Name $Name -ErrorAction SilentlyContinue
}

# =============================================================================
# Main Process
# =============================================================================
try {
    # Stop services
    Write-Host "Phase 1: Stopping Windows Update services..." -ForegroundColor Cyan
    foreach ($svc in $Services) {
        Stop-WUService -Name $svc
    }

    # Clear SoftwareDistribution cache
    Write-Host "Phase 2: Clearing SoftwareDistribution cache..." -ForegroundColor Cyan
    $SDPath = "$env:SystemRoot\SoftwareDistribution"
    if (Test-Path $SDPath) {
        Remove-Item -Path "$SDPath\*" -Recurse -Force -ErrorAction Stop
        Write-Host "SoftwareDistribution cache cleared." -ForegroundColor Green
    }

    # Reset registry keys
    Write-Host "Phase 3: Resetting Windows Update registry settings..." -ForegroundColor Cyan

    # Remove problematic keys
    $KeysToRemove = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\UX\FirstTimeRun",
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\UX\History",
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\UX\Settings"
    )

    foreach ($key in $KeysToRemove) {
        if (Test-Path $key) {
            Remove-Item -Path $key -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "Removed registry key: $key" -ForegroundColor Green
        }
    }

    # Set policy values
    $RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
    $AURegPath = "$RegPath\AU"

    if (-not (Test-Path $RegPath)) { New-Item -Path $RegPath -Force | Out-Null }
    if (-not (Test-Path $AURegPath)) { New-Item -Path $AURegPath -Force | Out-Null }

    Set-ItemProperty -Path $RegPath -Name "SetDisableUXWUAccess" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $AURegPath -Name "UseWUServer" -Value 0 -Type DWord -Force

    Write-Host "Registry settings reset successfully." -ForegroundColor Green

    # Restart services
    Write-Host "Phase 4: Restarting services..." -ForegroundColor Cyan
    foreach ($svc in $Services) {
        Start-WUService -Name $svc
    }

    # Trigger detection
    Write-Host "Triggering Windows Update detection..." -ForegroundColor Cyan
    Start-Process -FilePath "wuauclt.exe" -ArgumentList "/resetauthorization /detectnow" -NoNewWindow -Wait

    # Success marker
    $Marker = "C:\Windows\CCM\Logs\Reset-WindowsUpdate.done"
    New-Item -Path $Marker -ItemType File -Force | Out-Null

    Write-Host "Windows Update reset completed successfully." -ForegroundColor Green
    Stop-Transcript
    exit 0
}
catch {
    Write-Error "Error during Windows Update reset: $($_.Exception.Message)"
    Stop-Transcript
    exit 1
}
