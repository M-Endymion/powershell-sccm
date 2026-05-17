<div align="center">
  <img src="https://github.com/M-Endymion/powershell-sccm/blob/main/thumbnail.png" alt="PowerShell SCCM Portfolio" width="100%" />
</div>

<br>

# PowerShell SCCM / MECM Automation

**Production-ready PowerShell scripts for Microsoft Endpoint Configuration Manager (MECM/SCCM)**

Clean code • Strong logging • Real-world enterprise focus

![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white)
![MECM](https://img.shields.io/badge/MECM-0078D4?style=for-the-badge&logo=microsoft&logoColor=white)
![Windows](https://img.shields.io/badge/Windows-0078D4?style=for-the-badge&logo=windows&logoColor=white)
![macOS](https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=apple&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)

---

## Why These Scripts?

Modern replacement for legacy VBS scripts with better error handling, logging, `-WhatIf` support, and MECM-friendly detection rules. Used daily in enterprise environments for client health, application deployment, OS configuration, and hybrid management.

---

## Folder Structure

| Folder                    | Purpose                                                      |
|---------------------------|--------------------------------------------------------------|
| `scripts/App-Install`     | Application installation and uninstallation scripts          |
| `scripts/Client-Health`   | ConfigMgr client health checks, repair, and maintenance      |
| `scripts/OS-Configuration`| OS-level configuration, customization, and hardening         |
| `scripts/MacOS`           | macOS provisioning, compliance, Intune/Jamf readiness        |
| `scripts/Ubuntu`          | Ubuntu Server quick deployment (Docker, Portainer, etc.)     |
| `scripts/OSD`             | Operating System Deployment (Task Sequence) scripts          |
| `scripts/Reporting`       | Reporting and inventory scripts                              |
| `scripts/SCCM-Automation` | Server-side automation and Status Filter Rule scripts        |
| `scripts/SCCM-Compliance` | Compliance Item (Discovery + Remediation) scripts            |
| `scripts/Tools`           | Standalone utilities and GUI tools                           |
| `scripts/Utilities`       | General purpose helper scripts                               |
| `scripts/Templates`       | Script templates and best practices                          |

*(Legacy folder kept for reference only)*

---

## Featured Scripts & Tools

### **Client-Health** (Most Popular)
Comprehensive health checks and repair — modern replacement for `ConfigMgrStartup.vbs`

### **App-Install**
- `Install-Git.ps1`, `Install-7Zip.ps1`
- `Uninstall-AdobeCreativeCloud.ps1`
- `Uninstall-DellSupportAssist.ps1`
- `Remove-NewOutlook.ps1`

### **MacOS**
- `MacOS-Setup-and-Compliance.ps1` — Detailed system report, Homebrew tools, M365/Intune readiness, Jamf integration

### **Tools (GUI)**
- `Start-BatchInstall.ps1` — Interactive batch application installer
- `Start-TSRerunTool.ps1` — GUI for re-running Task Sequence steps

### **Utilities**
- `ConvertFrom-BatchScript.ps1` — Legacy batch → PowerShell converter
- `Ubuntu-Server-QuickDeploy.sh` — One-click homelab server setup

---

## How to Use

- **Run as System** context in MECM Applications or Task Sequences
- Many scripts support `-WhatIf`, `-Fix`, and `-Verbose`
- Logs written to `C:\Windows\CCM\Logs\` or custom path
- Registry tattoos under `HKLM:\SOFTWARE\Contoso\ApplicationTattoos\`

**Quick Start:** Clone the repo and explore the `Templates` folder for best practices.

---

## About the Author

**Jason Ray (M-Endymion)**  
IT Professional specializing in **MECM/SCCM**, PowerShell automation, hybrid endpoint management, and enterprise deployments.

This repository is my **professional portfolio** — every script is built for production use with focus on reliability and maintainability.

- **LinkedIn**: [Jason Ray](https://www.linkedin.com/in/jason-ray-mecm/)
- **Open to new opportunities** in Endpoint Management / Automation Engineering

---

**Last Updated:** May 17, 2026

---

## Best Practices Demonstrated
- Verb-Noun naming convention
- Comprehensive logging and error handling
- Proper MECM detection methods
- Cross-platform awareness (Windows + macOS)
