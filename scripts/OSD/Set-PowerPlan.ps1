<#
.SYNOPSIS
    Sets the Windows Power Plan (High Performance or Balanced) during OSD.

.DESCRIPTION
    Configures the active power scheme using powercfg.exe.
    Works in both WinPE and the full OS. Designed for SCCM/MECM Task Sequences.

.NOTES
    Author:      M-Endymion
    Version:     1.0
    Last Updated:2026-05-06

.EXAMPLE
    # High Performance
    .\Set-PowerPlan.ps1 -PowerPlan High

.EXAMPLE
    # Balanced
    .\Set-PowerPlan.ps1 -PowerPlan Balanced
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [ValidateSet("High", "Balanced")]
    [string]$PowerPlan
)

# =============================================================================
# Configuration
# =============================================================================
$LogPath = "C:\Windows\CCM\Logs\Set-PowerPlan.log"

$PowerPlans = @{
    "High"      = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
    "Balanced"  = "381b4222-f694-41f0-9685-ff5bb260df2e"
}

# =============================================================================
# Logging
# =============================================================================
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Setting Power Plan to: $PowerPlan" -ForegroundColor Cyan

# =============================================================================
# Main Script
# =============================================================================
try {
    $GUID = $PowerPlans[$PowerPlan]

    Write-Host "Applying power scheme: $PowerPlan ($GUID)" -ForegroundColor Yellow

    $Result = powercfg.exe /setactive $GUID

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Successfully set $PowerPlan power plan." -ForegroundColor Green
    }
    else {
        Write-Warning "powercfg.exe returned exit code: $LASTEXITCODE"
    }

    # Success marker
    New-Item -Path "C:\Windows\CCM\Logs\PowerPlan_$PowerPlan.done" -ItemType File -Force | Out-Null

    Write-Host "Power plan configuration completed." -ForegroundColor Green
    Stop-Transcript
    exit 0
}
catch {
    Write-Error "Failed to set power plan: $($_.Exception.Message)"
    Stop-Transcript
    exit 1
}
