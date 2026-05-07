<#
.SYNOPSIS
    Applies "tattoo" information to a Windows image during SCCM/MECM OSD.

.DESCRIPTION
    Pulls Task Sequence variables (starting with "OSDTattoo_") and writes them to:
      - Registry (HKLM:\SOFTWARE\Contoso\OsBuildInfo)
      - Environment Variables (Machine level)
      - (Optional) WMI

    Safe for public repositories.

.NOTES
    Author: M-Endymion (Modern PowerShell rewrite)
    Based on: Stéphane van Gulick (PowerShellDistrict)
    Version: 2.0
    Last Updated: 2026-05-06

.EXAMPLE
    .\New-OSDTattoo.ps1 -All
#>

[CmdletBinding()]
param (
    [switch]$All,
    [switch]$Registry,
    [switch]$EnvironmentVariable,
    [switch]$WMI,
    [string]$Root = "OsBuildInfo"
)

# =============================================================================
# Configuration
# =============================================================================
$LogPath = "C:\Windows\Temp\OSD_Tattoo.log"
$RegistryRoot = "HKLM:\SOFTWARE\Contoso\$Root"

# =============================================================================
# Logging
# =============================================================================
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting OSD Tattoo process..." -ForegroundColor Cyan

# =============================================================================
# Connect to Task Sequence Environment
# =============================================================================
try {
    $TSEnv = New-Object -COMObject Microsoft.SMS.TSEnvironment -ErrorAction Stop
    Write-Host "Connected to Task Sequence Environment" -ForegroundColor Green
}
catch {
    Write-Warning "Not running inside a Task Sequence."
    $TSEnv = $null
}

# =============================================================================
# Helper Functions
# =============================================================================
function Write-TattooLog {
    param([string]$Message)
    "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $Message" | Out-File -FilePath $LogPath -Append
    Write-Host $Message
}

function Set-OSDTattooRegistry {
    param([string]$Name, [string]$Value)
    if (-not (Test-Path $RegistryRoot)) {
        New-Item -Path $RegistryRoot -Force | Out-Null
    }
    Set-ItemProperty -Path $RegistryRoot -Name $Name -Value $Value -Force
    Write-TattooLog "Registry: $Name = $Value"
}

function Set-OSDTattooEnvironment {
    param([string]$Name, [string]$Value)
    [Environment]::SetEnvironmentVariable($Name, $Value, "Machine")
    Write-TattooLog "Environment Variable: $Name = $Value"
}

# =============================================================================
# Main Tattoo Logic
# =============================================================================
try {
    Write-TattooLog "OSD Tattoo Script v2.0 started"

    # Get all OSDTattoo_* variables from Task Sequence
    $TattooVars = Get-ChildItem -Path "Env:OSDTattoo_*" -ErrorAction SilentlyContinue

    if (-not $TattooVars) {
        Write-TattooLog "No OSDTattoo_* variables found."
    }

    foreach ($Var in $TattooVars) {
        $Name = $Var.Name
        $Value = $Var.Value

        $TattooToAll = $All -or (-not ($Registry -or $EnvironmentVariable -or $WMI))

        if ($TattooToAll -or $Registry) {
            Set-OSDTattooRegistry -Name $Name -Value $Value
        }
        if ($TattooToAll -or $EnvironmentVariable) {
            Set-OSDTattooEnvironment -Name $Name -Value $Value
        }
        if ($WMI) {
            Write-TattooLog "WMI tattooing skipped (not implemented in this version)"
        }
    }

    # Success marker
    New-Item -Path "C:\Windows\CCM\Logs\OSD_Tattoo_Applied.done" -ItemType File -Force | Out-Null

    Write-TattooLog "OSD Tattooing completed successfully!"
    Stop-Transcript
    exit 0
}
catch {
    Write-TattooLog "ERROR: $($_.Exception.Message)"
    Stop-Transcript
    exit 1
}
