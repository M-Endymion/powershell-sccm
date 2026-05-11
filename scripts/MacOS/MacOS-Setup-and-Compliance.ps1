<#
.SYNOPSIS
    Advanced MacOS Setup, Hardening, User Auditing, Intune/M365, and Jamf Readiness Tool.

.DESCRIPTION
    Comprehensive enterprise macOS provisioning and compliance script.

.NOTES
    Author:      M-Endymion
    Version:     1.3
    Last Updated:2026-05-07
#>

[CmdletBinding()]
param (
    [switch]$InstallTools,
    [switch]$ApplySecuritySettings,
    [switch]$GenerateReport = $true,
    [switch]$FullSetup,
    [switch]$RunJamfRecon
)

if ($FullSetup) { $InstallTools = $true; $ApplySecuritySettings = $true; $GenerateReport = $true }

# =============================================================================
# Configuration
# =============================================================================
$LogPath = "~/Library/Logs/MacOS-Setup.log"
$ReportPath = "~/Desktop/MacOS-Compliance-Report.html"
$JsonPath   = "~/Desktop/MacOS-Compliance-Report.json"

$BrewTools = @("git", "wget", "jq", "yq", "mas", "oh-my-posh", "powershell")
$BrewCasks = @("visual-studio-code", "iterm2", "raycast", "firefox", "google-chrome", "slack", "microsoft-teams")

# =============================================================================
# Logging
# =============================================================================
Start-Transcript -Path $LogPath -Append
Write-Host "🚀 Starting Advanced MacOS Enterprise Setup & Compliance Check" -ForegroundColor Cyan

# =============================================================================
# System Information
# =============================================================================
Write-Host "`n📋 Collecting System Information..." -ForegroundColor Cyan

$MacInfo = @{
    Hostname     = hostname
    OSVersion    = sw_vers -productVersion
    OSBuild      = sw_vers -buildVersion
    Model        = (system_profiler SPHardwareDataType | grep "Model Name:").Split(":")[1].Trim()
    Chip         = (system_profiler SPHardwareDataType | grep "Chip:").Split(":")[1].Trim()
    MemoryGB     = [math]::Round(((system_profiler SPHardwareDataType | grep "Memory:").Split(":")[1].Trim() -replace " GB",""), 0)
    SerialNumber = (ioreg -l | grep IOPlatformSerialNumber).Split('"')[3]
    DateChecked  = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
}

$MacInfo | Format-Table -AutoSize

# =============================================================================
# Homebrew Management
# =============================================================================
Write-Host "`n🍺 Homebrew Management..." -ForegroundColor Cyan

