<#
.SYNOPSIS
    Fixes IE/Edge Error 1509 during SCCM OSD by removing problematic iesqmdata_setup0.sqm files.

.DESCRIPTION
    Deletes the iesqmdata_setup0.sqm file(s) from the Default User profile.
    This is a well-known issue that can cause profile loading failures during imaging.

.NOTES
    Author: M-Endymion
    Version: 1.0
    Last Updated: 2026-05-06
    Context: Best used in SCCM Task Sequence (after Apply Operating System step)

.EXAMPLE
    .\Fix-IEError1509.ps1
#>

[CmdletBinding()]
param()

# =============================================================================
# Configuration
# =============================================================================
$LogPath = "C:\Windows\CCM\Logs\Fix-IEError1509.log"
$SearchPath = "C:\Users\Default"
$FileNamePattern = "iesqmdata_setup0.sqm"

# =============================================================================
# Logging
# =============================================================================
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting IE Error 1509 fix..." -ForegroundColor Cyan

# =============================================================================
# Main Script
# =============================================================================
try {
    Write-Host "Searching for $FileNamePattern in $SearchPath..." -ForegroundColor Yellow

    $FilesToDelete = Get-ChildItem -Path $SearchPath -Recurse -Force -ErrorAction SilentlyContinue |
                     Where-Object { $_.Name -like "*$FileNamePattern*" -and $_.PSIsContainer -eq $false }

    if ($FilesToDelete) {
        foreach ($File in $FilesToDelete) {
            Write-Host "Deleting: $($File.FullName)" -ForegroundColor Yellow
            Remove-Item -Path $File.FullName -Force -ErrorAction Stop
        }
        Write-Host "Successfully removed $($FilesToDelete.Count) problematic file(s)." -ForegroundColor Green
    }
    else {
        Write-Host "No matching files found. Nothing to delete." -ForegroundColor Green
    }

    # Create success marker for Task Sequence / SCCM
    New-Item -Path "C:\Windows\CCM\Logs\IEError1509_Fixed.done" -ItemType File -Force | Out-Null

    Write-Host "IE Error 1509 fix completed successfully." -ForegroundColor Green
    Stop-Transcript
    exit 0
}
catch {
    Write-Error "Failed to fix IE Error 1509: $($_.Exception.Message)"
    Stop-Transcript
    exit 1
}
