# OSD Scripts

This folder contains scripts specifically designed for use during **Operating System Deployment (OSD)** in Microsoft Endpoint Configuration Manager (SCCM / MECM).

These scripts are typically run as part of a Task Sequence.

---

### Scripts

| Script Name                          | Description                                                                 | Recommended Phase              |
|--------------------------------------|-----------------------------------------------------------------------------|--------------------------------|
| `Export-BuiltInAppsList.ps1`         | Exports currently installed Appx apps and Capabilities to text files        | Reference machine / Post OS    |
| `Remove-BuiltInApps.ps1`             | Removes built-in apps and capabilities based on text files                  | State Restore                  |
| `Fix-IEError1509.ps1`                | Removes problematic `iesqmdata_setup0.sqm` files                            | Post OS Apply                  |
| `Set-CMTraceAsDefaultLogViewer.ps1`  | Copies CMTrace.exe and sets it as default .log viewer                       | WinPE or State Restore         |
| `New-OSDTattoo.ps1`                  | Applies custom OSD tattoos (Registry + Environment Variables)               | State Restore                  |
| `Set-LockScreenImage.ps1`            | Sets custom lock screen image                                               | State Restore                  |

---

### Usage Instructions

#### 1. Export-BuiltInAppsList.ps1 + Remove-BuiltInApps.ps1 (Recommended Workflow)

**Step 1: Generate lists**
```powershell
# Run on a reference machine with the desired build
.\Export-BuiltInAppsList.ps1
```

---

Other Scripts

- `Set-CMTraceAsDefaultLogViewer.ps1`
  Best run early in the Task Sequence (after Apply Operating System).
  
- `New-OSDTattoo.ps1`
  Use Task Sequence variables starting with OSDTattoo_ (e.g. OSDTattoo_ImageVersion).
  
- `Set-LockScreenImage.ps1`
  Place your background.jpg (or update the script) in the same package.

---

### Best Practices for OSD Scripts

- Run with **System** context (highest privileges)
- Use `Continue on Error = No` for critical fixes
- Add success markers (`*.done` files) for conditional task sequence steps
- Keep scripts lightweight and fast
- Always test thoroughly in a lab environment

### Common OSD Use Cases
- Fixing known Windows setup issues
- Applying customizations (lock screen, start menu, etc.)
- Registry tweaks
- Driver / application post-install fixes
- Profile / user environment cleanup

---

**Tip**: Place any required files (`.jpg`, `.reg`, etc.) in the same package as the script so they are available during the task sequence.

More OSD scripts will be added here as they are cleaned and modernized.
