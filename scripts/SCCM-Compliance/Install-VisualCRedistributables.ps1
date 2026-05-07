<#
.SYNOPSIS
    Remediation script - Installs missing Microsoft Visual C++ Redistributables.

.DESCRIPTION
    Downloads and silently installs the required Visual C++ runtimes (x86 and x64).
    Designed to be used as the Remediation Script paired with Get-VisualCRedistributables.ps1.

.NOTES
    Author:      M-Endymion
    Version:     2.0
    Last Updated:2026-05-06
#>

[CmdletBinding()]
param()

# =============================================================================
# Configuration - Add or remove versions as needed
# =============================================================================
$RequiredVC = @{
    "2005"      = $true
    "2008x86"   = $true
    "2010x86"   = $true
    "2012x86"   = $true
    "2013x86"   = $true
    "2015-2019x86" = $true
    "2015-2019x64" = $true
}

$LogPath = "C:\Windows\CCM\Logs\Install-VisualCRedistributables.log"

# =============================================================================
# Logging
# =============================================================================
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting Visual C++ Redistributable remediation..." -ForegroundColor Cyan

# =============================================================================
# Helper Function - Silent Installer
# =============================================================================
function Install-VCRedist {
    param([string]$Url, [string]$FileName, [string]$Version)

    $OutFile = "$env:TEMP\$FileName"

    try {
        Write-Host "Downloading $Version..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri $Url -OutFile $OutFile -UseBasicParsing

        Write-Host "Installing $Version..." -ForegroundColor Yellow
        $Process = Start-Process -FilePath $OutFile -ArgumentList "/install /quiet /norestart" -Wait -PassThru

        if ($Process.ExitCode -eq 0 -or $Process.ExitCode -eq 3010) {
            Write-Host "$Version installed successfully" -ForegroundColor Green
        }
        else {
            Write-Warning "$Version installer returned exit code: $($Process.ExitCode)"
        }
    }
    catch {
        Write-Error "Failed to install $Version : $($_.Exception.Message)"
    }
    finally {
        Remove-Item $OutFile -Force -ErrorAction SilentlyContinue
    }
}

# =============================================================================
# Main Remediation
# =============================================================================
try {
    # 2015-2019 (Latest All-in-One)
    Install-VCRedist -Url "https://aka.ms/vs/17/release/vc_redist.x86.exe" -FileName "vc_redist.x86.exe" -Version "Visual C++ 2015-2022 x86"
    Install-VCRedist -Url "https://aka.ms/vs/17/release/vc_redist.x64.exe" -FileName "vc_redist.x64.exe" -Version "Visual C++ 2015-2022 x64"

    # Older versions (if needed)
    # Install-VCRedist -Url "https://download.microsoft.com/download/..." -FileName "..." -Version "..."

    # Success marker
    New-Item -Path "C:\Windows\CCM\Logs\VisualCRedist_Installed.done" -ItemType File -Force | Out-Null

    Write-Host "Visual C++ Redistributable remediation completed successfully." -ForegroundColor Green
    Stop-Transcript
    exit 0
}
catch {
    Write-Error "Remediation failed: $($_.Exception.Message)"
    Stop-Transcript
    exit 1
}
