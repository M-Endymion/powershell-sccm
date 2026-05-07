<#
.SYNOPSIS
    Installs Microsoft Snipping Tool and Microsoft Photos via winget.

.DESCRIPTION
    Ensures winget is installed and up-to-date, then silently installs:
      - Snipping Tool (Microsoft.ScreenSketch)
      - Microsoft Photos
    
    Designed for SCCM / MECM deployment.

.NOTES
    Author: M-Endymion (PowerShell version)
    Original BAT Author: SecretSquirrel
    Version: 1.0
    Last Updated: 2026-05-06

.EXAMPLE
    .\Install-SnippingToolAndPhotos.ps1
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param()

# =============================================================================
# Configuration
# =============================================================================
$LogPath = "C:\Windows\CCM\Logs\Install-SnippingToolAndPhotos.log"
$DetectionMarker = "C:\Windows\CCM\Logs\WingetApps_Install.done"

$Apps = @(
    @{ Id = "9MZ95KL8MR0L"; Name = "Snipping Tool" },
    @{ Id = "9WZDNCRFJBH4"; Name = "Microsoft Photos" }
)

# =============================================================================
# Logging
# =============================================================================
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting installation of Snipping Tool and Microsoft Photos..." -ForegroundColor Cyan

# =============================================================================
# Helper Function: Ensure Winget is Available
# =============================================================================
function Ensure-Winget {
    try {
        $null = Get-Command winget -ErrorAction Stop
        $version = & winget --version
        Write-Host "Winget detected: $version" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "Winget not found. Installing latest version..." -ForegroundColor Yellow
        $url = "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
        $tempFile = "$env:TEMP\Microsoft.DesktopAppInstaller.msixbundle"

        try {
            Invoke-WebRequest -Uri $url -OutFile $tempFile -UseBasicParsing
            Add-AppxPackage -Path $tempFile
            Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
            Write-Host "Winget installed successfully." -ForegroundColor Green
            return $true
        }
        catch {
            Write-Error "Failed to install winget: $($_.Exception.Message)"
            return $false
        }
    }
}

# =============================================================================
# Main Script
# =============================================================================
try {
    # Ensure winget is ready
    if (-not (Ensure-Winget)) {
        exit 1
    }

    # Install applications
    foreach ($app in $Apps) {
        Write-Host "Installing $($app.Name)..." -ForegroundColor Yellow

        if ($PSCmdlet.ShouldProcess($app.Name, "Install via winget")) {
            $Result = Start-Process -FilePath "winget.exe" `
                                    -ArgumentList "install --id $($app.Id) --source msstore --silent --accept-package-agreements --accept-source-agreements" `
                                    -Wait -PassThru -NoNewWindow

            if ($Result.ExitCode -eq 0 -or $Result.ExitCode -eq -1978335231) {  # -1978335231 = already installed
                Write-Host "$($app.Name) installed successfully (or already present)." -ForegroundColor Green
            }
            else {
                Write-Warning "$($app.Name) installation returned exit code: $($Result.ExitCode)"
            }
        }
    }

    # Create detection marker for MECM
    New-Item -Path $DetectionMarker -ItemType File -Force | Out-Null
    Write-Host "Detection marker created." -ForegroundColor Green

    Write-Host "Snipping Tool and Microsoft Photos installation process completed." -ForegroundColor Cyan
    Stop-Transcript
    exit 0
}
catch {
    Write-Error "An error occurred during installation: $($_.Exception.Message)"
    Stop-Transcript
    exit 1
}
