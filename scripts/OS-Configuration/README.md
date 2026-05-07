# OS-Configuration Scripts

This folder contains scripts for **operating system configuration**, hardening, and post-deployment settings.

---

### Current Scripts

*(This folder is currently empty — ready for new scripts)*

**Planned / Suggested Scripts:**
- `Set-PowerPlan.ps1` — Sets High Performance or Balanced power plan
- `Set-LockScreenImage.ps1` — Configures custom lock screen image
- `Replace-Wallpaper.ps1` — Replaces desktop wallpaper (including 4K variants)
- `Configure-EdgeSettings.ps1` — Applies Microsoft Edge policies
- `Disable-UnwantedServices.ps1` — Disables telemetry / unnecessary services
- `Set-WindowsUpdateSettings.ps1` — Configures Windows Update behavior
- `Enable-RDP.ps1` / `Disable-RDP.ps1` — Manages Remote Desktop settings

---

### Purpose

These scripts are typically run during **OSD Task Sequences** (State Restore phase) or as part of a baseline configuration Application.

---

### Best Practices

- Run in **System** context
- Most scripts should create a registry tattoo for detection
- Test thoroughly on both Windows 10 and Windows 11
- Use `-WhatIf` support where possible

---

More OS configuration scripts will be added here.
