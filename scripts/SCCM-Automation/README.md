# SCCM-Automation Scripts

This folder contains PowerShell scripts designed for **automation, maintenance, and integration** tasks within Microsoft Endpoint Configuration Manager (SCCM / MECM).

These scripts are typically triggered by **Status Filter Rules**, scheduled tasks, or run manually by administrators.

---

### Scripts

| Script Name                        | Description                                                                 | Trigger / Use Case                     |
|------------------------------------|-----------------------------------------------------------------------------|----------------------------------------|
| `Update-DriverPackageXML.ps1`      | Exports all Driver Packages to XML and updates distribution points          | Status Filter Rule (Driver Package updated) |

---

### Purpose of This Folder

- Scripts that interact with the SCCM server (using the ConfigurationManager module)
- Automation of repetitive admin tasks
- Integration between SCCM and other systems (XML exports, reporting, etc.)
- Maintenance scripts for Drivers, Applications, Task Sequences, etc.

---

### How to Use

Most scripts in this folder require:
- The **ConfigurationManager** PowerShell module
- Execution on the SCCM Site Server (or a machine with the Admin Console installed)
- Appropriate permissions (usually SCCM Full Administrator)

**Example:**
```powershell
.\Update-DriverPackageXML.ps1
```

---

### Best Practices

- Test scripts in a non-production environment first
- Use Start-Transcript for logging
- Include clear success/failure markers when used in automated workflows
- Keep site-specific settings (Site Code, Server FQDN, etc.) at the top of each script

---

More automation scripts will be added here as they are modernized.
This folder helps keep your SCCM-specific automation organized and maintainable.

---
