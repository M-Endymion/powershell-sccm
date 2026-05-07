<#
.SYNOPSIS
    Reports Active Directory computers that have been active (PasswordLastSet) within the last 120 days.

.DESCRIPTION
    Queries specified OUs for Windows client computers (excluding servers) and filters
    for machines whose computer account password was reset within the last 120 days.
    
    Useful for identifying currently active machines for inventory, licensing, or cleanup.

.NOTES
    Author: M-Endymion
    Version: 1.0
    Last Updated: 2026-05-06
    Requires: ActiveDirectory PowerShell module

.EXAMPLE
    .\Get-ADComputerActiveLast120Days.ps1

.EXAMPLE
    .\Get-ADComputerActiveLast120Days.ps1 -Days 90 -ExportCSV "C:\Temp\ActiveComputers.csv"
#>

[CmdletBinding()]
param (
    [int]$Days = 120,                                      # Number of days to look back
    [string]$DomainController = "",                        # Leave blank to use current DC
    [string]$ExportCSV = "",                               # Optional CSV export path
    [switch]$GridView = $true
)

# =============================================================================
# Configuration - Edit OUs as needed for your environment
# =============================================================================
$OUs = @(
    "OU=Managed Workstations,DC=contoso,DC=com",
    "OU=Restricted Computers,OU=Restricted,DC=contoso,DC=com",
    "CN=Computers,DC=contoso,DC=com"
)

# =============================================================================
# Main Script
# =============================================================================
try {
    $CutoffDate = (Get-Date).AddDays(-$Days)
    Write-Host "Finding computers active since $CutoffDate (last $Days days)..." -ForegroundColor Cyan

    $Computers = foreach ($OU in $OUs) {
        Get-ADComputer -SearchBase $OU `
                       -Filter { OperatingSystem -notlike "*server*" -and OperatingSystem -like "*windows*" } `
                       -Server $DomainController `
                       -Properties Name, OperatingSystem, PasswordLastSet, Enabled, CanonicalName, LastLogonDate |
        Where-Object { $_.PasswordLastSet -ge $CutoffDate } |
        Select-Object Name,
                      OperatingSystem,
                      @{Name='PasswordLastSet'; Expression={$_.PasswordLastSet}},
                      @{Name='PasswordAgeDays'; Expression={ if ($_.PasswordLastSet) { (Get-Date) - $_.PasswordLastSet | Select-Object -ExpandProperty Days } else { "Never" } }},
                      Enabled,
                      LastLogonDate,
                      CanonicalName
    }

    $Computers = $Computers | Sort-Object CanonicalName

    Write-Host "Found $($Computers.Count) active computer accounts." -ForegroundColor Green

    # Output options
    if ($ExportCSV) {
        $Computers | Export-Csv -Path $ExportCSV -NoTypeInformation
        Write-Host "Results exported to: $ExportCSV" -ForegroundColor Green
    }

    if ($GridView) {
        $Computers | Out-GridView -Title "Active AD Computers (Last $Days Days)"
    }
    else {
        $Computers | Format-Table -AutoSize
    }
}
catch {
    Write-Error "An error occurred: $($_.Exception.Message)"
    Write-Host "Ensure the ActiveDirectory module is installed and you have sufficient permissions." -ForegroundColor Yellow
}
