# App-Install Scripts

This folder contains PowerShell scripts related to **installing and removing** software/applications.

### Scripts

| Script Name                    | Description                                                      | Category                  |
|--------------------------------|------------------------------------------------------------------|---------------------------|
| `Remove-NewOutlook.ps1`        | Removes the modern "New Outlook" AppX package + registry tattoo | Application Removal       |

---

### Usage Guidelines

- Run scripts with **Administrator** privileges.
- Most scripts are designed for use with SCCM / MECM (Intune or traditional).
- Registry "tattoos" are used for detection rules and compliance reporting.

### Naming Convention
- All scripts follow `Verb-Noun.ps1` format (e.g. `Install-`, `Remove-`, `Update-`).
- Use clear, descriptive names.

### Example
```powershell
# Remove New Outlook locally
.\Remove-NewOutlook.ps1

# Run remotely
Invoke-Command -ComputerName "PC001" -FilePath ".\Remove-NewOutlook.ps1"
```

---
