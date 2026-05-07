<#
.SYNOPSIS
    Gathers hardware and system inventory from one or more remote computers.

.DESCRIPTION
    Modern PowerShell replacement for the old inv.bat + inventoryT.vbs script.
    Collects Hardware (make/model/serial), OS, Disks, and Network information.

.NOTES
    Author: M-Endymion
    Version: 1.0
    Last Updated: 2026-05-06
    Requires: WinRM enabled on target computers + permissions

.EXAMPLE
    .\Get-RemoteComputerInventory.ps1 -ComputerName "PC001"

.EXAMPLE
    .\Get-RemoteComputerInventory.ps1 -ComputerName "PC001","PC002" -GridView
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true, Position=0)]
    [string[]]$ComputerName,

    [switch]$GridView,
    [string]$ExportCSV = ""
)

function Get-ComputerInventory {
    param([string]$Target)

    try {
        $CIMSession = New-CimSession -ComputerName $Target -ErrorAction Stop

        $Info = [PSCustomObject]@{
            ComputerName     = $Target
            Manufacturer     = (Get-CimInstance -CimSession $CIMSession -ClassName Win32_ComputerSystemProduct).Vendor
            Model            = (Get-CimInstance -CimSession $CIMSession -ClassName Win32_ComputerSystemProduct).Name
            SerialNumber     = (Get-CimInstance -CimSession $CIMSession -ClassName Win32_ComputerSystemProduct).IdentifyingNumber
            Processor        = (Get-CimInstance -CimSession $CIMSession -ClassName Win32_Processor).Name
            RAM_GB           = [math]::Round((Get-CimInstance -CimSession $CIMSession -ClassName Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)
            OperatingSystem  = (Get-CimInstance -CimSession $CIMSession -ClassName Win32_OperatingSystem).Caption
            OSVersion        = (Get-CimInstance -CimSession $CIMSession -ClassName Win32_OperatingSystem).Version
            InstallDate      = (Get-CimInstance -CimSession $CIMSession -ClassName Win32_OperatingSystem).InstallDate
            LastBootTime     = (Get-CimInstance -CimSession $CIMSession -ClassName Win32_OperatingSystem).LastBootUpTime
        }

        # Disk Information
        $Disks = Get-CimInstance -CimSession $CIMSession -ClassName Win32_LogicalDisk -Filter "DriveType=3" |
                 Select-Object DeviceID,
                               @{Name='SizeGB'; Expression={[math]::Round($_.Size/1GB,2)}},
                               @{Name='FreeGB'; Expression={[math]::Round($_.FreeSpace/1GB,2)}}

        # Network Adapters
        $Network = Get-CimInstance -CimSession $CIMSession -ClassName Win32_NetworkAdapter |
                   Where-Object { $_.PhysicalAdapter -and $_.MACAddress } |
                   Select-Object Name, MACAddress

        $Info | Add-Member -NotePropertyName Disks -NotePropertyValue $Disks
        $Info | Add-Member -NotePropertyName Network -NotePropertyValue $Network

        Remove-CimSession -CimSession $CIMSession
        return $Info
    }
    catch {
        Write-Warning "Failed to connect to $Target : $($_.Exception.Message)"
        return [PSCustomObject]@{ ComputerName = $Target; Status = "Failed"; Error = $_.Exception.Message }
    }
}

# =============================================================================
# Execution
# =============================================================================
Write-Host "Collecting inventory from $($ComputerName.Count) computer(s)..." -ForegroundColor Cyan

$Results = foreach ($PC in $ComputerName) {
    Get-ComputerInventory -Target $PC
}

# Output
if ($ExportCSV) {
    $Results | Export-Csv -Path $ExportCSV -NoTypeInformation
    Write-Host "Results exported to: $ExportCSV" -ForegroundColor Green
}

if ($GridView) {
    $Results | Out-GridView -Title "Remote Computer Inventory Report"
} else {
    $Results | Format-List
}
