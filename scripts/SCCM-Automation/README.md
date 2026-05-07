# SCCM-Automation Scripts

This folder contains PowerShell scripts for **server-side automation, client health, maintenance, and troubleshooting** tasks in Microsoft Endpoint Configuration Manager (SCCM / MECM).

---

### Scripts

#### Client Health Orchestrators
| Script Name                                | Description                                                                 |
|--------------------------------------------|-----------------------------------------------------------------------------|
| `Invoke-ConfigMgrClientHealthFull.ps1`     | Main orchestrator — runs comprehensive client health checks and fixes       |
| `Invoke-ConfigMgrClientHealth.ps1`         | Flexible client health runner                                               |
| `Invoke-ConfigMgrClientMaintenance.ps1`    | Maintenance-focused orchestrator                                            |

#### Individual Health Checks
| Script Name                              | Description                                                                 |
|------------------------------------------|-----------------------------------------------------------------------------|
| `Check-ConfigMgrServices.ps1`            | Checks and fixes critical services (CCMExec, WMI, etc.)                     |
| `Check-ConfigMgrCache.ps1`               | Checks and sets the ConfigMgr client cache size                             |
| `Check-LocalAdminMembership.ps1`         | Checks and adds accounts to the local Administrators group                  |
| `Check-ClientAssignment.ps1`             | Verifies client site assignment                                             |
| `Check-ConfigMgrClientVersion.ps1`       | Checks client version and can trigger upgrade                               |
| `Check-ConfigMgrPrerequisites.ps1`       | Checks critical prerequisites (WMI, Admin$, etc.)                           |

#### Repair & Remediation
| Script Name                              | Description                                                                 |
|------------------------------------------|-----------------------------------------------------------------------------|
| `Repair-ConfigMgrClient.ps1`             | Performs a standard client repair                                           |
| `Repair-ConfigMgrClientFull.ps1`         | Full client reinstall (last resort)                                         |
| `Trigger-ConfigMgrClientReinstall.ps1`   | Triggers a fresh client reinstall                                           |
| `Install-ConfigMgrHotfixes.ps1`          | Automatically installs .msp hotfixes                                        |

#### Utilities
| Script Name                              | Description                                                                 |
|------------------------------------------|-----------------------------------------------------------------------------|
| `Invoke-ConfigMgrLogMaintenance.ps1`     | Cleans up old ConfigMgr log files                                           |

#### Automation
| Script Name                        | Description                                                                 | Trigger / Use Case                     |
|------------------------------------|-----------------------------------------------------------------------------|----------------------------------------|
| `Update-DriverPackageXML.ps1`      | Exports all Driver Packages to XML and updates distribution points          | Status Filter Rule                     |

---

### How to Use

**Full Health Check (Recommended):**
```powershell
.\Invoke-ConfigMgrClientHealthFull.ps1 -FullRepair
```
**Individual Checks:**
```powershell
.\Check-ConfigMgrServices.ps1 -Fix
.\Check-ConfigMgrCache.ps1 -Fix -DesiredCacheSizeMB 8192
```
**Driver Package Automation:**
```powershell
.\Update-DriverPackageXML.ps1
```

---

### Best Practices

- Run with System or Administrator context
- Use -FullRepair sparingly
- Schedule scripts via Task Scheduler or trigger via Status Filter Rules
- Monitor logs in C:\Windows\CCM\Logs\
- Test thoroughly before production use

---

### Original Inspiration

These scripts are modern replacements for parts of the classic ConfigMgrStartup.vbs by Jason Sandys.

They are broken into focused, maintainable modules rather than one giant script.

---

More automation scripts will be added here as they are modernized.

This folder helps keep your SCCM-specific automation organized and maintainable.

---
