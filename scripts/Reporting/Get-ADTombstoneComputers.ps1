<#
.SYNOPSIS
    Reports computers in the Tombstone (or Quarantine) OU with their PasswordLastSet age.

.DESCRIPTION
    Specifically queries the Tombstone Computers OU (or any specified OU) to help identify
    stale or decommissioned computer accounts. Useful for AD cleanup and auditing.

.NOTES
    Author: M-Endymion
    Version: 1.0
    Last Updated: 2026-05-06
    Requires: ActiveDirectory PowerShell module

.EXAMPLE
    .\Get-ADTombstoneComputers.ps1

.EXAMPLE
    .\Get-ADTombstoneComputers.ps1 -ExportCSV "C:\Temp\TombstoneComputers.csv"
#>

[CmdletBinding()]
param (
    [string]$TombstoneOU = "OU=Tombstone Computers,DC=contoso,DC=com",   # Change as needed
    [string]$DomainController = "",                                      # Leave blank to use current DC
    [string]$ExportCSV = "",                                             # Optional CSV export
    [switch]$GridView = $true
)

# =============================================================================
# Main Script
# =============================================================================
try {
    Write-Host "Querying Tombstone Computers OU..." -ForegroundColor Cyan

    $Computers = Get-ADComputer -SearchBase $TombstoneOU `
                                -Filter { OperatingSystem -notlike "*server*" -and OperatingSystem -like "*windows*" } `
                                -Server $DomainController `
                                -Properties Name, OperatingSystem, PasswordLastSet, Enabled, CanonicalName, LastLogonDate |
               Select-Object Name,
                             OperatingSystem,
                             @{Name='PasswordLastSet'; Expression={$_.PasswordLastSet}},
                             @{Name='PasswordAgeDays'; Expression={ 
                                 if ($_.PasswordLastSet) { 
                                     (Get-Date - $_.PasswordLastSet).Days 
                                 } else { "Never" } 
                             }},
                             Enabled,
                             LastLogonDate,
                             CanonicalName |
               Sort-Object CanonicalName

    Write-Host "Found $($Computers.Count) computers in Tombstone OU." -ForegroundColor Green

    # Output options
    if ($ExportCSV) {
        $Computers | Export-Csv -Path $ExportCSV -NoTypeInformation
        Write-Host "Results exported to: $ExportCSV" -ForegroundColor Green
    }

    if ($GridView) {
        $Computers | Out-GridView -Title "Tombstone Computers - PasswordLastSet Report"
    }
    else {
        $Computers | Format-Table -AutoSize
    }
}
catch {
    Write-Error "Failed to query Active Directory: $($_.Exception.Message)"
    Write-Host "Make sure the specified OU exists and you have permission to read it." -ForegroundColor Yellow
}
