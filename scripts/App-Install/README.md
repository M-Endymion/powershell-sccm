# App-Install Scripts

This folder contains PowerShell scripts related to **installing and removing** software/applications.

### Scripts

| Script Name                        | Description                                                                 | Category              |
|------------------------------------|-----------------------------------------------------------------------------|-----------------------|
| `Remove-NewOutlook.ps1`            | Removes the modern "New Outlook" AppX package and applies registry tattoo   | Application Removal   |
| `Uninstall-DellSupportAssist.ps1`  | Uninstalls Dell SupportAssist while preserving specific Business versions   | Application Removal   |
| `Install-Git.ps1`                  | Installs Git for Windows (standalone installer) with common components      | Application Install   |
| `Uninstall-Git.ps1`                | Uninstalls Git using official uninstaller with registry tattoo cleanup      | Application Removal   |

---

### Usage Guidelines

- All scripts must be run with **Administrator** privileges.
- Designed for SCCM / MECM deployment (including registry tattoos and detection markers).
- For installation scripts: The required installer `.exe` must be placed in the same folder as the script.

### Naming Convention
- Scripts follow the `Verb-Noun.ps1` standard (`Install-`, `Remove-`, `Uninstall-`, etc.).

### Examples

```powershell
# Run locally
.\Install-Git.ps1

# Run remotely
Invoke-Command -ComputerName "PC001" -FilePath ".\Uninstall-Git.ps1"
```

---
