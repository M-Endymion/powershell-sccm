<#
.SYNOPSIS
    Removes the new Microsoft Outlook (the modern AppX version) from Windows 11.

.DESCRIPTION
    This script uninstalls the new Outlook app (microsoft.outlookForWindows) and related packages.
    It also "tattoos" the registry to track that the removal has been performed (useful for SCCM detection rules).

.NOTES
    Author: M-Endymion
    Version: 1.0
    Created: $(Get-Date -Format "yyyy-MM-dd")
    Purpose: Enterprise deployment - Remove unwanted New Outlook app

.EXAMPLE
    # Run on local machine
    .\Remove-NewOutlook.ps1

.EXAMPLE
    # Run remotely via SCCM or Invoke-Command
    Invoke-Command -ComputerName "PC001" -ScriptBlock { .\Remove-NewOutlook.ps1 }
#>

[CmdletBinding(SupportsShouldProcess=$true)]
param (
    [switch]$Force
)

# =============================================================================
# Configuration
# =============================================================================
$AppNames = @(
    "Outlook (New)",
    "microsoft.outlookForWindows",
    "microsoft.windowscommunicationsapps"
)

$RegistryPath = "HKLM:\SOFTWARE\Contoso\ApplicationTattoos\NewOutlook"
$RegistryValueName = "UninstallNewOutlook"
$RegistryValue = 1

# =============================================================================
# Main Script
# =============================================================================
Write-Host "Starting removal of New Microsoft Outlook..." -ForegroundColor Cyan

# Get all installed AppX packages
$AppxPackages = Get-AppxPackage

foreach ($App in $AppNames) {
    $Package = $AppxPackages | Where-Object { $_.Name -like "*$App*" }

    if ($Package) {
        if ($PSCmdlet.ShouldProcess($Package.Name, "Remove-AppxPackage")) {
            Write-Host "Removing package: $($Package.Name)" -ForegroundColor Yellow
            try {
                Remove-AppxPackage -PackageFullName $Package.PackageFullName -ErrorAction Stop
                Write-Host "Successfully removed: $($Package.Name)" -ForegroundColor Green
            }
            catch {
                Write-Warning "Failed to remove $($Package.Name): $($_.Exception.Message)"
            }
        }
    }
    else {
        Write-Host "Package not found: $App" -ForegroundColor Gray
    }
}

# =============================================================================
# Refresh Start Menu
# =============================================================================
Write-Host "Refreshing Start Menu..." -ForegroundColor Cyan

try {
    # Best method - Restart Explorer
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
    Start-Process explorer.exe
    Write-Host "Start Menu refreshed successfully." -ForegroundColor Green
}
catch {
    Write-Warning "Failed to refresh Start Menu: $($_.Exception.Message)"
}

# =============================================================================
# Registry Tattoo (for SCCM detection / compliance)
# =============================================================================
try {
    # Create parent key if it doesn't exist
    if (-not (Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry key: $RegistryPath" -ForegroundColor Green
    }

    # Set tattoo value
    New-ItemProperty -Path $RegistryPath -Name $RegistryValueName -Value $RegistryValue -PropertyType DWORD -Force | Out-Null
    Write-Host "Registry tattoo applied successfully." -ForegroundColor Green
}
catch {
    Write-Warning "Failed to write registry tattoo: $($_.Exception.Message)"
}

Write-Host "New Outlook removal process completed." -ForegroundColor Cyan
