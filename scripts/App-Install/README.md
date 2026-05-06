# App-Install Scripts

This folder contains PowerShell scripts related to **installing and removing** software/applications.

### Scripts

| Script Name                          | Description                                                                 | Category              |
|--------------------------------------|-----------------------------------------------------------------------------|-----------------------|
| `Remove-NewOutlook.ps1`              | Removes the modern "New Outlook" AppX package and applies registry tattoo   | Application Removal   |
| `Uninstall-DellSupportAssist.ps1`    | Uninstalls Dell SupportAssist while preserving specific Business versions   | Application Removal   |

---

### Usage Guidelines

- All scripts must be run with **Administrator** privileges.
- Designed for use with SCCM / MECM (including proper detection markers / tattoos).
- Most scripts include robust logging for troubleshooting.

### Naming Convention
- Scripts follow the `Verb-Noun.ps1` standard (e.g. `Install-`, `Remove-`, `Uninstall-`, `Update-`).
- Clear, descriptive names with no version numbers in filenames.

### Examples

```powershell
# Run locally
.\Remove-NewOutlook.ps1

# Run remotely via SCCM or PowerShell remoting
Invoke-Command -ComputerName "PC001" -FilePath ".\Uninstall-DellSupportAssist.ps1"
```

---
