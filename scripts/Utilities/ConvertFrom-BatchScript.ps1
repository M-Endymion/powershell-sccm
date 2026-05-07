<#
.SYNOPSIS
    Helps convert simple Batch (.bat/.cmd) scripts to PowerShell.

.DESCRIPTION
    Reads a .bat/.cmd file and generates a basic PowerShell version with comments.
    Best used as a starting point — manual review and improvements are still required.

.NOTES
    Author:      M-Endymion
    Version:     1.0
    Last Updated:2026-05-07
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$BatchFilePath,

    [string]$OutputPath = ""
)

if (-not (Test-Path $BatchFilePath)) {
    Write-Error "Batch file not found: $BatchFilePath"
    exit 1
}

$BatchContent = Get-Content $BatchFilePath -Raw
$BatchName = [System.IO.Path]::GetFileNameWithoutExtension($BatchFilePath)

if ([string]::IsNullOrEmpty($OutputPath)) {
    $OutputPath = Join-Path (Split-Path $BatchFilePath) "$($BatchName).ps1"
}

Write-Host "Converting $BatchFilePath to PowerShell..." -ForegroundColor Cyan

$PSContent = @"
<#
.SYNOPSIS
    Converted from: $BatchName.bat

.DESCRIPTION
    Auto-converted from batch script. Review and improve as needed.
#>

# =============================================================================
# Original Batch Script
# =============================================================================
<#
$BatchContent
#>

Write-Host "Starting converted script: $BatchName" -ForegroundColor Cyan

# =============================================================================
# TODO: Convert commands below
# =============================================================================

"@

# Basic conversions
$PSContent += $BatchContent -replace 'REM ', '# ' `
                           -replace '@ECHO OFF', 'Write-Host "Running $BatchName..."' `
                           -replace 'echo.', 'Write-Host ' `
                           -replace '%~dp0', '$PSScriptRoot\' `
                           -replace 'set ', '$' `
                           -replace '%(\w+)%', '$$$1' `
                           -replace 'call:', '# Function: ' `
                           -replace 'GOTO:EOF', 'return' `
                           -replace 'ping -n 2', 'Start-Sleep -Seconds 1'

$PSContent += "`n`nWrite-Host `"Conversion complete. Review TODO items.`" -ForegroundColor Green"

$PSContent | Out-File -FilePath $OutputPath -Encoding UTF8

Write-Host "PowerShell version saved to: $OutputPath" -ForegroundColor Green
Write-Host "Remember to review and clean up the converted script!" -ForegroundColor Yellow
