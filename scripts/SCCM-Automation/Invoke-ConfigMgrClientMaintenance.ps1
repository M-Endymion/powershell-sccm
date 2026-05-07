<#
.SYNOPSIS
    Main orchestrator for ConfigMgr Client Health and Maintenance.

.DESCRIPTION
    Runs multiple client health checks and fixes in sequence.
    Modern replacement for the core logic in the old ConfigMgrStartup.vbs.

.NOTES
    Author:      M-Endymion
    Version:     1.0
    Last Updated:2026-05-06
#>

[CmdletBinding()]
param (
    [switch]$FullFix,           # Perform all possible fixes
    [switch]$Services,
    [switch]$Cache,
    [switch]$LocalAdmin,
    [switch]$Assignment,
    [switch]$Hotfixes,
    [string]$LocalAdminAccounts = "",
    [int]$CacheSizeMB = 5120,
    [string]$HotfixFolder = "C:\ConfigMgrHotfixes"
)

# =============================================================================
# Logging
# =============================================================================
$LogPath = "C:\Windows\CCM\Logs\ConfigMgrClientMaintenance.log"
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting ConfigMgr Client Maintenance Orchestrator..." -ForegroundColor Cyan

# =============================================================================
# Run Selected Checks
# =============================================================================
if ($FullFix -or $Services) {
    Write-Host "`n=== Running Service Checks ===" -ForegroundColor Cyan
    & "$PSScriptRoot\Check-ConfigMgrServices.ps1" -Fix
}

if ($FullFix -or $Cache) {
    Write-Host "`n=== Running Cache Check ===" -ForegroundColor Cyan
    & "$PSScriptRoot\Check-ConfigMgrCache.ps1" -Fix -DesiredCacheSizeMB $CacheSizeMB
}

if ($FullFix -or $LocalAdmin) {
    Write-Host "`n=== Running Local Admin Check ===" -ForegroundColor Cyan
    & "$PSScriptRoot\Check-LocalAdminMembership.ps1" -Fix -Accounts $LocalAdminAccounts
}

if ($FullFix -or $Assignment) {
    Write-Host "`n=== Running Client Assignment Check ===" -ForegroundColor Cyan
    & "$PSScriptRoot\Check-ClientAssignment.ps1" -Fix
}

if ($FullFix -or $Hotfixes) {
    Write-Host "`n=== Running Hotfix Installation ===" -ForegroundColor Cyan
    & "$PSScriptRoot\Install-ConfigMgrHotfixes.ps1" -Fix -HotfixFolder $HotfixFolder
}

Write-Host "`nConfigMgr Client Maintenance completed." -ForegroundColor Green

# Success marker
New-Item -Path "C:\Windows\CCM\Logs\ConfigMgrMaintenance_Completed.done" -ItemType File -Force | Out-Null

Stop-Transcript
