# MacOS Scripts

This folder contains scripts and tools for **macOS administration, setup, and compliance** — primarily designed for enterprise environments using Microsoft Intune, Jamf, or hybrid management.

---

### Scripts

| Script Name                          | Description                                                                 | Status |
|--------------------------------------|-----------------------------------------------------------------------------|--------|
| `MacOS-Setup-and-Compliance.ps1`     | Main script: System info, Homebrew tools, security checks, and HTML report | Complete |

---

### Purpose

These scripts help bridge the gap between **Windows-centric** SCCM/MECM environments and **macOS** fleet management. They are especially useful for:

- Initial device provisioning
- Compliance auditing
- Standardization across Mac fleets
- Intune + Jamf hybrid environments

---

### Usage

Run with PowerShell 7+ on macOS:

```powershell
# Basic compliance check + report
./MacOS-Setup-and-Compliance.ps1

# Full setup (install tools + apply settings)
./MacOS-Setup-and-Compliance.ps1 -InstallTools -ApplySecuritySettings
```

---

## Requirements

- macOS 12+ (Monterey or newer recommended)
- PowerShell 7+
- Administrative privileges (for some functions)
- Internet access (for Homebrew and tool installation)

---

## Future Scripts (Planned)

- Set-MacOSSecurityBaseline.ps1
- Install-MacOSCorporateApps.ps1
- Invoke-MacOSIntuneCompliance.ps1
- Jamf-Integration-Tools.ps1

---

***Note:*** These scripts are designed to be safe and idempotent where possible. Always test in a non-production environment first.
