<#
.SYNOPSIS
    Uninstalls Git for Windows via SCCM / MECM.

.DESCRIPTION
    Removes Git using the official uninstaller (unins000.exe) when available,
    with fallback to Windows uninstaller. Removes the registry tattoo used for detection.
    Designed for enterprise deployment.

.NOTES
    Author: M-Endymion
    Version: 1.0
    Last Updated: 2026-05-06
    Requirements:
        - Administrative privileges required

.EXAMPLE
    .\Uninstall-Git.ps1
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param()

# =============================================================================
# Configuration
# =============================================================================
$LogPath = "C:\Windows\CCM\Logs\Uninstall-Git.log"
$RegistryPath = "HKLM:\SOFTWARE\Contoso\ApplicationTattoos\Git"
$GitUninstaller = "C:\Program Files\Git\unins000.exe"

# =============================================================================
# Logging
# =============================================================================
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting Git uninstallation process..." -ForegroundColor Cyan

# =============================================================================
# Main Script
# =============================================================================
try {
    $Uninstalled = $false

    # Try official Git uninstaller first
    if (Test-Path $GitUninstaller) {
        Write-Host "Found official Git uninstaller. Running silent uninstall..." -ForegroundColor Yellow

        if ($PSCmdlet.ShouldProcess("Git", "Uninstall")) {
            $Process = Start-Process -FilePath $GitUninstaller `
                                     -ArgumentList "/VERYSILENT /NORESTART" `
                                     -Wait -PassThru -NoNewWindow

            if ($Process.ExitCode -eq 0) {
                Write-Host "Git uninstalled successfully via official uninstaller." -ForegroundColor Green
                $Uninstalled = $true
            }
            else {
                Write-Warning "Uninstaller exited with code: $($Process.ExitCode)"
            }
        }
    }

    # Fallback: Windows Uninstall (if official method didn't work)
    if (-not $Uninstalled) {
        Write-Host "Attempting uninstall via Windows registry..." -ForegroundColor Yellow
        $GitApp = Get-WmiObject -Class Win32_Product -ErrorAction SilentlyContinue |
                  Where-Object { $_.Name -like "*Git*" }

        if ($GitApp) {
            $Process = Start-Process -FilePath "msiexec.exe" `
                                     -ArgumentList "/x $($GitApp.IdentifyingNumber) /quiet /norestart" `
                                     -Wait -PassThru

            if ($Process.ExitCode -eq 0) {
                Write-Host "Git uninstalled successfully via msiexec." -ForegroundColor Green
                $Uninstalled = $true
            }
        }
    }

    # Remove registry tattoo (cleanup)
    if (Test-Path $RegistryPath) {
        Write-Host "Removing registry tattoo..." -ForegroundColor Cyan
        Remove-Item -Path $RegistryPath -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Registry tattoo removed." -ForegroundColor Green
    }

    # Success marker
    $Marker = "C:\Windows\CCM\Logs\Uninstall-Git.done"
    New-Item -Path $Marker -ItemType File -Force | Out-Null

    if ($Uninstalled -or (Test-Path $Marker)) {
        Write-Host "Git uninstallation completed successfully." -ForegroundColor Green
    }
    else {
        Write-Host "No Git installation detected. Cleanup completed." -ForegroundColor Yellow
    }

    Stop-Transcript
    exit 0
}
catch {
    Write-Error "Failed to uninstall Git: $($_.Exception.Message)"
    Stop-Transcript
    exit 1
}
