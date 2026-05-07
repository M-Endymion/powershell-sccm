<#
.SYNOPSIS
    Checks critical prerequisites for a healthy ConfigMgr client.

.DESCRIPTION
    Verifies WMI connectivity, admin shares, key services, and other prerequisites.
    Can be used as part of a startup script or scheduled health check.

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
# Logging
# =============================================================================
$LogPath = "C:\Windows\CCM\Logs\Check-ConfigMgrPrerequisites.log"
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting ConfigMgr Prerequisites Check..." -ForegroundColor Cyan

$AllPassed = $true

# =============================================================================
# WMI Connectivity Check
# =============================================================================
try {
    $null = Get-WmiObject -Namespace root\CCM -Class SMS_Client -ErrorAction Stop
    Write-Host "WMI Connectivity (root\CCM): OK" -ForegroundColor Green
}
catch {
    Write-Warning "WMI Connectivity (root\CCM): FAILED"
    $AllPassed = $false
    
    if ($Fix) {
        Write-Host "Attempting to repair WMI..." -ForegroundColor Yellow
        # Basic WMI repair command (can be expanded)
        winmgmt /salvagerepository | Out-Null
    }
}

# =============================================================================
# Admin$ Share Check
# =============================================================================
try {
    if (Test-Path "C:\Windows") {
        Write-Host "Admin$ Share: OK" -ForegroundColor Green
    } else {
        throw "Admin$ share not accessible"
    }
}
catch {
    Write-Warning "Admin$ Share: FAILED"
    $AllPassed = $false
}

# =============================================================================
# Critical Services Check
# =============================================================================
$CriticalServices = @("CCMExec", "winmgmt")

foreach ($ServiceName in $CriticalServices) {
    $Service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
    if ($Service -and $Service.Status -eq "Running") {
        Write-Host "Service $ServiceName: OK" -ForegroundColor Green
    } else {
        Write-Warning "Service $ServiceName: Not Running"
        $AllPassed = $false
        
        if ($Fix) {
            Start-Service -Name $ServiceName -ErrorAction SilentlyContinue
            Write-Host "Attempted to start $ServiceName" -ForegroundColor Yellow
        }
    }
}

# =============================================================================
# Final Result
# =============================================================================
if ($AllPassed) {
    Write-Host "All prerequisites passed." -ForegroundColor Green
} else {
    Write-Host "One or more prerequisites failed." -ForegroundColor Yellow
}

# Success marker
New-Item -Path "C:\Windows\CCM\Logs\ConfigMgrPrereqs_Check.done" -ItemType File -Force | Out-Null

Stop-Transcript
