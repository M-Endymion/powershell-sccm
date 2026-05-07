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
| `Set-StartMenuUserPins.ps1`          | Pins specified applications to the Start Menu for new users (via Active Setup) | State Restore                      |
| `Set-PowerPlan.ps1`                  | Sets Windows Power Plan (High Performance or Balanced)                      | WinPE or State Restore             |
| `Fix-IEError1509.ps1`                | Removes problematic `iesqmdata_setup0.sqm` files                            | Post OS Apply                      |
| `Set-CMTraceAsDefaultLogViewer.ps1`  | Copies CMTrace.exe and sets it as default .log viewer                       | WinPE or State Restore             |
| `New-OSDTattoo.ps1`                  | Applies custom OSD tattoos (Registry + Environment Variables)               | State Restore                      |
| `Set-LockScreenImage.ps1`            | Sets custom lock screen image                                               | State Restore                      |

---

### Usage Instructions

#### Set-PowerPlan.ps1
Sets the active power scheme.

```powershell
# High Performance (recommended for OSD)
.\Set-PowerPlan.ps1 -PowerPlan High

# Balanced
.\Set-PowerPlan.ps1 -PowerPlan Balanced
```

#### Set-StartMenuUserPins.ps1
Pins applications to the Start Menu for every new user.

**During Task Sequence (recommended):**
- Add a "Run PowerShell Script" step:
  - Script name: `Set-StartMenuUserPins.ps1`
  - Parameters: `-RunMode Stage`

Edit the `$AppsToPin` array in the script to change which apps are pinned.

#### Replace-Wallpaper.ps1
- Place your custom `img0.jpg` in the same folder as the script.
- (Optional) Create a `4K` subfolder with high-resolution files.

#### Export-BuiltInAppsList.ps1 + Remove-BuiltInApps.ps1
1. Run `Export-BuiltInAppsList.ps1` on a reference machine.
2. Edit the generated `appsXXXXX.txt` and `CapabilitiesXXXXX.txt` (remove items you want to **keep**).
3. Run `Remove-BuiltInApps.ps1` in the Task Sequence.

---

### Best Practices for OSD Scripts

- Run with **System** context
- Use `Continue on error = No` for critical fixes
- Include supporting files (images, text lists, CMTrace.exe, etc.) in the same package
- Always test thoroughly in a lab environment first

---

More OSD scripts will be added here as needed.
