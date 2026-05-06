<#
.SYNOPSIS
    Installs Git for Windows via SCCM / MECM.

.DESCRIPTION
    Silently installs Git using the official standalone installer with common developer components.
    Creates a registry tattoo for MECM detection rules and provides detailed logging.

.NOTES
    Author: M-Endymion
    Version: 1.0
    Last Updated: 2026-05-06
    Requirements:
        - Git-*-64-bit.exe must be in the same folder as this script
        - Administrative privileges required

.EXAMPLE
    .\Install-Git.ps1
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param()

# =============================================================================
# Configuration
# =============================================================================
$LogPath = "C:\Windows\CCM\Logs\Install-Git.log"
$InstallerPattern = "Git-*-64-bit.exe"
$RegistryPath = "HKLM:\SOFTWARE\Contoso\ApplicationTattoos\Git"
$RegistryName = "Installed"
$RegistryValue = 1

# =============================================================================
# Logging Setup
# =============================================================================
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting Git installation..." -ForegroundColor Cyan

# =============================================================================
# Main Script
# =============================================================================
try {
    # Find the Git installer in the script directory
    $ScriptDir = $PSScriptRoot
    $Installer = Get-ChildItem -Path $ScriptDir -Filter $InstallerPattern -File | Select-Object -First 1

    if (-not $Installer) {
        Write-Error "Git installer not found. Expected file matching: $InstallerPattern"
        exit 1
    }

    Write-Host "Found installer: $($Installer.Name)" -ForegroundColor Green

    # Installation arguments
    $InstallArgs = '/VERYSILENT /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /COMPONENTS="icons,ext\reg\shellhere,assoc,assoc_sh"'

    if ($PSCmdlet.ShouldProcess($Installer.Name, "Install Git")) {
        Write-Host "Installing Git..." -ForegroundColor Yellow

        $Process = Start-Process -FilePath $Installer.FullName `
                                 -ArgumentList $InstallArgs `
                                 -Wait `
                                 -PassThru `
                                 -NoNewWindow

        if ($Process.ExitCode -eq 0) {
            Write-Host "Git installed successfully." -ForegroundColor Green
        }
        else {
            Write-Warning "Git installer exited with code: $($Process.ExitCode)"
        }
    }

    # =============================================================================
    # Registry Tattoo (for SCCM/MECM detection)
    # =============================================================================
    Write-Host "Applying registry tattoo..." -ForegroundColor Cyan

    if (-not (Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
    }

    New-ItemProperty -Path $RegistryPath `
                     -Name $RegistryName `
                     -Value $RegistryValue `
                     -PropertyType DWORD `
                     -Force | Out-Null

    Write-Host "Registry tattoo applied successfully." -ForegroundColor Green

    # Success marker
    $Marker = "C:\Windows\CCM\Logs\Install-Git.done"
    New-Item -Path $Marker -ItemType File -Force | Out-Null

    Write-Host "Git installation process completed successfully." -ForegroundColor Cyan
    Stop-Transcript
    exit 0
}
catch {
    Write-Error "Failed to install Git: $($_.Exception.Message)"
    Stop-Transcript
    exit 1
}
