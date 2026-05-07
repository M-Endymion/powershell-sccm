# Client-Health Scripts

This folder contains scripts for **monitoring, maintaining, and repairing** the Microsoft Endpoint Configuration Manager (MECM/SCCM) client.

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

#### Utilities
| Script Name                              | Description                                                                 |
|------------------------------------------|-----------------------------------------------------------------------------|
| `Invoke-ConfigMgrLogMaintenance.ps1`     | Cleans up old ConfigMgr log files                                           |

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

---

### Best Practices

- Run as System context (ideal for Task Scheduler or during OSD)
- Most scripts support the ```-Fix``` parameter
- Logs are written to ```C:\Windows\CCM\Logs\```
- Success markers (```*.done``` files) are created for easy detection in MECM

___

### Original Inspiration

These scripts are modern replacements for parts of the classic ```ConfigMgrStartup.vbs``` by Jason Sandys.

They are broken into focused, maintainable modules rather than one giant script.
