<#
.SYNOPSIS
    Performs a full repair / reinstall of the ConfigMgr client.

.DESCRIPTION
    Last resort repair script. Stops services, removes client, and triggers a fresh install.
    Use with caution.

.NOTES
    Author:      M-Endymion
    Version:     1.0
    Last Updated:2026-05-06
#>

[CmdletBinding()]
param (
    [switch]$ForceReinstall
)

# =============================================================================
# Logging
# =============================================================================
$LogPath = "C:\Windows\CCM\Logs\Repair-ConfigMgrClientFull.log"
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting Full ConfigMgr Client Repair..." -ForegroundColor Cyan

# =============================================================================
# Main Logic
# =============================================================================
try {
    Write-Host "Stopping ConfigMgr services..." -ForegroundColor Yellow
    Stop-Service -Name "CCMExec" -Force -ErrorAction SilentlyContinue
    Stop-Service -Name "ccmsetup" -Force -ErrorAction SilentlyContinue

    Write-Host "Removing ConfigMgr client..." -ForegroundColor Yellow
    Start-Process -FilePath "ccmsetup.exe" -ArgumentList "/uninstall" -Wait -NoNewWindow

    # Wait a bit
    Start-Sleep -Seconds 30

    if ($ForceReinstall) {
        Write-Host "Triggering full client reinstall..." -ForegroundColor Cyan
        # Adjust site code and parameters as needed
        Start-Process -FilePath "ccmsetup.exe" -ArgumentList "/mp:https://your-sccm-server.domain.com /sitecode=PS1 SMSCACHESIZE=5120" -Wait -NoNewWindow
        Write-Host "Client reinstall initiated." -ForegroundColor Green
    }

    # Success marker
    New-Item -Path "C:\Windows\CCM\Logs\ConfigMgrClient_FullRepair.done" -ItemType File -Force | Out-Null

    Write-Host "Full ConfigMgr Client Repair completed." -ForegroundColor Green
}
catch {
    Write-Error "Full repair failed: $($_.Exception.Message)"
}

Stop-Transcript
