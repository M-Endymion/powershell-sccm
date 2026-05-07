<#
.SYNOPSIS
    Reports Active Directory computer accounts with PasswordLastSet information.

.DESCRIPTION
    Queries one or more Organizational Units for Windows client computers (excluding servers)
    and returns key properties including PasswordLastSet date and age.
    
    Useful for AD cleanup, stale computer detection, and security reporting.

.NOTES
    Author: M-Endymion
    Version: 1.0
    Last Updated: 2026-05-06
    Requires: ActiveDirectory PowerShell module

.EXAMPLE
    .\Get-ADComputerPasswordLastSet.ps1

.EXAMPLE
    .\Get-ADComputerPasswordLastSet.ps1 -DaysOld 180 -ExportCSV "C:\Temp\StaleComputers.csv"
#>

[CmdletBinding()]
param (
    [int]$DaysOld = 0,                    # 0 = show all, >0 = filter older than X days
    [string]$DomainController = "",       # Leave blank for automatic
    [string]$ExportCSV = "",              # Optional CSV export
    [switch]$GridView = $true
)

# =============================================================================
# Configuration - Add or remove OUs as needed
# =============================================================================
$OUs = @(
    "OU=Managed Workstations,DC=contoso,DC=com",
    "OU=Computers,OU=Event,OU=Restricted,DC=contoso,DC=com",
    "OU=Restricted Computers,OU=Restricted,DC=contoso,DC=com",
    "CN=Computers,DC=contoso,DC=com"
)

# =============================================================================
# Main Script
# =============================================================================
try {
    Write-Host "Querying Active Directory computers..." -ForegroundColor Cyan

    $Computers = foreach ($OU in $OUs) {
        Get-ADComputer -SearchBase $OU `
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
                      CanonicalName
    }

    # Optional age filter
    if ($DaysOld -gt 0) {
        $Cutoff = (Get-Date).AddDays(-$DaysOld)
        $Computers = $Computers | Where-Object { $_.PasswordLastSet -le $Cutoff }
        Write-Host "Filtering for computers older than $DaysOld days." -ForegroundColor Yellow
    }

    $Computers = $Computers | Sort-Object CanonicalName

    Write-Host "Found $($Computers.Count) computer accounts." -ForegroundColor Green

    # Output options
    if ($ExportCSV) {
        $Computers | Export-Csv -Path $ExportCSV -NoTypeInformation
        Write-Host "Exported to: $ExportCSV" -ForegroundColor Green
    }

    if ($GridView) {
        $title = if ($DaysOld -gt 0) { "Computers with Password Older than $DaysOld Days" } else { "All AD Computers - PasswordLastSet Report" }
        $Computers | Out-GridView -Title $title
    }
    else {
        $Computers | Format-Table -AutoSize
    }
}
catch {
    Write-Error "Failed to query Active Directory: $($_.Exception.Message)"
    Write-Host "Make sure the ActiveDirectory module is installed." -ForegroundColor Yellow
}
