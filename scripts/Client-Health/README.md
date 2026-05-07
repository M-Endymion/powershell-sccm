# Client-Health Scripts

This folder contains scripts for **monitoring, maintaining, and repairing** the Microsoft Endpoint Configuration Manager (MECM/SCCM) client.

---

### Scripts

| Script Name                                | Description                                                                 |
|--------------------------------------------|-----------------------------------------------------------------------------|
| `Invoke-ConfigMgrClientHealthFull.ps1`     | **Main orchestrator** — runs all health checks and fixes                    |
| `Invoke-ConfigMgrClientHealth.ps1`         | Flexible health runner                                                      |
| `Invoke-ConfigMgrClientMaintenance.ps1`    | Maintenance-focused orchestrator                                            |
| `Check-ConfigMgrServices.ps1`              | Checks and repairs critical services (CCMExec, WMI)                         |
| `Check-ConfigMgrCache.ps1`                 | Validates and sets client cache size                                        |
| `Check-LocalAdminMembership.ps1`           | Ensures required accounts are in local Administrators group                 |
| `Check-ClientAssignment.ps1`               | Verifies correct site assignment                                            |
| `Check-ConfigMgrClientVersion.ps1`         | Checks client version and can trigger upgrade                               |
| `Check-ConfigMgrPrerequisites.ps1`         | Checks WMI, Admin$ share, and other prerequisites                          |
| `Repair-ConfigMgrClient.ps1`               | Standard client repair                                                      |
| `Repair-ConfigMgrClientFull.ps1`           | Full client reinstall (last resort)                                         |
| `Trigger-ConfigMgrClientReinstall.ps1`     | Triggers a complete client reinstall                                        |
| `Install-ConfigMgrHotfixes.ps1`            | Installs .msp hotfixes                                                      |
| `Invoke-ConfigMgrLogMaintenance.ps1`       | Cleans up old client log files                                              |

---

### Recommended Usage

**Run Full Health Check:**
```powershell
.\Invoke-ConfigMgrClientHealthFull.ps1 -FullRepair
```

**Run Individual Check:**
```powershell
.\Check-ConfigMgrServices.ps1 -Fix
```

---

### Best Practices

- Run as System context (ideal for Task Scheduler or during OSD)
- Most scripts support the ```-Fix``` parameter
- Logs are written to ```C:\Windows\CCM\Logs\```
- Success markers (```*.done``` files) are created for easy detection in MECM

___

These scripts are modern replacements for the old ```ConfigMgrStartup.vbs```.
