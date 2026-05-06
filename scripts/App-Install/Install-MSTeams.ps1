<#
.SYNOPSIS
    Installs Microsoft Teams (new Teams client) silently.

.DESCRIPTION
    Installs MS Teams using the official MSTeamsSetup.exe with per-machine (-p) installation.
    Ideal for Amazon WorkSpaces, Citrix, RDS, or any multi-user / VDI environment.
    Creates a registry tattoo for SCCM/MECM detection.

.NOTES
    Author: M-Endymion
    Version: 1.0
    Last Updated: 2026-05-06
    Requirements:
        - MSTeamsSetup.exe (latest) must be in the same folder as this script
        - Administrative privileges required

.EXAMPLE
    .\Install-MSTeams.ps1
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param()

# =============================================================================
# Configuration
# =============================================================================
$LogPath = "C:\Windows\CCM\Logs\Install-MSTeams.log"
$InstallerName = "MSTeamsSetup.exe"
$RegistryPath = "HKLM:\SOFTWARE\Contoso\ApplicationTattoos\MSTeams"
$RegistryName = "Installed"
$RegistryValue = 1

# =============================================================================
# Logging
# =============================================================================
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting Microsoft Teams installation..." -ForegroundColor Cyan

# =============================================================================
# Main Script
# =============================================================================
try {
    # Locate installer
    $ScriptDir = $PSScriptRoot
    $InstallerPath = Join-Path -Path $ScriptDir -ChildPath $InstallerName

    if (-not (Test-Path $InstallerPath)) {
        Write-Error "MSTeamsSetup.exe not found in script directory."
        Write-Host "Please place the latest MSTeamsSetup.exe in the same folder as this script." -ForegroundColor Red
        exit 1
    }

    Write-Host "Found installer: $InstallerName" -ForegroundColor Green

    # Install with per-machine flag (-p) - best for WorkSpaces / VDI
    $Arguments = "-p"

    if ($PSCmdlet.ShouldProcess("Microsoft Teams", "Install")) {
        Write-Host "Installing Microsoft Teams (per-machine mode)..." -ForegroundColor Yellow

        $Process = Start-Process -FilePath $InstallerPath `
                                 -ArgumentList $Arguments `
                                 -Wait `
                                 -PassThru `
                                 -NoNewWindow

        if ($Process.ExitCode -eq 0) {
            Write-Host "Microsoft Teams installed successfully." -ForegroundColor Green
        }
        else {
            Write-Warning "Installer exited with code: $($Process.ExitCode)"
        }
    }

    # =============================================================================
    # Registry Tattoo for SCCM/MECM Detection
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
    $Marker = "C:\Windows\CCM\Logs\Install-MSTeams.done"
    New-Item -Path $Marker -ItemType File -Force | Out-Null

    Write-Host "Microsoft Teams installation completed successfully." -ForegroundColor Cyan
    Stop-Transcript
    exit 0
}
catch {
    Write-Error "Failed to install Microsoft Teams: $($_.Exception.Message)"
    Stop-Transcript
    exit 1
}
