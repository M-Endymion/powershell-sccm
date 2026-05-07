<#
.SYNOPSIS
    Performs common ConfigMgr Client health checks and remediation.

.DESCRIPTION
    Modern replacement for parts of ConfigMgrStartup.vbs.
    Checks services, registry, local admin membership, cache size, etc.

.NOTES
    Author:      M-Endymion
    Version:     1.0
    Last Updated:2026-05-06
#>

[CmdletBinding()]
param (
    [switch]$FixServices,
    [switch]$FixLocalAdmin,
    [switch]$FixCacheSize,
    [int]$CacheSizeMB = 5120,
    [string]$LocalAdminAccounts = ""
)

# =============================================================================
# Logging
# =============================================================================
$LogPath = "C:\Windows\CCM\Logs\ConfigMgrClientHealth.log"
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting ConfigMgr Client Health Check..." -ForegroundColor Cyan

# =============================================================================
# Helper Functions
# =============================================================================
function Write-HealthLog {
    param([string]$Message, [string]$Color = "White")
    "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $Message" | Out-File -FilePath $LogPath -Append
    Write-Host $Message -ForegroundColor $Color
}

# =============================================================================
# Service Checks & Fixes
# =============================================================================
if ($FixServices) {
    Write-HealthLog "Checking critical ConfigMgr services..." -Color Cyan

    $Services = @{
        "CCMExec" = @{StartMode="Automatic"; State="Running"}
        "winmgmt" = @{StartMode="Automatic"; State="Running"}
    }

    foreach ($svc in $Services.Keys) {
        $Service = Get-Service -Name $svc -ErrorAction SilentlyContinue
        if ($Service) {
            if ($Service.StartMode -ne $Services[$svc].StartMode) {
                Set-Service -Name $svc -StartupType $Services[$svc].StartMode
                Write-HealthLog "Set $svc start mode to $($Services[$svc].StartMode)" -Color Green
            }
            if ($Service.Status -ne $Services[$svc].State) {
                if ($Services[$svc].State -eq "Running") {
                    Start-Service -Name $svc
                    Write-HealthLog "Started service: $svc" -Color Green
                }
            }
        }
    }
}

# =============================================================================
# Local Admin Group Check
# =============================================================================
if ($FixLocalAdmin -and $LocalAdminAccounts) {
    Write-HealthLog "Checking Local Administrators group membership..." -Color Cyan

    $AdminGroup = "Administrators"
    $Accounts = $LocalAdminAccounts -split ',' | ForEach-Object { $_.Trim() }

    foreach ($Account in $Accounts) {
        $Group = [ADSI]"WinNT://$env:COMPUTERNAME/$AdminGroup,group"
        if (-not $Group.IsMember("WinNT://$Account")) {
            $Group.Add("WinNT://$Account")
            Write-HealthLog "Added $Account to local Administrators group" -Color Green
        }
    }
}

# =============================================================================
# Cache Size Check
# =============================================================================
if ($FixCacheSize) {
    Write-HealthLog "Checking ConfigMgr Cache Size..." -Color Cyan

    try {
        $Cache = Get-WmiObject -Namespace root\CCM\SoftMgmtAgent -Class CacheConfig -ErrorAction Stop
        if ($Cache.Size -ne $CacheSizeMB) {
            $Cache.Size = $CacheSizeMB
            $Cache.Put() | Out-Null
            Write-HealthLog "Set ConfigMgr cache size to $CacheSizeMB MB" -Color Green
        }
    }
    catch {
        Write-Warning "Could not access ConfigMgr cache settings via WMI."
    }
}

Write-HealthLog "ConfigMgr Client Health Check completed." -Color Green
Stop-Transcript
