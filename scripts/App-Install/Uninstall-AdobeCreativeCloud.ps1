<#
.SYNOPSIS
    Uninstalls all Adobe Creative Cloud applications.

.DESCRIPTION
    Runs the official Adobe Creative Cloud uninstaller with the --all flag,
    then creates a registry tattoo for MECM/SCCM detection.

.NOTES
    Author:      M-Endymion
    Version:     1.0
    Last Updated:2026-05-07
#>

[CmdletBinding(SupportsShouldProcess)]
param ()

# =============================================================================
# Configuration
# =============================================================================
$LogPath = "C:\Windows\CCM\Logs\Uninstall-AdobeCreativeCloud.log"
$UninstallerExe = Join-Path $PSScriptRoot "AdobeUninstaller.exe"
$TattooPath = "HKLM:\SOFTWARE\Contoso\ApplicationTattoos\Adobe"
$TattooName = "UninstallCCApps"

# =============================================================================
# Logging
# =============================================================================
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting Adobe Creative Cloud Uninstall..." -ForegroundColor Cyan

try {
    # Verify uninstaller exists
    if (-not (Test-Path $UninstallerExe)) {
        Write-Error "AdobeUninstaller.exe not found in script directory: $PSScriptRoot"
        exit 1
    }

    # Run the uninstaller
    if ($PSCmdlet.ShouldProcess("Adobe Creative Cloud Apps", "Uninstall All")) {
        Write-Host "Running Adobe uninstaller with --all flag..." -ForegroundColor Yellow
        
        $Process = Start-Process -FilePath $UninstallerExe `
                                 -ArgumentList "--all" `
                                 -Wait `
                                 -PassThru `
                                 -NoNewWindow

        Write-Host "Uninstaller completed with exit code: $($Process.ExitCode)" -ForegroundColor Green
    }

    # Create Registry Tattoo
    if (-not (Test-Path $TattooPath)) {
        New-Item -Path $TattooPath -Force | Out-Null
    }
    
    New-ItemProperty -Path $TattooPath `
                     -Name $TattooName `
                     -Value 1 `
                     -PropertyType DWORD `
                     -Force | Out-Null

    Write-Host "Registry tattoo created successfully." -ForegroundColor Green

    # MECM Detection Marker
    New-Item -Path "C:\Windows\CCM\Logs\AdobeCreativeCloud_Uninstalled.done" -ItemType File -Force | Out-Null

    Write-Host "Adobe Creative Cloud uninstallation completed." -ForegroundColor Green
}
catch {
    Write-Error "An error occurred during uninstall: $($_.Exception.Message)"
    exit 1
}
finally {
    Stop-Transcript
}
