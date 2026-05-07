<#
.SYNOPSIS
    Exports lists of installed Appx apps and Windows Capabilities for use with Remove-BuiltInApps.ps1.

.DESCRIPTION
    Automatically creates two clean text files:
      - apps<BuildNumber>.txt
      - Capabilities<BuildNumber>.txt
    
    These files can then be edited and used by Remove-BuiltInApps.ps1 during OSD.

.NOTES
    Author: M-Endymion
    Version: 1.0
    Last Updated: 2026-05-06
    Purpose: Support script for Remove-BuiltInApps.ps1

.EXAMPLE
    .\Export-BuiltInAppsList.ps1
#>

[CmdletBinding()]
param()

# =============================================================================
# Configuration
# =============================================================================
$BuildNumber = (Get-CimInstance Win32_OperatingSystem).BuildNumber
$ScriptDir   = $PSScriptRoot
$LogPath     = "$env:SystemRoot\Temp\Export-BuiltInAppsList.log"

# Output files will be saved next to this script
$AppsFile        = Join-Path $ScriptDir "apps$BuildNumber.txt"
$CapabilitiesFile = Join-Path $ScriptDir "Capabilities$BuildNumber.txt"

# =============================================================================
# Logging
# =============================================================================
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Exporting built-in apps and capabilities for Build $BuildNumber..." -ForegroundColor Cyan

# =============================================================================
# Main Script
# =============================================================================
try {
    # === Export Appx Packages ===
    Write-Host "Exporting installed Appx Packages..." -ForegroundColor Yellow
    
    $AppxList = Get-AppxPackage -AllUsers | 
                Where-Object { $_.NonRemovable -eq $false } | 
                Select-Object -ExpandProperty Name | 
                Sort-Object

    $AppxList | Out-File -FilePath $AppsFile -Encoding UTF8
    Write-Host "Created $($AppxList.Count) app entries → $AppsFile" -ForegroundColor Green

    # === Export Windows Capabilities ===
    Write-Host "Exporting Windows Capabilities..." -ForegroundColor Yellow
    
    $CapList = Get-WindowsCapability -Online | 
               Where-Object { $_.State -eq "Installed" } | 
               Select-Object -ExpandProperty Name | 
               Sort-Object

    $CapList | Out-File -FilePath $CapabilitiesFile -Encoding UTF8
    Write-Host "Created $($CapList.Count) capability entries → $CapabilitiesFile" -ForegroundColor Green

    # Success marker
    New-Item -Path "C:\Windows\CCM\Logs\Export-BuiltInAppsList.done" -ItemType File -Force | Out-Null

    Write-Host "`nExport completed successfully!" -ForegroundColor Green
    Write-Host "You can now edit the two files and use them with Remove-BuiltInApps.ps1" -ForegroundColor Cyan

    Stop-Transcript
    exit 0
}
catch {
    Write-Error "An error occurred: $($_.Exception.Message)"
    Stop-Transcript
    exit 1
}
