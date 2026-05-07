<#
.SYNOPSIS
    Reports Active Directory computer accounts with their PasswordLastSet date.

.DESCRIPTION
    Queries specified Organizational Units (OUs) for Windows computers (excluding servers),
    retrieves key properties including PasswordLastSet age, and displays the results.
    
    Useful for identifying stale computer accounts, cleaning up Active Directory,
    and security/compliance reporting.

.NOTES
    Author: M-Endymion
    Version: 1.0
    Last Updated: 2026-05-06
    Requires: ActiveDirectory PowerShell module

.EXAMPLE
    .\Get-ADComputerPasswordAge.ps1

.EXAMPLE
    .\Get-ADComputerPasswordAge.ps1 -ExportCSV "C:\Temp\StaleComputers.csv"
#>

[CmdletBinding()]
param (
    [string]$DomainController = "",                    # Leave blank to use current DC
    [string]$ExportCSV = "",                           # Optional: Path to export CSV
    [switch]$GridView = $true                          # Show interactive GridView by default
)

# =============================================================================
# Configuration - Edit these OUs as needed
# =============================================================================
$OUs = @(
    "OU=Computers,OU=City1,OU=Region,DC=contoso,DC=com",
    "OU=Computers,OU=City2,OU=Region,DC=contoso,DC=com",
    "OU=TestComputers,DC=contoso,DC=com",
    "OU=Computers,DC=contoso,DC=com"
)

# =============================================================================
# Main Script
# =============================================================================
try {
    Write-Host "Querying Active Directory for computer accounts..." -ForegroundColor Cyan

    $Computers = foreach ($OU in $OUs) {
        Get-ADComputer -SearchBase $OU `
                       -Filter { OperatingSystem -notlike "*server*" -and OperatingSystem -like "*windows*" } `
                       -Server $DomainController `
                       -Properties Name, OperatingSystem, PasswordLastSet, Enabled, CanonicalName, LastLogonDate |
        Select-Object @{
            Name = 'Name'
            Expression = { $_.Name }
        },
        @{
            Name = 'OperatingSystem'
            Expression = { $_.OperatingSystem }
        },
        @{
            Name = 'PasswordLastSet'
            Expression = { $_.PasswordLastSet }
        },
        @{
            Name = 'PasswordAgeDays'
            Expression = { if ($_.PasswordLastSet) { (Get-Date) - $_.PasswordLastSet | Select-Object -ExpandProperty Days } else { "Never" } }
        },
        Enabled,
        LastLogonDate,
        CanonicalName
    }

    # Sort by CanonicalName
    $Computers = $Computers | Sort-Object CanonicalName

    Write-Host "Found $($Computers.Count) computer accounts." -ForegroundColor Green

    # Output options
    if ($ExportCSV) {
        $Computers | Export-Csv -Path $ExportCSV -NoTypeInformation
        Write-Host "Results exported to: $ExportCSV" -ForegroundColor Green
    }

    if ($GridView) {
        $Computers | Out-GridView -Title "AD Computers - Password Age Report"
    }
    else {
        $Computers | Format-Table -AutoSize
    }
}
catch {
    Write-Error "An error occurred: $($_.Exception.Message)"
    Write-Host "Make sure the ActiveDirectory module is installed and you have proper permissions." -ForegroundColor Yellow
}
