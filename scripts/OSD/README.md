# OSD Scripts

This folder contains scripts specifically designed for use during **Operating System Deployment (OSD)** in Microsoft Endpoint Configuration Manager (SCCM / MECM).

These scripts are typically run as part of a Task Sequence (e.g., after the "Apply Operating System" step, in WinPE, or during the "State Restore" phase).

---

### Scripts

| Script Name                    | Description                                                                 | Recommended Run Phase      |
|--------------------------------|-----------------------------------------------------------------------------|----------------------------|
| `Fix-IEError1509.ps1`          | Removes `iesqmdata_setup0.sqm` files that cause Error 1509 during profile creation | Post OS Apply / State Restore |

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
