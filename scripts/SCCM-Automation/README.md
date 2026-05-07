# SCCM-Automation Scripts

This folder contains **server-side automation** and specialized scripts for Microsoft Endpoint Configuration Manager (MECM/SCCM).

Client health related scripts have been moved to the `Client-Health` folder for better organization.

---

### Current Scripts

| Script Name                        | Description                                                                 | Use Case                              |
|------------------------------------|-----------------------------------------------------------------------------|---------------------------------------|
| `Update-DriverPackageXML.ps1`      | Exports Driver Packages to XML and updates Distribution Points              | Status Filter Rule                    |
| `Install-ConfigMgrHotfixes.ps1`    | Automatically installs .msp hotfixes using ccmsetup                        | Client Health / Maintenance           |

---

### How to Use

**Driver Package Automation** (triggered by Status Filter Rule):
```powershell
.\Update-DriverPackageXML.ps1
```
**Install Hotfixes:**
```powershell
.\Install-ConfigMgrHotfixes.ps1 -Fix
```

---

### Folder Purpose

- Server-side automation scripts
- Scripts that run on the SCCM site server or are triggered by server events
- Client-facing health scripts have been moved to ```../Client-Health/```

---

### Best Practices

- ```Update-DriverPackageXML.ps1``` works best when called from a Status Filter Rule
- Run scripts with administrative privileges
- Check logs in ```C:\Windows\CCM\Logs\``` (on clients) or the server execution logs
- Test thoroughly before production use

---

### Original Inspiration

These scripts are modern replacements for parts of the classic ```ConfigMgrStartup.vbs``` by Jason Sandys.

They are broken into focused, maintainable modules rather than one giant script.

---

This folder will be used for future server-side automation scripts.

---
