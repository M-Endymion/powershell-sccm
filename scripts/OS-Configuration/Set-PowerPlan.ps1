<#
.SYNOPSIS
    Sets the Windows Power Plan (High Performance or Balanced).

.DESCRIPTION
    Configures the active power scheme and creates a registry tattoo for MECM detection.
    Ideal for use in OSD Task Sequences or baseline configuration.

.NOTES
    Author:      M-Endymion
    Version:     1.0
    Last Updated:2026-05-07
#>

[CmdletBinding(SupportsShouldProcess)]
param (
    [ValidateSet("HighPerformance", "Balanced")]
    [string]$PowerPlan = "HighPerformance",

    [switch]$Force
)

# =============================================================================
# Configuration
# =============================================================================
$LogPath = "C:\Windows\CCM\Logs\Set-PowerPlan.log"
$TattooPath = "HKLM:\SOFTWARE\Contoso\ApplicationTattoos\PowerPlan"
$TattooName = "ActivePowerPlan"

# Power Plan GUIDs
$PowerPlans = @{
    "HighPerformance" = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
    "Balanced"        = "381b4222-f694-41f0-9685-ff5bb260df2e"
}

# =============================================================================
# Logging
# =============================================================================
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting Power Plan Configuration - Target: $PowerPlan" -ForegroundColor Cyan

try {
    $Guid = $PowerPlans[$PowerPlan]

    if ($PSCmdlet.ShouldProcess("Power Plan", "Set to $PowerPlan")) {
        Write-Host "Setting power plan to: $PowerPlan" -ForegroundColor Yellow
        
        # Set the active power plan
        $Result = powercfg /setactive $Guid
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Power plan successfully set to $PowerPlan" -ForegroundColor Green
        } else {
            Write-Warning "powercfg returned exit code: $LASTEXITCODE"
        }
    }

    # Create Registry Tattoo
    if (-not (Test-Path $TattooPath)) {
        New-Item -Path $TattooPath -Force | Out-Null
    }
    
    New-ItemProperty -Path $TattooPath `
                     -Name $TattooName `
                     -Value $PowerPlan `
                     -PropertyType String `
                     -Force | Out-Null

    Write-Host "Registry tattoo created: $PowerPlan" -ForegroundColor Green

    # MECM Detection Marker
    New-Item -Path "C:\Windows\CCM\Logs\PowerPlan_Set_$PowerPlan.done" -ItemType File -Force | Out-Null

    Write-Host "Power Plan configuration completed successfully." -ForegroundColor Green
}
catch {
    Write-Error "Failed to set power plan: $($_.Exception.Message)"
    exit 1
}
finally {
    Stop-Transcript
}
