<#
.SYNOPSIS
    Checks the ConfigMgr client version and can trigger an upgrade if needed.

.DESCRIPTION
    Compares the installed client version against a minimum required version.
    Can automatically trigger a client upgrade if the version is too old.

.NOTES
    Author:      M-Endymion
    Version:     1.0
    Last Updated:2026-05-06
#>

[CmdletBinding()]
param (
    [switch]$Fix,
    [string]$MinimumVersion = "5.00.9088.1000"   # Example: SCCM 1802 baseline
)

# =============================================================================
# Logging
# =============================================================================
$LogPath = "C:\Windows\CCM\Logs\Check-ConfigMgrClientVersion.log"
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting ConfigMgr Client Version Check..." -ForegroundColor Cyan

# =============================================================================
# Main Logic
# =============================================================================
try {
    $ClientVersion = "0.00.0000.0000"

    # Try to get version from WMI
    try {
        $Client = Get-WmiObject -Namespace root\CCM -Class SMS_Client -ErrorAction Stop
        $ClientVersion = $Client.ClientVersion
        Write-Host "Current ConfigMgr client version: $ClientVersion" -ForegroundColor Green
    }
    catch {
        Write-Warning "Could not query client version via WMI. Client may not be installed."
    }

    # Compare versions
    if ([version]$ClientVersion -lt [version]$MinimumVersion) {
        Write-Host "Client version is below minimum ($MinimumVersion)" -ForegroundColor Yellow

        if ($Fix) {
            Write-Host "Triggering client upgrade..." -ForegroundColor Cyan
            Start-Process -FilePath "ccmsetup.exe" -ArgumentList "/upgrade" -NoNewWindow
            Write-Host "Client upgrade initiated." -ForegroundColor Green
        }
    }
    else {
        Write-Host "Client version meets minimum requirement." -ForegroundColor Green
    }

    # Success marker
    New-Item -Path "C:\Windows\CCM\Logs\ClientVersion_Check.done" -ItemType File -Force | Out-Null

    Write-Host "Client Version check completed." -ForegroundColor Green
}
catch {
    Write-Warning "Version check encountered an issue: $($_.Exception.Message)"
}

Stop-Transcript
