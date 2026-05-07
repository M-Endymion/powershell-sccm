<#
.SYNOPSIS
    Checks and optionally fixes critical ConfigMgr client services.

.DESCRIPTION
    Ensures key services like CCMExec and WMI are running with the correct startup type.
    Designed for use in startup scripts, task sequences, or scheduled health checks.

.NOTES
    Author:      M-Endymion
    Version:     1.0
    Last Updated:2026-05-06
#>

[CmdletBinding()]
param (
    [switch]$Fix
)

# =============================================================================
# Configuration
# =============================================================================
$LogPath = "C:\Windows\CCM\Logs\Check-ConfigMgrServices.log"
$CriticalServices = @{
    "CCMExec" = @{StartMode="Automatic"; State="Running"}
    "winmgmt" = @{StartMode="Automatic"; State="Running"}
}

# =============================================================================
# Logging
# =============================================================================
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting ConfigMgr Service Health Check..." -ForegroundColor Cyan

# =============================================================================
# Main Logic
# =============================================================================
$AllHealthy = $true

foreach ($ServiceName in $CriticalServices.Keys) {
    $Expected = $CriticalServices[$ServiceName]
    $Service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

    if (-not $Service) {
        Write-Host "Service $ServiceName not found!" -ForegroundColor Red
        $AllHealthy = $false
        continue
    }

    Write-Host "Checking $ServiceName..." -ForegroundColor Yellow

    # Check Start Mode
    if ($Service.StartMode -ne $Expected.StartMode) {
        if ($Fix) {
            Set-Service -Name $ServiceName -StartupType $Expected.StartMode
            Write-Host "   Fixed start mode to $($Expected.StartMode)" -ForegroundColor Green
        } else {
            Write-Host "   Start mode should be $($Expected.StartMode) but is $($Service.StartMode)" -ForegroundColor Yellow
            $AllHealthy = $false
        }
    }

    # Check State
    if ($Service.Status -ne $Expected.State) {
        if ($Fix) {
            if ($Expected.State -eq "Running") {
                Start-Service -Name $ServiceName
                Write-Host "   Started service $ServiceName" -ForegroundColor Green
            }
        } else {
            Write-Host "   Service should be $($Expected.State) but is $($Service.Status)" -ForegroundColor Yellow
            $AllHealthy = $false
        }
    }
}

if ($AllHealthy) {
    Write-Host "All critical ConfigMgr services are healthy." -ForegroundColor Green
} else {
    Write-Host "One or more services require attention." -ForegroundColor Yellow
}

# Success marker
New-Item -Path "C:\Windows\CCM\Logs\ConfigMgrServices_Check.done" -ItemType File -Force | Out-Null

Stop-Transcript
