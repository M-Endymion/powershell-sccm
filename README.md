# PowerShell SCCM / MECM Scripts

A professional collection of PowerShell scripts for **Microsoft Endpoint Configuration Manager** (SCCM / MECM) administration, deployment, and troubleshooting.

Created and maintained by **M-Endymion**.

---

## Folder Structure

| Folder                    | Purpose                                                      |
|---------------------------|--------------------------------------------------------------|
| `scripts/App-Install`     | Application installation and uninstallation scripts          |
| `scripts/Client-Health`   | ConfigMgr client health checks, repair, and maintenance      |
| `scripts/OS-Configuration`| OS-level configuration and hardening scripts                 |
| `scripts/OSD`             | Operating System Deployment (Task Sequence) scripts          |
| `scripts/Reporting`       | Reporting and inventory scripts                              |
| `scripts/SCCM-Automation` | Server-side automation and Status Filter Rule scripts        |
| `scripts/SCCM-Compliance` | Compliance Item (Discovery + Remediation) scripts            |
| `scripts/SCCM-Queries`    | WQL queries for collections and reports                      |
| `scripts/Tools`           | Standalone utilities and GUI tools                           |
| `scripts/Utilities`       | General purpose utilities                                    |
| `scripts/Legacy`          | Archived/old scripts (for reference only)                    |
| `scripts/Templates`       | Script templates and best practice examples                  |

---

## Featured Folders & Scripts

### **App-Install**
- `Install-Git.ps1`, `Uninstall-Git.ps1`
- `Install-7Zip.ps1`
- `Uninstall-AdobeCreativeCloud.ps1`
- `Uninstall-DellSupportAssist.ps1`
- `Remove-NewOutlook.ps1`
- And more...

### **Client-Health** (New)
Comprehensive ConfigMgr client health & repair scripts (modern replacement for `ConfigMgrStartup.vbs`).

### **OSD**
Scripts used during Operating System Deployment (Task Sequences).

### **Tools**
- `Start-TSRerunTool.ps1` — GUI for re-running Task Sequence steps
- `Start-BatchInstall.ps1` — Interactive installer with persistent settings

### **SCCM-Automation**
- `Update-DriverPackageXML.ps1`
- `Install-ConfigMgrHotfixes.ps1`

---

## How to Use

Most scripts are designed to be deployed via **MECM Applications** or run as **Task Sequence steps**.

- Run with **System** context when possible
- Many scripts support `-WhatIf` and `-Fix` parameters
- Logs are typically written to `C:\Windows\CCM\Logs\`
- Registry tattoos are created under `HKLM:\SOFTWARE\Contoso\ApplicationTattoos\`

---

## Best Practices

- Always test scripts in a lab environment first
- Use consistent naming: `Verb-Noun.ps1`
- Include proper logging and detection methods for MECM
- Remove any proprietary information before sharing

---

## Contributions & Feedback

This repository is used as a **professional portfolio** showcasing clean, production-ready PowerShell scripting for enterprise environments.

Feel free to suggest new scripts or improvements!

---

**Last Updated:** May 07, 2026
