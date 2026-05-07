<#
.SYNOPSIS
    Performs a full repair of the ConfigMgr client.

.DESCRIPTION
    Runs multiple repair actions: services, cache, assignment, hotfixes, etc.
    Useful when the client is in a broken state.

.NOTES
    Author:      M-Endymion
    Version:     1.0
    Last Updated:2026-05-06
#>

[CmdletBinding()]
param (
    [switch]$FullRepair
)

# =============================================================================
# Logging
# =============================================================================
$LogPath = "C:\Windows\CCM\Logs\Repair-ConfigMgrClient.log"
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting ConfigMgr Client Repair..." -ForegroundColor Cyan

# =============================================================================
# Repair Sequence
# =============================================================================

Write-Host "`n1. Restarting critical services..." -ForegroundColor Cyan
& "$PSScriptRoot\Check-ConfigMgrServices.ps1" -Fix

Write-Host "`n2. Checking and fixing cache size..." -ForegroundColor Cyan
& "$PSScriptRoot\Check-ConfigMgrCache.ps1" -Fix -DesiredCacheSizeMB 5120

Write-Host "`n3. Checking client assignment..." -ForegroundColor Cyan
& "$PSScriptRoot\Check-ClientAssignment.ps1" -Fix

Write-Host "`n4. Installing pending hotfixes..." -ForegroundColor Cyan
& "$PSScriptRoot\Install-ConfigMgrHotfixes.ps1" -Fix

Write-Host "`n5. Final service restart..." -ForegroundColor Cyan
Restart-Service -Name "CCMExec" -Force -ErrorAction SilentlyContinue

# Success marker
New-Item -Path "C:\Windows\CCM\Logs\ConfigMgrClient_Repaired.done" -ItemType File -Force | Out-Null

Write-Host "`nConfigMgr Client Repair completed." -ForegroundColor Green
Stop-Transcript
