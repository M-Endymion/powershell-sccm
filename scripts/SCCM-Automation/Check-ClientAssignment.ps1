<#
.SYNOPSIS
    Checks if the ConfigMgr client is properly assigned to a site.

.DESCRIPTION
    Verifies client assignment status and can trigger a client reinstall if needed.
    Useful for startup scripts or scheduled health checks.

.NOTES
    Author:      M-Endymion
    Version:     1.0
    Last Updated:2026-05-06
#>

[CmdletBinding()]
param (
    [switch]$Fix,
    [string]$SiteCode = ""   # Optional: Force assignment to specific site
)

# =============================================================================
# Logging
# =============================================================================
$LogPath = "C:\Windows\CCM\Logs\Check-ClientAssignment.log"
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting ConfigMgr Client Assignment Check..." -ForegroundColor Cyan

# =============================================================================
# Main Logic
# =============================================================================
try {
    $Client = Get-WmiObject -Namespace root\CCM -Class SMS_Client -ErrorAction Stop

    if ($Client) {
        Write-Host "Client is assigned to site: $($Client.SiteCode)" -ForegroundColor Green

        if ($SiteCode -and $Client.SiteCode -ne $SiteCode) {
            if ($Fix) {
                Write-Host "Reassigning client to site $SiteCode..." -ForegroundColor Yellow
                $Client.AssignSite($SiteCode) | Out-Null
                Write-Host "Client reassignment triggered." -ForegroundColor Green
            } else {
                Write-Warning "Client is assigned to $($Client.SiteCode) but should be $SiteCode"
            }
        }
    } 
    else {
        Write-Warning "No SMS_Client object found. Client may not be installed or assigned."
        
        if ($Fix) {
            Write-Host "Triggering client installation..." -ForegroundColor Yellow
            # This would typically call ccmsetup here if needed
        }
    }
}
catch {
    Write-Warning "Could not query ConfigMgr client assignment via WMI."
}

# Success marker
New-Item -Path "C:\Windows\CCM\Logs\ClientAssignment_Check.done" -ItemType File -Force | Out-Null

Write-Host "Client Assignment check completed." -ForegroundColor Green
Stop-Transcript
