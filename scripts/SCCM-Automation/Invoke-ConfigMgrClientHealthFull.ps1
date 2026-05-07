<#
.SYNOPSIS
    Full ConfigMgr Client Health Orchestrator.

.DESCRIPTION
    Runs a comprehensive set of client health checks and fixes.
    Modern replacement for the core logic in ConfigMgrStartup.vbs.

.NOTES
    Author:      M-Endymion
    Version:     1.0
    Last Updated:2026-05-06
#>

[CmdletBinding()]
param (
    [switch]$FullRepair,           # Run all possible fixes
    [string]$LocalAdminAccounts = "",
    [int]$CacheSizeMB = 5120,
    [string]$HotfixFolder = "C:\ConfigMgrHotfixes"
)

# =============================================================================
# Logging
# =============================================================================
$LogPath = "C:\Windows\CCM\Logs\ConfigMgrClientHealthFull.log"
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting Full ConfigMgr Client Health Check..." -ForegroundColor Cyan

# =============================================================================
# Run Health Checks
# =============================================================================

Write-Host "`n=== 1. Service Checks ===" -ForegroundColor Cyan
& "$PSScriptRoot\Check-ConfigMgrServices.ps1" -Fix

Write-Host "`n=== 2. Cache Size Check ===" -ForegroundColor Cyan
& "$PSScriptRoot\Check-ConfigMgrCache.ps1" -Fix -DesiredCacheSizeMB $CacheSizeMB

Write-Host "`n=== 3. Local Admin Membership ===" -ForegroundColor Cyan
& "$PSScriptRoot\Check-LocalAdminMembership.ps1" -Fix -Accounts $LocalAdminAccounts

Write-Host "`n=== 4. Client Assignment Check ===" -ForegroundColor Cyan
& "$PSScriptRoot\Check-ClientAssignment.ps1" -Fix

Write-Host "`n=== 5. Client Version Check ===" -ForegroundColor Cyan
& "$PSScriptRoot\Check-ConfigMgrClientVersion.ps1" -Fix

Write-Host "`n=== 6. Hotfix Installation ===" -ForegroundColor Cyan
& "$PSScriptRoot\Install-ConfigMgrHotfixes.ps1" -Fix -HotfixFolder $HotfixFolder

# =============================================================================
# Final Cleanup & Restart
# =============================================================================
Write-Host "`n=== Final Step: Restarting CCMExec Service ===" -ForegroundColor Cyan
Restart-Service -Name "CCMExec" -Force -ErrorAction SilentlyContinue

# Success marker
New-Item -Path "C:\Windows\CCM\Logs\ConfigMgrClientHealth_FullCheck.done" -ItemType File -Force | Out-Null

Write-Host "`nFull ConfigMgr Client Health Check completed successfully." -ForegroundColor Green
Stop-Transcript
