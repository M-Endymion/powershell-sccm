<#
.SYNOPSIS
    Copies CMTrace.exe to system32 and sets it as the default viewer for .log files.

.DESCRIPTION
    This script replaces the old Copy_CMTrace.bat + Set_CMtrace_Default_Log_Viewer.bat.
    It copies CMTrace.exe and registers it as the default log file viewer.

.NOTES
    Author: M-Endymion (Modern PowerShell version)
    Original Author: Eswar Koneti (www.eskonr.com) - 2014
    Version: 1.0
    Last Updated: 2026-05-06
    Context: Best used during SCCM/MECM OSD Task Sequences

.EXAMPLE
    .\Set-CMTraceAsDefaultLogViewer.ps1
#>

[CmdletBinding()]
param()

# =============================================================================
# Configuration
# =============================================================================
$LogPath = "C:\Windows\CCM\Logs\Set-CMTraceAsDefault.log"
$CMTraceSourceName = "CMTrace.exe"
$DestinationPath = "$env:windir\system32\CMTrace.exe"

# =============================================================================
# Logging
# =============================================================================
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting CMTrace default log viewer setup..." -ForegroundColor Cyan

# =============================================================================
# Main Script
# =============================================================================
try {
    # Locate CMTrace.exe in script directory
    $ScriptDir = $PSScriptRoot
    $SourceFile = Join-Path -Path $ScriptDir -ChildPath $CMTraceSourceName

    if (-not (Test-Path $SourceFile)) {
        Write-Error "CMTrace.exe not found in script directory."
        Write-Host "Please include CMTrace.exe in the same folder/package as this script." -ForegroundColor Red
        exit 1
    }

    # Copy CMTrace.exe
    Write-Host "Copying CMTrace.exe to $DestinationPath" -ForegroundColor Yellow
    Copy-Item -Path $SourceFile -Destination $DestinationPath -Force
    Write-Host "CMTrace.exe copied successfully." -ForegroundColor Green

    # Set as default .log viewer
    Write-Host "Setting CMTrace as default viewer for .log files..." -ForegroundColor Yellow

    # Register .log file type
    reg add "HKCU\Software\Classes\.log" /ve /d "Log.File" /f | Out-Null
    reg add "HKCU\Software\Classes\.lo_" /ve /d "Log.File" /f | Out-Null

    # Set open command
    reg add "HKCU\Software\Classes\Log.File\shell\open\command" /ve /d "\"$DestinationPath\" \"%1\"" /f | Out-Null

    # Disable Trace32 registration prompt
    reg add "HKCU\SOFTWARE\Microsoft\Trace32" /v "Register File Types" /d "0" /f | Out-Null

    # Success marker
    New-Item -Path "C:\Windows\CCM\Logs\CMTrace_Default_Set.done" -ItemType File -Force | Out-Null

    Write-Host "CMTrace has been successfully set as the default .log viewer!" -ForegroundColor Green
    Stop-Transcript
    exit 0
}
catch {
    Write-Error "Failed to configure CMTrace: $($_.Exception.Message)"
    Stop-Transcript
    exit 1
}
