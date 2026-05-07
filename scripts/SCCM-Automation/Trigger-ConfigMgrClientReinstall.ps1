<#
.SYNOPSIS
    Triggers a full ConfigMgr client reinstall.

.DESCRIPTION
    Stops services, uninstalls the current client, and triggers a fresh installation.
    Use as a last resort when other repair methods fail.

.NOTES
    Author:      M-Endymion
    Version:     1.0
    Last Updated:2026-05-06
#>

[CmdletBinding()]
param (
    [string]$SiteCode = "PS1",                    # Change to your site code
    [string]$ManagementPoint = "",                # e.g. "sccm-mp.contoso.com"
    [int]$CacheSizeMB = 5120
)

# =============================================================================
# Logging
# =============================================================================
$LogPath = "C:\Windows\CCM\Logs\Trigger-ConfigMgrClientReinstall.log"
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting ConfigMgr Client Reinstall..." -ForegroundColor Cyan

# =============================================================================
# Main Logic
# =============================================================================
try {
    Write-Host "Stopping ConfigMgr services..." -ForegroundColor Yellow
    Stop-Service -Name "CCMExec" -Force -ErrorAction SilentlyContinue
    Stop-Service -Name "ccmsetup" -Force -ErrorAction SilentlyContinue

    Write-Host "Uninstalling existing ConfigMgr client..." -ForegroundColor Yellow
    Start-Process -FilePath "ccmsetup.exe" -ArgumentList "/uninstall" -Wait -NoNewWindow

    # Wait for uninstall to complete
    Start-Sleep -Seconds 45

    # Build ccmsetup command line
    $CommandLine = "/mp:$ManagementPoint /sitecode:$SiteCode SMSCACHESIZE=$CacheSizeMB /forceinstall"

    Write-Host "Triggering fresh client installation..." -ForegroundColor Cyan
    Write-Host "Command: ccmsetup.exe $CommandLine" -ForegroundColor Gray

    Start-Process -FilePath "ccmsetup.exe" -ArgumentList $CommandLine -NoNewWindow

    # Success marker
    New-Item -Path "C:\Windows\CCM\Logs\ConfigMgrClient_ReinstallTriggered.done" -ItemType File -Force | Out-Null

    Write-Host "Client reinstall has been triggered successfully." -ForegroundColor Green
}
catch {
    Write-Error "Failed to trigger client reinstall: $($_.Exception.Message)"
}

Stop-Transcript