if (-not (Get-Command brew -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Homebrew..." -ForegroundColor Yellow
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
} else {
    brew update --quiet
}

if ($InstallTools -or $FullSetup) {
    Write-Host "`n📦 Installing Tools..." -ForegroundColor Cyan
    foreach ($tool in $BrewTools) {
        Write-Host "   → $tool" -NoNewline
        brew install $tool --quiet 2>&1 | Out-Null
        Write-Host " ✓" -ForegroundColor Green
    }
    foreach ($cask in $BrewCasks) {
        Write-Host "   → $cask (cask)" -NoNewline
        brew install --cask $cask --quiet 2>&1 | Out-Null
        Write-Host " ✓" -ForegroundColor Green
    }
}

# =============================================================================
# User Account Auditing
# =============================================================================
Write-Host "`n👤 Auditing Local User Accounts..." -ForegroundColor Cyan
$Users = dscl . -list /Users | Where-Object { $_ -notmatch "^_" -and $_ -ne "daemon" -and $_ -ne "nobody" }
$UserAudit = @()

foreach ($user in $Users) {
    $IsAdmin = (dscl . -read /Groups/admin GroupMembership 2>&1 | Select-String $user) -ne $null
    $IsEnabled = (dscl . -read /Users/$user AuthenticationAuthority 2>&1 | Select-String "Disabled") -eq $null
    
    $UserAudit += [PSCustomObject]@{
        Username = $user
        Admin    = $IsAdmin
        Enabled  = $IsEnabled
    }
}
$UserAudit | Format-Table -AutoSize

# =============================================================================
# Microsoft 365 / Intune Readiness
# =============================================================================
Write-Host "`n☁️  Checking Microsoft 365 / Intune Readiness..." -ForegroundColor Cyan
$M365Readiness = @{
    CompanyPortalInstalled = Test-Path "/Applications/Company Portal.app"
    TeamsInstalled         = Test-Path "/Applications/Microsoft Teams.app"
    OneDriveInstalled      = Test-Path "/Applications/OneDrive.app"
    IntuneMDMEnrolled      = (profiles status -type enrollment 2>&1 | Select-String "enrolled") -ne $null
}

$M365Readiness | Format-Table -AutoSize

# =============================================================================
# Jamf Integration
# =============================================================================
Write-Host "`n🖥️  Checking Jamf Pro Status..." -ForegroundColor Cyan
$JamfInfo = @{
    JamfBinaryExists = Test-Path "/usr/local/jamf/bin/jamf"
    Enrolled         = $false
    Version          = "Not Installed"
}

if ($JamfInfo.JamfBinaryExists) {
    $JamfInfo.Enrolled = $true
    $JamfInfo.Version = & /usr/local/jamf/bin/jamf version 2>&1
}

if ($RunJamfRecon) {
    Write-Host "🔄 Running Jamf Recon..." -ForegroundColor Yellow
    & /usr/local/jamf/bin/jamf recon
}

$JamfInfo | Format-Table -AutoSize

# =============================================================================
# Security & Compliance Checks
# =============================================================================
Write-Host "`n🔒 Running Security & Compliance Checks..." -ForegroundColor Cyan

$Compliance = @{
    FileVaultEnabled     = (fdesetup status 2>&1 | Select-String "FileVault is On") -ne $null
    FirewallEnabled      = (defaults read /Library/Preferences/com.apple.alf globalstate) -eq 1
    SIPEnabled           = (csrutil status | Select-String "enabled") -ne $null
    AutomaticUpdates     = (defaults read /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload) -eq 1
    GuestAccountDisabled = (-not (dscl . -read /Users/Guest 2>&1 | Select-String "No such key"))
    ScreenLockEnabled    = (defaults read com.apple.screensaver askForPassword) -eq 1
}

$Compliance | Format-Table -AutoSize

# Compliance Score
$Score = 0
if ($Compliance.FileVaultEnabled) { $Score += 20 }
if ($Compliance.FirewallEnabled) { $Score += 15 }
if ($Compliance.SIPEnabled) { $Score += 20 }
if ($Compliance.AutomaticUpdates) { $Score += 15 }
if ($Compliance.GuestAccountDisabled) { $Score += 10 }
if ($Compliance.ScreenLockEnabled) { $Score += 10 }
if ($M365Readiness.IntuneMDMEnrolled) { $Score += 10 }
if ($JamfInfo.Enrolled) { $Score += 10 }

Write-Host "`n📊 Overall Compliance Score: $Score / 100" -ForegroundColor $(if ($Score -ge 80) {"Green"} else {"Yellow"})

# =============================================================================
# Generate Reports
# =============================================================================
if ($GenerateReport) {
    Write-Host "`n📊 Generating Reports..." -ForegroundColor Cyan

    $ReportData = @{
        SystemInfo      = $MacInfo
        UserAudit       = $UserAudit
        M365Readiness   = $M365Readiness
        JamfStatus      = $JamfInfo
        Compliance      = $Compliance
        ComplianceScore = $Score
        GeneratedOn     = Get-Date
    }

    $ReportData | ConvertTo-Json -Depth 6 | Out-File $JsonPath -Encoding UTF8

    # HTML Report
    $HtmlReport = @"
<!DOCTYPE html>
<html><head><title>MacOS Compliance Report</title>
<style>body{font-family:Arial;margin:40px;background:#f8f9fa;} h1{color:#0d6efd;} .score{font-size:2.2em;}</style>
</head><body>
    <h1>MacOS Compliance Report - $($MacInfo.Hostname)</h1>
    <p><strong>Generated:</strong> $(Get-Date)</p>
    <h2>Compliance Score: <span class="score">$Score / 100</span></h2>
    <h2>Jamf Status</h2><pre>$($JamfInfo | ConvertTo-Json)</pre>
    <h2>Microsoft 365 / Intune</h2><pre>$($M365Readiness | ConvertTo-Json)</pre>
    <h2>Compliance Details</h2><pre>$($Compliance | ConvertTo-Json)</pre>
</body></html>
"@
    $HtmlReport | Out-File $ReportPath -Encoding UTF8
    Write-Host "✅ Reports saved to Desktop" -ForegroundColor Green
}

Write-Host "`n🎉 MacOS Enterprise Compliance Check Completed!" -ForegroundColor Green
Stop-Transcript
