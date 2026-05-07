<#
.SYNOPSIS
    Copies a file (usually a shortcut) to all user desktops and the Default user desktop.

.DESCRIPTION
    Useful during OSD or post-deployment to place shortcuts on every user's desktop.
    Skips special folders like Public and Default User.

.NOTES
    Author:      M-Endymion
    Version:     1.0
    Last Updated:2026-05-06

.EXAMPLE
    .\Copy-ToAllUsersDesktops.ps1 -SourceFile ".\CompanyPortal.lnk"
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$SourceFile
)

# =============================================================================
# Configuration
# =============================================================================
$LogPath = "C:\Windows\CCM\Logs\Copy-ToAllUsersDesktops.log"

# =============================================================================
# Logging
# =============================================================================
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting copy to all user desktops..." -ForegroundColor Cyan

# =============================================================================
# Main Script
# =============================================================================
try {
    if (-not (Test-Path $SourceFile)) {
        Write-Error "Source file not found: $SourceFile"
        exit 1
    }

    $FileName = Split-Path $SourceFile -Leaf
    $UsersRoot = "C:\Users"

    Write-Host "Copying '$FileName' to all user desktops..." -ForegroundColor Yellow

    # Get all user profiles
    $UserFolders = Get-ChildItem -Path $UsersRoot -Directory | Where-Object { 
        $_.Name -notin @("Public", "Default", "Default User", "All Users") 
    }

    $SuccessCount = 0

    foreach ($User in $UserFolders) {
        $DesktopPath = Join-Path $User.FullName "Desktop"

        if (Test-Path $DesktopPath) {
            try {
                Copy-Item -Path $SourceFile -Destination $DesktopPath -Force -ErrorAction Stop
                Write-Host "   Copied to: $($User.Name)\Desktop" -ForegroundColor Green
                $SuccessCount++
            }
            catch {
                Write-Warning "Failed to copy to $($User.Name): $($_.Exception.Message)"
            }
        }
    }

    # Also copy to Default user desktop (for new profiles)
    $DefaultDesktop = "C:\Users\Default\Desktop"
    if (Test-Path $DefaultDesktop) {
        Copy-Item -Path $SourceFile -Destination $DefaultDesktop -Force
        Write-Host "   Copied to Default\Desktop" -ForegroundColor Green
    }

    # Success marker
    New-Item -Path "C:\Windows\CCM\Logs\Copy-ToAllUsersDesktops.done" -ItemType File -Force | Out-Null

    Write-Host "Successfully copied file to $SuccessCount user desktops." -ForegroundColor Green
    Stop-Transcript
    exit 0
}
catch {
    Write-Error "Critical error: $($_.Exception.Message)"
    Stop-Transcript
    exit 1
}
