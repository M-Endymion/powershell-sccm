<#
.SYNOPSIS
    Advanced Event Log search with filtering and export options.

.DESCRIPTION
    Quickly search Application, System, Security, or custom logs with powerful filtering.

.NOTES
    Author:      M-Endymion
    Version:     1.0
    Last Updated:2026-05-07
#>

[CmdletBinding()]
param (
    [string]$LogName = "Application",
    [string]$Source,
    [int]$EventID,
    [string]$MessageContains,
    [int]$Newest = 100,
    [string]$Level = "Error",          # Error, Warning, Information
    [switch]$ExportCSV
)

$Filter = @{
    LogName = $LogName
    Newest  = $Newest
}

if ($Source) { $Filter.Source = $Source }
if ($EventID) { $Filter.ID = $EventID }

$Events = Get-WinEvent -FilterHashtable $Filter -ErrorAction SilentlyContinue

if ($MessageContains) {
    $Events = $Events | Where-Object { $_.Message -like "*$MessageContains*" }
}

if ($Level) {
    $LevelMap = @{ Error=2; Warning=3; Information=4 }
    if ($LevelMap.ContainsKey($Level)) {
        $Events = $Events | Where-Object { $_.Level -eq $LevelMap[$Level] }
    }
}

$Events = $Events | Select-Object TimeCreated, LevelDisplayName, ID, Source, Message

if ($Events) {
    $Events | Format-Table -AutoSize -Wrap
    Write-Host "`nFound $($Events.Count) matching events." -ForegroundColor Green
} else {
    Write-Host "No matching events found." -ForegroundColor Yellow
}

if ($ExportCSV) {
    $CSVPath = "C:\Windows\Temp\EventLog_Search_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
    $Events | Export-Csv -Path $CSVPath -NoTypeInformation
    Write-Host "Results exported to: $CSVPath" -ForegroundColor Green
}
