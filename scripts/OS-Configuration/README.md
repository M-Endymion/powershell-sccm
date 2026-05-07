# OS-Configuration Scripts

This folder contains scripts for **operating system configuration**, customization, and hardening — typically run during **OSD Task Sequences** (State Restore phase) or as baseline configuration Applications.

---

### Scripts

| Script Name                    | Description                                                                 | Key Features |
|--------------------------------|-----------------------------------------------------------------------------|--------------|
| `Set-PowerPlan.ps1`            | Sets the active Windows Power Plan (High Performance or Balanced)           | Registry tattoo, supports `-WhatIf` |
| `Set-LockScreenImage.ps1`      | Sets a custom Lock Screen image                                             | Copies image + applies policy |
| `Replace-Wallpaper.ps1`        | Replaces default desktop wallpaper (standard + 4K variants)                | Takes ownership, handles 4K folder |

---

### Usage Examples

**Set High Performance Power Plan:**
```powershell
.\Set-PowerPlan.ps1 -PowerPlan HighPerformance
```
**Set Custom Lock Screen:**
```powershell
.\Set-LockScreenImage.ps1 -ImageName "LockScreen.jpg"
```
***Replace Wallpaper (with 4K support):***
```powershell
.\Replace-Wallpaper.ps1
```
Place ```img0.jpg``` and a ```4K``` folder (with resolution variants) in the same directory as the script.

---

### Best Practices

- Run in **System** context (recommended for OSD)
- All scripts create a registry tattoo under ```HKLM:\SOFTWARE\Contoso\ApplicationTattoos\```
- All scripts create a detection marker in ```C:\Windows\CCM\Logs\```
- Place required image files in the same folder as the script when packaging for SCCM
- Test on both Windows 10 and Windows 11

---

### Suggested Future Scripts

- Configure-EdgeSettings.ps1
- Disable-UnwantedServices.ps1
- Set-WindowsUpdateSettings.ps1
- Enable-RDP.ps1

---

This folder is dedicated to post-OS setup and customization tasks.

---
