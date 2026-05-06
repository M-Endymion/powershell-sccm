# Windows-Updates Scripts

This folder contains PowerShell scripts for installing, managing, and troubleshooting Windows Updates.

### Scripts

| Script Name                    | Description                                           | Category             |
|--------------------------------|-------------------------------------------------------|----------------------|
| `Install-KB5003791.ps1`        | Silently installs KB5003791 (x64) MSU package         | Windows Update       |

---

### Usage Guidelines

- Run with **Administrator** rights.
- Scripts are designed for SCCM / MECM deployment.
- Most include logging and detection markers.

### Examples

```powershell
# Run locally
.\Install-KB5003791.ps1

# Run remotely
Invoke-Command -ComputerName "PC001" -FilePath ".\Install-KB5003791.ps1"
```

---
