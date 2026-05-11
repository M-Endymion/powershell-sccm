# Script Usage Guide

This guide covers how to use the most common scripts in this repository.

---

### General Usage Notes

- Most scripts support `-WhatIf` where applicable
- Run as **System** context for best results
- Logs are usually written to `C:\Windows\CCM\Logs\`
- Registry tattoos are created under `HKLM:\SOFTWARE\Contoso\ApplicationTattoos\`

---

### Key Scripts

#### Client Health
- `Invoke-ConfigMgrClientHealthFull.ps1 -FullRepair`

#### OS Configuration
- `Set-PowerPlan.ps1 -PowerPlan HighPerformance`
- `Set-LockScreenImage.ps1`
- `Replace-Wallpaper.ps1`

#### App Install / Uninstall
- `Uninstall-AdobeCreativeCloud.ps1`
- `Remove-NewOutlook.ps1`

---

### Detection Methods (for MECM Applications)

Most scripts create a detection marker file:
- `C:\Windows\CCM\Logs\[ScriptName].done`

Use a **File Exists** detection rule pointing to that file.

---

**Tip**: Always test scripts thoroughly in a lab environment before production deployment.
