# Utilities Scripts

This folder contains **general-purpose** PowerShell scripts and helper tools that don’t fit neatly into other specific categories.

---

### Scripts

| Script Name                        | Description                                                                 | Use Case |
|------------------------------------|-----------------------------------------------------------------------------|----------|
| `ConvertFrom-BatchScript.ps1`      | Helps convert legacy .bat/.cmd files to PowerShell (starting point only)    | Migration / Modernization |
| `Search-EventLog.ps1`              | Advanced Event Log searching with powerful filtering and export options     | Troubleshooting |

---

### Usage Examples

**Convert a Batch Script:**
```powershell
.\ConvertFrom-BatchScript.ps1 -BatchFilePath "C:\Scripts\OldInstall.bat"
```
**Search Event Logs:**
```powershell
# Basic usage
.\Search-EventLog.ps1 -LogName Application -Level Error -Newest 50

# Advanced usage
.\Search-EventLog.ps1 -LogName System -Source "Microsoft-Windows-GroupPolicy" -EventID 7016 -ExportCSV
```

---

### Best Practices

- ```ConvertFrom-BatchScript.ps1``` is a helper tool — always review and improve the generated script.
- Search-EventLog.ps1 is very useful for troubleshooting during OSD or client health checks.
- Keep general utilities here so they don’t clutter more specialized folders.

---

### Suggested Future Scripts

- ```Get-RemoteComputerInventory.ps1```
- ```Test-NetworkConnectivity.ps1```
- ```Export-SystemInfo.ps1```
- ```Clean-TempFiles.ps1```

---

This folder serves as a catch-all for useful, reusable tools.

---
