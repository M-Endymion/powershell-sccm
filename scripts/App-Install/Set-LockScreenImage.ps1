<#
.SYNOPSIS
    Sets a custom Lock Screen image during SCCM OSD or normal deployment.

.DESCRIPTION
    Copies the lock screen image to C:\SCD\LockScreen\ and applies the required
    Group Policy registry settings. Designed for use during Operating System Deployment (OSD).

.NOTES
    Author: M-Endymion
    Version: 1.0
    Last Updated: 2026-05-06
    Requirements:
        - background.jpg (or LockScreen.jpg) must be in the same folder as this script

.EXAMPLE
    .\Set-LockScreenImage.ps1
#>

[CmdletBinding()]
param ()

# =============================================================================
# Configuration
# =============================================================================
$LogPath = "C:\Windows\CCM\Logs\Set-LockScreenImage.log"
$ImageSourceName = "background.jpg"          # Change to "LockScreen.jpg" if you prefer
$DestinationFolder = "C:\SCD\LockScreen"
$DestinationImage = Join-Path $DestinationFolder "LockScreen.jpg"

# =============================================================================
# Logging
# =============================================================================
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting Lock Screen image deployment..." -ForegroundColor Cyan

# =============================================================================
# Main Script
# =============================================================================
try {
    # Ensure source image exists
    $ScriptDir = $PSScriptRoot
    $SourceImage = Join-Path $ScriptDir $ImageSourceName

    if (-not (Test-Path $SourceImage)) {
        Write-Error "Source image not found: $ImageSourceName"
        Write-Host "Please place $ImageSourceName in the same folder as this script." -ForegroundColor Red
        exit 1
    }

    # Create destination folder
    if (-not (Test-Path $DestinationFolder)) {
        New-Item -Path $DestinationFolder -ItemType Directory -Force | Out-Null
        Write-Host "Created folder: $DestinationFolder" -ForegroundColor Green
    }

    # Copy image
    Copy-Item -Path $SourceImage -Destination $DestinationImage -Force
    Write-Host "Lock screen image copied to: $DestinationImage" -ForegroundColor Green

    # Apply Registry Settings
    $RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"

    if (-not (Test-Path $RegPath)) {
        New-Item -Path $RegPath -Force | Out-Null
    }

    Set-ItemProperty -Path $RegPath -Name "LockScreenImage" -Value $DestinationImage -Force
    Write-Host "Registry setting applied successfully." -ForegroundColor Green

    # Force 64-bit registry on 64-bit systems (for safety)
    if ([Environment]::Is64BitOperatingSystem) {
        Write-Host "Applying 64-bit registry view..." -ForegroundColor Gray
        reg import "$ScriptDir\LockScreen.reg" /reg:64 2>$null
    }

    # Success marker for SCCM
    New-Item -Path "C:\Windows\CCM\Logs\LockScreenImage_Set.done" -ItemType File -Force | Out-Null

    Write-Host "Lock Screen image has been successfully set!" -ForegroundColor Green
    Stop-Transcript
    exit 0
}
catch {
    Write-Error "Failed to set lock screen image: $($_.Exception.Message)"
    Stop-Transcript
    exit 1
}
