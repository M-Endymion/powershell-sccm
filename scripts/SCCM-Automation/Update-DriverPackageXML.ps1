<#
.SYNOPSIS
    Exports all Driver Packages from SCCM to an XML file and updates the associated distribution points.

.DESCRIPTION
    This script is designed to run via a Status Filter Rule whenever a Driver Package is updated.
    It exports all driver packages (names starting with "Drivers") to an XML file and refreshes
    the distribution points for the specified package.

.NOTES
    Author:          M-Endymion (Modern PowerShell rewrite)
    Original Author: Matthew Teegarden
    Version:         2.0
    Last Updated:    2026-05-06
    Trigger:         SCCM Status Filter Rule (when Driver Package content changes)

.EXAMPLE
    .\Update-DriverPackageXML.ps1
#>

[CmdletBinding()]
param()

# =============================================================================
# Configuration - Modify these as needed for your environment
# =============================================================================
$LogPath               = "C:\Windows\Temp\Update-DriverPackageXML.log"
$SCCMSiteCode          = "PS1"                                      # Change to your Site Code
$SCCMServerFQDN        = "your-sccm-server.domain.com"             # Change to your SCCM server
$DriverPackageID       = "PS100156"                                 # Package ID to update
$XMLExportPath         = "\\your-sccm-server\CMSource\OSD\Scripts\OSD - Get-DriverPackage\driverpackages.xml"

# =============================================================================
# Logging
# =============================================================================
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting Driver Package XML Update Process..." -ForegroundColor Cyan

# =============================================================================
# Main Script
# =============================================================================
try {
    # Import Configuration Manager Module
    $ModulePath = "$env:SMS_ADMIN_UI_PATH\..\ConfigurationManager.psd1"
    if (-not (Get-Module -Name ConfigurationManager)) {
        Import-Module $ModulePath -Force
        Write-Host "ConfigurationManager module imported." -ForegroundColor Green
    }

    # Connect to SCCM Site
    $SiteDrive = $SCCMSiteCode + ":"
    if (-not (Test-Path $SiteDrive)) {
        New-PSDrive -Name $SCCMSiteCode -PSProvider "AdminUI.PS.Provider\CMSite" -Root $SCCMServerFQDN -Scope Global | Out-Null
    }
    Set-Location $SiteDrive
    Write-Host "Connected to SCCM Site: $SCCMSiteCode" -ForegroundColor Green

    # Export Driver Packages to XML
    Write-Host "Exporting Driver Packages to XML..." -ForegroundColor Yellow
    $DriverPackages = Get-CMPackage | Where-Object { $_.Name -like "Drivers*" } | 
                      Select-Object PackageID, Name, Version, Manufacturer

    $DriverPackages | Export-Clixml -Path $XMLExportPath -Force
    Write-Host "Successfully exported $($DriverPackages.Count) driver packages to XML." -ForegroundColor Green

    # Update Distribution Points for the target package
    Write-Host "Updating Distribution Points for Package ID: $DriverPackageID" -ForegroundColor Yellow
    $Package = Get-CMPackage -ID $DriverPackageID
    if ($Package) {
        Update-CMDistributionPoint -PackageId $DriverPackageID
        Write-Host "Distribution Points updated successfully for package: $($Package.Name)" -ForegroundColor Green
    }
    else {
        Write-Warning "Package ID $DriverPackageID not found."
    }

    Write-Host "Driver Package XML Update completed successfully!" -ForegroundColor Green
    Stop-Transcript
    exit 0
}
catch {
    Write-Error "An error occurred: $($_.Exception.Message)"
    Stop-Transcript
    exit 1
}
