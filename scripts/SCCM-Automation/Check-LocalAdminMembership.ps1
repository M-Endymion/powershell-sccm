<#
.SYNOPSIS
    Checks and optionally adds specified accounts to the local Administrators group.

.DESCRIPTION
    Useful for ensuring service accounts or helpdesk accounts have local admin rights
    on ConfigMgr clients. Designed for startup scripts or scheduled health checks.

.NOTES
    Author:      M-Endymion
    Version:     1.0
    Last Updated:2026-05-06
#>

[CmdletBinding()]
param (
    [switch]$Fix,
    [string]$Accounts = ""   # Comma-separated list of accounts (e.g. "DOMAIN\HelpDesk,DOMAIN\SCCMService")
)

# =============================================================================
# Logging
# =============================================================================
$LogPath = "C:\Windows\CCM\Logs\Check-LocalAdminMembership.log"
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting Local Administrators Group Check..." -ForegroundColor Cyan

# =============================================================================
# Main Logic
# =============================================================================
if (-not $Accounts) {
    Write-Host "No accounts specified. Skipping check." -ForegroundColor Gray
    Stop-Transcript
    exit 0
}

$AdminGroupName = "Administrators"
$AdminGroup = [ADSI]"WinNT://$env:COMPUTERNAME/$AdminGroupName,group"

$AccountList = $Accounts -split ',' | ForEach-Object { $_.Trim() }

foreach ($Account in $AccountList) {
    try {
        if ($AdminGroup.IsMember("WinNT://$Account")) {
            Write-Host "Account already member: $Account" -ForegroundColor Green
        }
        else {
            if ($Fix) {
                $AdminGroup.Add("WinNT://$Account")
                Write-Host "Added account to local Administrators: $Account" -ForegroundColor Green
            }
            else {
                Write-Warning "Account missing from local Administrators: $Account"
            }
        }
    }
    catch {
        Write-Warning "Failed to check/add account $Account : $($_.Exception.Message)"
    }
}

# Success marker
New-Item -Path "C:\Windows\CCM\Logs\LocalAdmin_Check.done" -ItemType File -Force | Out-Null

Write-Host "Local Admin membership check completed." -ForegroundColor Green
Stop-Transcript
