<#
.SYNOPSIS
    Checks and optionally sets the ConfigMgr client cache size.

.DESCRIPTION
    Verifies the current ConfigMgr cache size and can automatically set it to the desired value.
    Useful for startup scripts or scheduled health checks.

.NOTES
    Author:      M-Endymion
    Version:     1.0
    Last Updated:2026-05-06
#>

[CmdletBinding()]
param (
    [switch]$Fix,
    [int]$DesiredCacheSizeMB = 5120   # Default 5 GB
)

# =============================================================================
# Logging
# =============================================================================
$LogPath = "C:\Windows\CCM\Logs\Check-ConfigMgrCache.log"
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting ConfigMgr Cache Health Check..." -ForegroundColor Cyan

# =============================================================================
# Main Logic
# =============================================================================
try {
    $Cache = Get-WmiObject -Namespace root\CCM\SoftMgmtAgent -Class CacheConfig -ErrorAction Stop

    Write-Host "Current ConfigMgr cache size: $($Cache.Size) MB" -ForegroundColor Yellow
    Write-Host "Desired cache size: $DesiredCacheSizeMB MB" -ForegroundColor Yellow

    if ($Cache.Size -ne $DesiredCacheSizeMB) {
        if ($Fix) {
            $Cache.Size = $DesiredCacheSizeMB
            $Cache.Put() | Out-Null
            Write-Host "Cache size successfully updated to $DesiredCacheSizeMB MB" -ForegroundColor Green
        } else {
            Write-Warning "Cache size mismatch. Current: $($Cache.Size) MB | Desired: $DesiredCacheSizeMB MB"
        }
    } else {
        Write-Host "Cache size is already set correctly." -ForegroundColor Green
    }

    # Success marker
    New-Item -Path "C:\Windows\CCM\Logs\ConfigMgrCache_Check.done" -ItemType File -Force | Out-Null

    Write-Host "ConfigMgr Cache check completed." -ForegroundColor Green
}
catch {
    Write-Warning "Could not access ConfigMgr cache settings via WMI. Client may not be fully installed yet."
}

Stop-Transcript
