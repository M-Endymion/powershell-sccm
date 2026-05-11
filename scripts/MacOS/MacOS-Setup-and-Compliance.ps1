<#
.SYNOPSIS
    MacOS Setup and Compliance Tool for Enterprise Environments.

.DESCRIPTION
    Gathers system information, installs/updates Homebrew + common tools,
    checks security compliance, and generates a nice HTML report.

.NOTES
    Author:      M-Endymion
    Version:     1.0
    Last Updated:2026-05-07
    Runs on:     macOS (PowerShell 7+)
#>

[CmdletBinding()]
param (
    [switch]$InstallTools,
    [switch]$ApplySecuritySettings,
    [switch]$GenerateReport = $true
)

# =============================================================================
# Configuration
# =============================================================================
$LogPath = "~/Library/Logs/MacOS-Setup.log"
$ReportPath = "~/Desktop/MacOS-Compliance-Report.html"

# Tools to install via Homebrew (easy to customize)
$Tools = @(
    "git", "wget", "curl", "jq", "yq",
    "mas", "oh-my-posh", "powershell/tap/powershell",
    "visual-studio-code", "iterm2", "raycast"
)

# =============================================================================
# Logging
# =============================================================================
Start-Transcript -Path $LogPath -Append
Write-Host "🚀 Starting MacOS Setup & Compliance Check" -ForegroundColor Cyan

# =============================================================================
# System Information
# =============================================================================
Write-Host "`n📋 Gathering System Information..." -ForegroundColor Cyan

$SystemInfo = @{
    Hostname          = hostname
    OSVersion         = sw_vers -productVersion
    OSBuild           = sw_vers -buildVersion
    Model             = system_profiler SPHardwareDataType | grep "Model Name"
    Chip              = system_profiler SPHardwareDataType | grep Chip
    Memory            = system_profiler SPHardwareDataType | grep Memory
    SerialNumber      = ioreg -l | grep IOPlatformSerialNumber | awk -F'"' '{print $4}'
    Date              = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
}

$SystemInfo | Format-Table -AutoSize

# =============================================================================
# Homebrew Check & Install
# =============================================================================
Write-Host "`n🍺 Checking Homebrew..." -ForegroundColor Cyan
if (-not (Get-Command brew -ErrorAction SilentlyContinue)) {
    Write-Host "Homebrew not found. Installing..." -ForegroundColor Yellow
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
} else {
    Write-Host "Homebrew is installed. Updating..." -ForegroundColor Green
    brew update --quiet
}

# =============================================================================
# Install Tools
# =============================================================================
if ($InstallTools) {
    Write-Host "`n📦 Installing common tools..." -ForegroundColor Cyan
    foreach ($tool in $Tools) {
        Write-Host "   Installing $tool..." -NoNewline
        brew install $tool --quiet 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) {
            Write-Host " Done" -ForegroundColor Green
        } else {
            Write-Host " Failed" -ForegroundColor Red
        }
    }
}

# =============================================================================
# Security & Compliance Checks
# =============================================================================
Write-Host "`n🔒 Running Security & Compliance Checks..." -ForegroundColor Cyan

$Compliance = @{
    FileVaultEnabled   = (fdesetup status | grep -c "FileVault is On") -gt 0
    FirewallEnabled    = (defaults read /Library/Preferences/com.apple.alf globalstate) -eq 1
    SIPEnabled         = (csrutil status | grep -c "enabled") -gt 0
    AutomaticUpdates   = (defaults read /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload) -eq 1
}

$Compliance | Format-Table -AutoSize

# =============================================================================
# Generate HTML Report
# =============================================================================
if ($GenerateReport) {
    Write-Host "`n📊 Generating Compliance Report..." -ForegroundColor Cyan

    $Html = @"
<!DOCTYPE html>
<html>
<head><title>MacOS Compliance Report - $($SystemInfo.Hostname)</title>
<style>body { font-family: Arial; margin: 40px; background: #f4f4f4; }</style>
</head>
<body>
    <h1>MacOS Compliance Report</h1>
    <p><strong>Generated:</strong> $(Get-Date)</p>
    <h2>System Information</h2>
    <pre>$($SystemInfo | ConvertTo-Json)</pre>
    <h2>Compliance Status</h2>
    <pre>$($Compliance | ConvertTo-Json)</pre>
</body>
</html>
"@

    $Html | Out-File -FilePath $ReportPath -Encoding UTF8
    Write-Host "✅ Report saved to: $ReportPath" -ForegroundColor Green
}

Write-Host "`n✅ MacOS Setup & Compliance Check Completed!" -ForegroundColor Green
Stop-Transcript
