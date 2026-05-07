<#
.SYNOPSIS
    Installs 7-Zip (latest provided version) - automatically detects 64-bit or 32-bit OS.

.DESCRIPTION
    Uses the appropriate MSI (7z2409-x64.msi or 7z2409.msi) based on system architecture.
    Designed for SCCM / MECM deployment with proper logging and detection marker.

.NOTES
    Author: M-Endymion
    Version: 1.0
    Last Updated: 2026-05-06
    Requirements:
        - 7z2409-x64.msi and/or 7z2409.msi must be in the same folder as this script
        - Administrative privileges required

.EXAMPLE
    .\Install-7Zip.ps1
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param()

# =============================================================================
# Configuration
# =============================================================================
$LogPath = "C:\Windows\CCM\Logs\Install-7Zip.log"
$DetectionMarker = "C:\Windows\CCM\Logs\Install-7Zip.done"

# =============================================================================
# Logging
# =============================================================================
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting 7-Zip installation..." -ForegroundColor Cyan

# =============================================================================
# Detect Architecture and Choose MSI
# =============================================================================
$Is64Bit = [Environment]::Is64BitOperatingSystem

if ($Is64Bit) {
    $MSIName = "7z2409-x64.msi"
    $Architecture = "64-bit"
} else {
    $MSIName = "7z2409.msi"
    $Architecture = "32-bit"
}

Write-Host "Detected $Architecture operating system. Using installer: $MSIName" -ForegroundColor Yellow

# =============================================================================
# Main Installation
# =============================================================================
try {
    $ScriptDir = $PSScriptRoot
    $MSIPath = Join-Path -Path $ScriptDir -ChildPath $MSIName

    if (-not (Test-Path $MSIPath)) {
        Write-Error "MSI file not found: $MSIName"
        Write-Host "Please place $MSIName in the same folder as this script." -ForegroundColor Red
        exit 1
    }

    Write-Host "Found installer: $MSIName" -ForegroundColor Green

    if ($PSCmdlet.ShouldProcess("7-Zip ($Architecture)", "Install")) {
        Write-Host "Installing 7-Zip silently..." -ForegroundColor Yellow

        $Arguments = "/i `"$MSIPath`" /quiet /norestart /L*V `"$env:windir\Temp\7Zip_Install.log`""

        $Process = Start-Process -FilePath "msiexec.exe" `
                                 -ArgumentList $Arguments `
                                 -Wait `
                                 -PassThru `
                                 -NoNewWindow

        if ($Process.ExitCode -eq 0 -or $Process.ExitCode -eq 3010) {
            Write-Host "7-Zip installed successfully." -ForegroundColor Green
            if ($Process.ExitCode -eq 3010) {
                Write-Host "A restart is recommended to complete installation." -ForegroundColor Yellow
            }
        }
        else {
            Write-Warning "Installation completed with exit code: $($Process.ExitCode)"
        }
    }

    # =============================================================================
    # Detection Marker for SCCM/MECM
    # =============================================================================
    New-Item -Path $DetectionMarker -ItemType File -Force | Out-Null
    Write-Host "Detection marker created successfully." -ForegroundColor Green

    Write-Host "7-Zip installation process completed." -ForegroundColor Cyan
    Stop-Transcript
    exit 0
}
catch {
    Write-Error "Failed to install 7-Zip: $($_.Exception.Message)"
    Stop-Transcript
    exit 1
}
