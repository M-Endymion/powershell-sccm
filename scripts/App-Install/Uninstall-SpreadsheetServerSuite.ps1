<#
.SYNOPSIS
    Uninstalls Spreadsheet Server Suite (insightsoftware) silently.

.DESCRIPTION
    Performs a silent uninstall of Spreadsheet Server Suite using the official installer
    in uninstall mode. Closes Excel beforehand (required), provides logging, and creates
    a detection marker for SCCM/MECM.

.NOTES
    Author: M-Endymion
    Version: 1.0
    Last Updated: 2026-05-06
    Requirements:
        - Spreadsheet Server Suite.exe must be in the same folder as this script
        - Administrative privileges
        - Excel must be closed before running

.EXAMPLE
    .\Uninstall-SpreadsheetServerSuite.ps1
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param()

# =============================================================================
# Configuration
# =============================================================================
$LogPath = "C:\Windows\CCM\Logs\Uninstall-SpreadsheetServerSuite.log"
$InstallerName = "Spreadsheet Server Suite.exe"
$UninstallLog = "$env:windir\Temp\SpreadsheetServer_Uninstall.log"

# =============================================================================
# Logging
# =============================================================================
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting Spreadsheet Server Suite uninstallation..." -ForegroundColor Cyan

# =============================================================================
# Main Script
# =============================================================================
try {
    # Check for running Excel (critical)
    $ExcelProcesses = Get-Process -Name "excel" -ErrorAction SilentlyContinue
    if ($ExcelProcesses) {
        Write-Warning "Excel is running. Please close all Excel instances before continuing."
        Write-Error "Excel processes detected. Uninstall cannot proceed safely."
        exit 1
    }

    # Locate installer
    $ScriptDir = $PSScriptRoot
    $InstallerPath = Join-Path -Path $ScriptDir -ChildPath $InstallerName

    if (-not (Test-Path $InstallerPath)) {
        Write-Error "Installer not found: $InstallerName"
        exit 1
    }

    Write-Host "Found uninstaller: $InstallerName" -ForegroundColor Green

    # Uninstall arguments
    $Arguments = "/s /u /l*v `"$UninstallLog`""

    if ($PSCmdlet.ShouldProcess("Spreadsheet Server Suite", "Uninstall")) {
        Write-Host "Running silent uninstall..." -ForegroundColor Yellow

        $Process = Start-Process -FilePath $InstallerPath `
                                 -ArgumentList $Arguments `
                                 -Wait `
                                 -NoNewWindow `
                                 -PassThru

        Write-Host "Uninstaller exited with code: $($Process.ExitCode)" -ForegroundColor Cyan
    }

    # Success marker for SCCM/MECM
    $Marker = "C:\Windows\CCM\Logs\Uninstall-SpreadsheetServerSuite.done"
    New-Item -Path $Marker -ItemType File -Force | Out-Null

    Write-Host "Spreadsheet Server Suite uninstallation completed." -ForegroundColor Green
    Write-Host "A system reboot is recommended." -ForegroundColor Yellow

    Stop-Transcript
    exit 0
}
catch {
    Write-Error "Uninstallation failed: $($_.Exception.Message)"
    Stop-Transcript
    exit 1
}
