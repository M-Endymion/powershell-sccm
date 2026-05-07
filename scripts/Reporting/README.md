# Reporting Scripts

This folder contains PowerShell scripts for reporting, inventory, and analysis — primarily focused on Active Directory and system information.

### Scripts

| Script Name                          | Description                                                                 | Purpose                     |
|--------------------------------------|-----------------------------------------------------------------------------|-----------------------------|
| `Get-ADComputerPasswordAge.ps1`      | Queries AD computers (non-servers) and shows PasswordLastSet age            | AD Cleanup / Security       |

---

### Usage

Most reporting scripts require the **ActiveDirectory** PowerShell module (RSAT tools).

```powershell
# Run with interactive GridView
.\Get-ADComputerPasswordAge.ps1

# Export to CSV
.\Get-ADComputerPasswordAge.ps1 -ExportCSV "C:\Temp\ComputerPasswordAge.csv"
```

---

### Common Use Cases

Finding stale computer accounts

Security / compliance reporting

Active Directory hygiene and cleanup

---

