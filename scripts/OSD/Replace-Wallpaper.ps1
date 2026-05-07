<#
.SYNOPSIS
    Replaces the default Windows wallpaper with a custom one (including 4K versions).

.DESCRIPTION
    Takes ownership of default wallpaper files, removes them, and replaces with custom
    img0.jpg and all 4K resolution variants. Designed for use during SCCM/MECM OSD.

.NOTES
    Author: M-Endymion
    Version: 1.0
    Last Updated: 2026-05-06
    Requirements:
        - img0.jpg in the script folder
        - Optional: 4K folder with files like img0_3840x2160.jpg, etc.

.EXAMPLE
    .\Replace-Wallpaper.ps1
#>

[CmdletBinding()]
param()

# =============================================================================
# Configuration
# =============================================================================
$LogPath = "C:\Windows\CCM\Logs\Replace-Wallpaper.log"

$StandardWallpaperPath = "C:\Windows\Web\Wallpaper\Windows\img0.jpg"
$4KWallpaperFolder    = "C:\Windows\Web\4K\Wallpaper\Windows"

$SourceImg0           = Join-Path $PSScriptRoot "img0.jpg"
$Source4KFolder       = Join-Path $PSScriptRoot "4K"

# =============================================================================
# Logging
# =============================================================================
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting custom wallpaper replacement..." -ForegroundColor Cyan

# =============================================================================
# Helper Function
# =============================================================================
function Write-WallpaperLog {
    param([string]$Message, [string]$Color = "White")
    "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $Message" | Out-File -FilePath $LogPath -Append
    Write-Host $Message -ForegroundColor $Color
}

# =============================================================================
# Main Script
# =============================================================================
try {
    # Take ownership and grant permissions
    Write-WallpaperLog "Taking ownership of default wallpaper files..." -Color Yellow

    takeown /f $StandardWallpaperPath /a /r /d Y | Out-Null
    icacls $StandardWallpaperPath /grant "System:(F)" /t | Out-Null

    if (Test-Path $4KWallpaperFolder) {
        takeown /f "$4KWallpaperFolder\*" /a /r /d Y | Out-Null
        icacls "$4KWallpaperFolder\*" /grant "System:(F)" /t | Out-Null
    }

    # Remove default wallpapers
    if (Test-Path $StandardWallpaperPath) {
        Remove-Item $StandardWallpaperPath -Force
        Write-WallpaperLog "Removed default standard wallpaper" -Color Green
    }

    if (Test-Path $4KWallpaperFolder) {
        Remove-Item "$4KWallpaperFolder\*" -Force -Recurse
        Write-WallpaperLog "Removed default 4K wallpapers" -Color Green
    }

    # Copy new standard wallpaper
    if (Test-Path $SourceImg0) {
        Copy-Item $SourceImg0 -Destination $StandardWallpaperPath -Force
        Write-WallpaperLog "Custom standard wallpaper (img0.jpg) applied successfully" -Color Green
    } else {
        Write-WallpaperLog "WARNING: img0.jpg not found in script folder" -Color Yellow
    }

    # Copy 4K wallpapers
    if (Test-Path $Source4KFolder) {
        if (-not (Test-Path $4KWallpaperFolder)) {
            New-Item -Path $4KWallpaperFolder -ItemType Directory -Force | Out-Null
        }
        Copy-Item "$Source4KFolder\*" -Destination $4KWallpaperFolder -Force -Recurse
        Write-WallpaperLog "Custom 4K wallpapers copied successfully" -Color Green
    } else {
        Write-WallpaperLog "No 4K folder found - skipping 4K wallpapers" -Color Gray
    }

    # Success marker
    New-Item -Path "C:\Windows\CCM\Logs\Replace-Wallpaper.done" -ItemType File -Force | Out-Null

    Write-WallpaperLog "Custom wallpaper replacement completed successfully!" -Color Green
    Stop-Transcript
    exit 0
}
catch {
    Write-WallpaperLog "ERROR: $($_.Exception.Message)" -Color Red
    Stop-Transcript
    exit 1
}
