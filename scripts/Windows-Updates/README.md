# Windows-Updates Scripts

This folder contains PowerShell scripts for installing, managing, troubleshooting, and resetting Windows Updates.

### Scripts

| Script Name                        | Description                                                              | Category                    |
|------------------------------------|--------------------------------------------------------------------------|-----------------------------|
| `Install-KB5003791.ps1`            | Silently installs KB5003791 (x64) MSU package                            | Windows Update Install      |
| `Fix-HungWindowsUpdates.ps1`       | Resets Windows Update components (services + cache) to fix hung updates  | Troubleshooting / Reset     |
| `Reset-WindowsUpdate.ps1`          | Full Windows Update reset (clears cache, resets registry, restarts services) | Troubleshooting / Reset     |

---

### Usage Guidelines

- All scripts must be run with **Administrator** privileges.
- Designed for SCCM / MECM deployment and remediation.
- Scripts include detailed logging and detection markers.

### Examples

```powershell
# Run locally
.\Reset-WindowsUpdate.ps1

# Run remotely via PowerShell remoting
Invoke-Command -ComputerName "PC001" -FilePath ".\Reset-WindowsUpdate.ps1"
```

---
