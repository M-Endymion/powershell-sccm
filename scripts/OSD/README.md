# OSD Scripts

This folder contains scripts specifically designed for use during **Operating System Deployment (OSD)** in Microsoft Endpoint Configuration Manager (SCCM / MECM).

These scripts are typically run as part of a Task Sequence.

---

### Scripts

| Script Name                          | Description                                                                 | Recommended Phase                  |
|--------------------------------------|-----------------------------------------------------------------------------|------------------------------------|
| `Export-BuiltInAppsList.ps1`         | Exports installed Appx apps and Capabilities to text files                  | Reference machine / Post OS        |
| `Remove-BuiltInApps.ps1`             | Removes built-in apps and capabilities based on text files                  | State Restore                      |
| `Replace-Wallpaper.ps1`              | Replaces default Windows wallpaper (standard + 4K versions)                 | State Restore                      |
| `Fix-IEError1509.ps1`                | Removes problematic `iesqmdata_setup0.sqm` files                            | Post OS Apply                      |
| `Set-CMTraceAsDefaultLogViewer.ps1`  | Copies CMTrace.exe and sets it as default .log viewer                       | WinPE or State Restore             |
| `New-OSDTattoo.ps1`                  | Applies custom OSD tattoos (Registry + Environment Variables)               | State Restore                      |
| `Set-LockScreenImage.ps1`            | Sets custom lock screen image                                               | State Restore                      |

---

### Usage Instructions

#### Replace-Wallpaper.ps1
- Place your custom `img0.jpg` in the same folder as the script.
- (Optional) Create a subfolder named `4K` and add your high-resolution files (e.g. `img0_3840x2160.jpg`, `img0_2560x1600.jpg`, etc.).
- Add the script to your Task Sequence (System context).

#### Export-BuiltInAppsList.ps1 + Remove-BuiltInApps.ps1 (Recommended Workflow)
1. Run `Export-BuiltInAppsList.ps1` on a reference machine.
2. Edit the generated `appsXXXXX.txt` and `CapabilitiesXXXXX.txt` files (remove items you want to **keep**).
3. Run `Remove-BuiltInApps.ps1` during the Task Sequence.

---

### Best Practices for OSD Scripts

- Run with **System** context (highest privileges)
- Use `Continue on error = No` for critical fixes
- Include supporting files (`.jpg`, `.txt`, `CMTrace.exe`, etc.) in the same package
- Always test thoroughly in a lab environment

---

More OSD scripts will be added here as needed.
