<#
.SYNOPSIS
    Installs Windows Update KB5003791 (x64) silently.

.DESCRIPTION
    Installs the MSU package for KB5003791 using wusa.exe with quiet and norestart flags.
    Designed for SCCM / MECM deployment.

.NOTES
    Author: M-Endymion
    Version: 1.0
    Purpose: Windows Update installation
    Last Updated: 2026-05-06

.EXAMPLE
    .\Install-KB5003791.ps1
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param()

# =============================================================================
# Configuration
# =============================================================================
$UpdateName = "KB5003791"
$MSUFileName = "windows10.0-kb5003791-x64_6c4ec017d710917b394a39f925a0149668db4e83.msu"
$LogPath = "C:\Windows\CCM\Logs\Install-$UpdateName.log"

# =============================================================================
# Logging
# =============================================================================
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting installation of $UpdateName..." -ForegroundColor Cyan

# =============================================================================
# Main Script
# =============================================================================
try {
    # Get the script's directory
    $ScriptDir = $PSScriptRoot
    $MSUPath = Join-Path -Path $ScriptDir -ChildPath $MSUFileName

    # Check if MSU file exists
    if (-not (Test-Path $MSUPath)) {
        Write-Error "MSU file not found: $MSUFileName"
        Write-Host "Expected location: $MSUPath" -ForegroundColor Red
        Stop-Transcript
        exit 1
    }

    Write-Host "Found update file: $MSUFileName" -ForegroundColor Green
    Write-Host "Installing $UpdateName silently (no restart)..." -ForegroundColor Yellow

    if ($PSCmdlet.ShouldProcess($UpdateName, "Install MSU")) {
        $Arguments = "`"$MSUPath`" /quiet /norestart"

        $Result = Start-Process -FilePath "wusa.exe" `
                                -ArgumentList $Arguments `
                                -Wait `
                                -PassThru `
                                -ErrorAction Stop

        if ($Result.ExitCode -eq 0 -or $Result.ExitCode -eq 3010) {
            Write-Host "$UpdateName installed successfully." -ForegroundColor Green
            if ($Result.ExitCode -eq 3010) {
                Write-Host "A restart is required to complete installation." -ForegroundColor Yellow
            }
        }
        else {
            Write-Warning "$UpdateName installation completed with exit code: $($Result.ExitCode)"
        }
    }

    # Create detection marker for SCCM/MECM
    $DetectionMarker = "C:\Windows\CCM\Logs\$UpdateName-Installed.done"
    New-Item -Path $DetectionMarker -ItemType File -Force | Out-Null
    Write-Host "Detection marker created." -ForegroundColor Green

    Write-Host "$UpdateName installation process completed." -ForegroundColor Cyan
    Stop-Transcript
    exit 0
}
catch {
    Write-Error "Failed to install $UpdateName : $($_.Exception.Message)"
    Stop-Transcript
    exit 1
}
