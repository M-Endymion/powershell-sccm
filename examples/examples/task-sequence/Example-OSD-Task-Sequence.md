# Example OSD Task Sequence

This is a clean, generalized example of a modern Windows 10/11 Operating System Deployment (OSD) Task Sequence.

It is provided as a reference only — all proprietary information has been removed.

---

## High-Level Structure

| Phase | Group / Step | Purpose |
|-------|--------------|---------|
| 1     | Initialization | Set timeouts, reboot delay, variables |
| 2     | Install Operating System | Partition disk, apply WIM, copy tools |
| 3     | Gather Information | Collect hardware info, set computer name |
| 4     | Drivers | Apply model-specific drivers |
| 5     | Windows Settings | Apply customizations, tweaks, power settings |
| 6     | Applications | Install core software |
| 7     | Configuration Manager Client | Install/ConfigMgr client |
| 8     | Final Customizations | Certificates, security tools, wallpaper, etc. |
| 9     | Final Restart | Complete the build |

---

## Detailed Task Sequence Steps (Generic Example)

### 1. Initialization
- Set Error Timeout
- Set Reboot Delay

### 2. Install Operating System
- Restart in Windows PE
- Partition Disk 0 (BIOS / UEFI conditional)
- Apply Operating System
- Copy CMTrace.exe

### 3. Gather Information
- Use MDT Toolkit Package
- Gather local data
- Set Computer Name (e.g., based on Serial Number)

### 4. Drivers
- Apply model-specific driver packages
- Conditional WMI queries for different hardware models

### 5. Windows Settings & Customizations
- Apply custom Windows settings
- Remove built-in Microsoft apps
- Configure Start Menu & Taskbar
- Set default file associations
- Replace Wallpaper + Lock Screen
- Configure Power Settings
- Disable unwanted features

### 6. Applications
- Microsoft Office
- Common enterprise applications
- Security solutions

### 7. Configuration Manager Client
- Install/ConfigMgr client
- Apply Network Settings

### 8. Final Steps
- Install Certificates
- OSD Tattoo (registry information)
- Final restart

---

## Best Practices Demonstrated

- Conditional steps for BIOS vs UEFI
- Model-specific driver handling
- Use of MDT Toolkit for information gathering
- Clear separation of concerns (Drivers, Settings, Applications)
- Use of splash screens for user feedback
- Registry tattooing for compliance tracking

---

**Note**: This is a generalized example based on real-world OSD task sequences. Always adapt it to your specific environment and test thoroughly in a lab before production use.

**Last Updated:** May 07, 2026
