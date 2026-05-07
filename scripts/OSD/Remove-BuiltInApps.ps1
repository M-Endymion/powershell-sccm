<#
.SYNOPSIS
    Removes built-in Windows apps and capabilities during OSD.

.DESCRIPTION
    Reads apps and capabilities from text files (apps<BuildNumber>.txt and Capabilities<BuildNumber>.txt)
    and removes them. Designed for use in SCCM/MECM Task Sequences.

.NOTES
    Author:          M-Endymion (Modern PowerShell version)
    Original Author: Michael Niehaus (supportmodern/Scripts)
    Version:         2.0
    Last Updated:    2026-05-06

.EXAMPLE
    .\Remove-BuiltInApps.ps1
#>

[CmdletBinding()]
param()

# =============================================================================
# Configuration
# =============================================================================
$BuildNumber = (Get-CimInstance Win32_OperatingSystem).BuildNumber
$LogPath     = "$env:SystemRoot\Temp\Remove-BuiltInApps_$BuildNumber.log"
$AppListPath = Join-Path $PSScriptRoot "apps$BuildNumber.txt"
$CapListPath = Join-Path $PSScriptRoot "Capabilities$BuildNumber.txt"

# =============================================================================
# Logging
# =============================================================================
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting removal of built-in apps for build $BuildNumber..." -ForegroundColor Cyan

# =============================================================================
# Helper Function
# =============================================================================
function Write-RemoveLog {
    param([string]$Message)
    "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $Message" | Out-File -FilePath $LogPath -Append
    Write-Host $Message
}

# =============================================================================
# Main Script
# =============================================================================
try {
    # Read app lists
    if (Test-Path $AppListPath) {
        $AppsToRemove = Get-Content $AppListPath | Where-Object { $_ -notmatch '^\s*$|^#' } | ForEach-Object { $_.Trim() }
        Write-RemoveLog "Loaded $($AppsToRemove.Count) apps to remove from $AppListPath"
    } else {
        Write-Warning "App list not found: $AppListPath"
        $AppsToRemove = @()
    }

    if (Test-Path $CapListPath) {
        $CapabilitiesToRemove = Get-Content $CapListPath | Where-Object { $_ -notmatch '^\s*$|^#' } | ForEach-Object { $_.Trim() }
        Write-RemoveLog "Loaded $($CapabilitiesToRemove.Count) capabilities to remove from $CapListPath"
    } else {
        $CapabilitiesToRemove = @()
    }

    # Remove Appx Packages
    foreach ($App in $AppsToRemove) {
        $Package = Get-AppxPackage -Name $App -AllUsers -ErrorAction SilentlyContinue
        $Provisioned = Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -eq $App }

        if ($Package) {
            Write-RemoveLog "Removing installed package: $App"
            $Package | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue | Out-Null
        }

        if ($Provisioned) {
            Write-RemoveLog "Removing provisioned package: $($Provisioned.PackageName)"
            Remove-AppxProvisionedPackage -Online -PackageName $Provisioned.PackageName -ErrorAction SilentlyContinue | Out-Null
        }
    }

    # Remove Windows Capabilities
    foreach ($Cap in $CapabilitiesToRemove) {
        Write-RemoveLog "Removing capability: $Cap"
        Remove-WindowsCapability -Online -Name $Cap -ErrorAction SilentlyContinue | Out-Null
    }

    # Success marker
    New-Item -Path "C:\Windows\CCM\Logs\Remove-BuiltInApps.done" -ItemType File -Force | Out-Null

    Write-Host "Built-in apps and capabilities removal completed successfully." -ForegroundColor Green
    Stop-Transcript
    exit 0
}
catch {
    Write-Error "An error occurred: $($_.Exception.Message)"
    Stop-Transcript
    exit 1
}
