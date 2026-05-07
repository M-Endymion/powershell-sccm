<#
.SYNOPSIS
    Replaces the default Windows desktop wallpaper (including 4K variants).

.DESCRIPTION
    Takes ownership of default wallpaper files, removes them, and replaces them
    with custom wallpaper(s). Supports both standard and 4K wallpapers.

.NOTES
    Author:      M-Endymion
    Version:     1.0
    Last Updated:2026-05-07
#>

[CmdletBinding(SupportsShouldProcess)]
param (
    [string]$StandardWallpaper = "img0.jpg",
    [string]$FourKFolder = "4K"                  # Folder containing 4K wallpaper variants
)

# =============================================================================
# Configuration
# =============================================================================
$LogPath = "C:\Windows\CCM\Logs\Replace-Wallpaper.log"
$TattooPath = "HKLM:\SOFTWARE\Contoso\ApplicationTattoos\Wallpaper"
$TattooName = "CustomWallpaperSet"

$WinWallpaperPath = "C:\Windows\Web\Wallpaper\Windows"
$Win4KPath = "C:\Windows\Web\4K\Wallpaper\Windows"

$SourceStandard = Join-Path $PSScriptRoot $StandardWallpaper
$Source4K = Join-Path $PSScriptRoot $FourKFolder

# =============================================================================
# Logging
# =============================================================================
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting Windows Wallpaper Replacement..." -ForegroundColor Cyan

try {
    if ($PSCmdlet.ShouldProcess("Windows Wallpaper", "Replace with custom images")) {

        # Take ownership and grant permissions
        Write-Host "Taking ownership of default wallpaper files..." -ForegroundColor Yellow
        takeown /f "$WinWallpaperPath\img0.jpg" /a /r /d Y | Out-Null
        icacls "$WinWallpaperPath\img0.jpg" /grant Administrators:F /t | Out-Null
        icacls "$Win4KPath\*" /grant Administrators:F /t | Out-Null

        # Remove default wallpapers
        Remove-Item "$WinWallpaperPath\img0.jpg" -Force -ErrorAction SilentlyContinue
        Remove-Item "$Win4KPath\*" -Force -ErrorAction SilentlyContinue

        # Copy standard wallpaper
        if (Test-Path $SourceStandard) {
            Copy-Item -Path $SourceStandard -Destination "$WinWallpaperPath\img0.jpg" -Force
            Write-Host "Standard wallpaper replaced successfully." -ForegroundColor Green
        } else {
            Write-Warning "Standard wallpaper '$StandardWallpaper' not found in script folder."
        }

        # Copy 4K wallpapers
        if (Test-Path $Source4K) {
            if (-not (Test-Path $Win4KPath)) {
                New-Item -Path $Win4KPath -ItemType Directory -Force | Out-Null
            }
            Copy-Item -Path "$Source4K\*" -Destination $Win4KPath -Recurse -Force
            Write-Host "4K wallpapers copied successfully." -ForegroundColor Green
        } else {
            Write-Warning "4K wallpaper folder not found. Skipping."
        }
    }

    # Create Registry Tattoo
    if (-not (Test-Path $TattooPath)) {
        New-Item -Path $TattooPath -Force | Out-Null
    }
    New-ItemProperty -Path $TattooPath -Name $TattooName -Value 1 -PropertyType DWORD -Force | Out-Null

    # MECM Detection Marker
    New-Item -Path "C:\Windows\CCM\Logs\CustomWallpaper_Applied.done" -ItemType File -Force | Out-Null

    Write-Host "Wallpaper replacement completed successfully." -ForegroundColor Green
}
catch {
    Write-Error "Failed to replace wallpaper: $($_.Exception.Message)"
    exit 1
}
finally {
    Stop-Transcript
}
