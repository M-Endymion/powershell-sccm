# MacOS Scripts

This folder contains enterprise-focused scripts for **macOS provisioning, hardening, compliance, and management**.

Designed for hybrid environments (Intune, Jamf Pro, or mixed fleets).

---

### Scripts

| Script Name                          | Description                                                                 | Key Features |
|--------------------------------------|-----------------------------------------------------------------------------|--------------|
| `MacOS-Setup-and-Compliance.ps1`     | Main all-in-one tool for macOS setup and compliance auditing               | Homebrew install, User auditing, M365/Intune readiness, Jamf integration, HTML + JSON reports, Compliance scoring |

---

### Usage

```powershell
# Basic compliance check + report
./MacOS-Setup-and-Compliance.ps1

# Full setup (recommended for new devices)
./MacOS-Setup-and-Compliance.ps1 -FullSetup

# Run Jamf inventory update as well
./MacOS-Setup-and-Compliance.ps1 -FullSetup -RunJamfRecon
```

---

## Features

- System Information collection
- Homebrew installation + common tools & apps
- Local User Auditing (admin rights, enabled/disabled accounts)
- Microsoft 365 / Intune Readiness checks
- Jamf Pro status detection and optional jamf recon
- Security & Compliance checks (FileVault, Firewall, SIP, etc.)
- Compliance Score (0–100) with color-coded summary
- Professional HTML + JSON reports saved to Desktop

---

## Requirements

- macOS 12+ (Monterey or newer recommended)
- PowerShell 7+
- Administrative privileges (for some functions)
- Internet access (for Homebrew and tool installation)

---

## Ideal For

- macOS fleet onboarding / provisioning
- Compliance auditing for Intune or Jamf environments
- Security baseline enforcement
- Hybrid Windows + macOS management teams

---

## Future Scripts (Planned)

- Automated remediation options
- Configuration profiles deployment
- Microsoft Defender for Endpoint integration
- Custom policy enforcement

---

***Note:*** These scripts are designed to be safe and idempotent where possible. Always test in a non-production environment first.
