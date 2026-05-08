![PowerShell SCCM Portfolio](https://github.com/M-Endymion/powershell-sccm/blob/main/thumbnail.png)

# PowerShell SCCM / MECM Scripts

A professional collection of PowerShell scripts for **Microsoft Endpoint Configuration Manager** (SCCM / MECM) administration, deployment, customization, and troubleshooting.

---

## Folder Structure

| Folder                    | Purpose                                                      |
|---------------------------|--------------------------------------------------------------|
| `scripts/App-Install`     | Application installation and uninstallation scripts          |
| `scripts/Client-Health`   | ConfigMgr client health checks, repair, and maintenance      |
| `scripts/OS-Configuration`| OS-level configuration, customization, and hardening         |
| `scripts/OSD`             | Operating System Deployment (Task Sequence) scripts          |
| `scripts/Reporting`       | Reporting and inventory scripts                              |
| `scripts/SCCM-Automation` | Server-side automation and Status Filter Rule scripts        |
| `scripts/SCCM-Compliance` | Compliance Item (Discovery + Remediation) scripts            |
| `scripts/SCCM-Queries`    | WQL queries for collections and reports                      |
| `scripts/Tools`           | Standalone utilities and GUI tools                           |
| `scripts/Utilities`       | General purpose helper scripts                               |
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

### **Client-Health**
Comprehensive ConfigMgr client health & repair scripts (modern replacement for `ConfigMgrStartup.vbs`).

### **OS-Configuration**
- `Set-PowerPlan.ps1`
- `Set-LockScreenImage.ps1`
- `Replace-Wallpaper.ps1`

### **Utilities** (New)
- `ConvertFrom-BatchScript.ps1` — Helps convert old .bat files to PowerShell
- `Search-EventLog.ps1` — Advanced event log searching and filtering

### **Tools**
- `Start-TSRerunTool.ps1` — GUI for re-running Task Sequence steps
- `Start-BatchInstall.ps1` — Interactive batch installer

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

## About the Author

**M-Endymion** (Jason Ray)  
IT Professional specializing in Microsoft Endpoint Configuration Manager (MECM/SCCM), PowerShell automation, and enterprise deployment solutions.

This repository serves as a **public portfolio** of my work — demonstrating clean, production-ready, well-documented scripting for real-world enterprise environments.

- **LinkedIn**: [Jason Ray](https://www.linkedin.com/in/jason-ray-mecm/)
- **GitHub Handle**: M-Endymion

---

## Best Practices

- Always test scripts in a lab environment first
- Use consistent naming: `Verb-Noun.ps1`
- Include proper logging and detection methods for MECM

---

**Last Updated:** May 07, 2026
