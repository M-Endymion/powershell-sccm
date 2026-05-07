# Reporting Scripts

This folder contains PowerShell scripts for reporting, inventory, and analysis tasks — mainly focused on Active Directory and remote system information.

### Scripts

| Script Name                              | Description                                                                 | Purpose                          |
|------------------------------------------|-----------------------------------------------------------------------------|----------------------------------|
| `Get-ADComputerPasswordLastSet.ps1`      | Reports AD computers with PasswordLastSet and age                           | AD Cleanup / Stale Detection     |
| `Get-ADComputerActiveLast120Days.ps1`    | Shows computers active in the last 120 days                                 | Active Machine Inventory         |
| `Get-ADTombstoneComputers.ps1`           | Reports computers in the Tombstone OU                                       | Decommissioned / Quarantine      |
| `Get-RemoteComputerInventory.ps1`        | Gathers hardware, OS, disk, and network info from remote computers          | Hardware / System Inventory      |

---

### How to Use `Get-RemoteComputerInventory.ps1`

This is the modern replacement for the old `inv.bat` + `inventoryT.vbs` script.

```powershell
# 1. Basic usage - Single computer
.\Get-RemoteComputerInventory.ps1 -ComputerName "PC001"

# 2. Multiple computers with interactive GridView (recommended)
.\Get-RemoteComputerInventory.ps1 -ComputerName "PC001","PC002","PC003" -GridView

# 3. Export results to CSV
.\Get-RemoteComputerInventory.ps1 -ComputerName "PC001" -ExportCSV "C:\Temp\Inventory_Report.csv"

# 4. Run against many computers from a text file
$Computers = Get-Content "C:\Temp\computers.txt"
.\Get-RemoteComputerInventory.ps1 -ComputerName $Computers -GridView
```

---

### Requirements:

WinRM must be enabled on target computers (Enable-PSRemoting)

You need administrative rights on the remote machines

Works best on Windows 10/11 and Server 2016+

---

### Other Reporting Scripts

Most other scripts in this folder can be run simply with:

```powershell
.\Get-ADComputerPasswordLastSet.ps1
```

---
