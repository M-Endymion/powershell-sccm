<#
.SYNOPSIS
    Sets a custom Lock Screen image for Windows 10 / 11.

.DESCRIPTION
    Copies the provided lock screen image and applies the necessary registry settings.
    Works best when run during OSD (Task Sequence) in System context.

.NOTES
    Author:      M-Endymion
    Version:     1.0
    Last Updated:2026-05-07
#>

[CmdletBinding(SupportsShouldProcess)]
param (
    [string]$ImageName = "LockScreen.jpg",   # Name of the image in the script folder
    [string]$DestinationFolder = "C:\SCD\LockScreen"
)

# =============================================================================
# Configuration
# =============================================================================
$LogPath = "C:\Windows\CCM\Logs\Set-LockScreenImage.log"
$SourceImage = Join-Path $PSScriptRoot $ImageName
$DestImage = Join-Path $DestinationFolder "LockScreen.jpg"
$TattooPath = "HKLM:\SOFTWARE\Contoso\ApplicationTattoos\LockScreen"
$TattooName = "CustomLockScreenSet"

# =============================================================================
# Logging
# =============================================================================
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting Lock Screen Image Configuration..." -ForegroundColor Cyan

try {
    # Verify source image exists
    if (-not (Test-Path $SourceImage)) {
        Write-Error "Source image not found: $SourceImage"
        Write-Error "Please place $ImageName in the same folder as this script."
        exit 1
    }

    if ($PSCmdlet.ShouldProcess("Lock Screen", "Set custom image")) {
        # Create destination folder
        if (-not (Test-Path $DestinationFolder)) {
            New-Item -Path $DestinationFolder -ItemType Directory -Force | Out-Null
        }

        # Copy the image
        Copy-Item -Path $SourceImage -Destination $DestImage -Force
        Write-Host "Lock screen image copied to: $DestImage" -ForegroundColor Green

        # Set Registry Policy
        $RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
        if (-not (Test-Path $RegPath)) {
            New-Item -Path $RegPath -Force | Out-Null
        }

        New-ItemProperty -Path $RegPath `
                         -Name "LockScreenImage" `
                         -Value $DestImage `
                         -PropertyType String `
                         -Force | Out-Null

        Write-Host "Registry policy for LockScreenImage applied." -ForegroundColor Green
    }

    # Create Registry Tattoo
    if (-not (Test-Path $TattooPath)) {
        New-Item -Path $TattooPath -Force | Out-Null
    }
    New-ItemProperty -Path $TattooPath -Name $TattooName -Value 1 -PropertyType DWORD -Force | Out-Null

    # MECM Detection Marker
    New-Item -Path "C:\Windows\CCM\Logs\LockScreenImage_Set.done" -ItemType File -Force | Out-Null

    Write-Host "Custom Lock Screen configuration completed successfully." -ForegroundColor Green
}
catch {
    Write-Error "Failed to set lock screen image: $($_.Exception.Message)"
    exit 1
}
finally {
    Stop-Transcript
}
