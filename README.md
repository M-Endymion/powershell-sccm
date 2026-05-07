# powershell-sccm

**PowerShell scripts for Microsoft Endpoint Configuration Manager (SCCM / MECM)**

A collection of real-world automation, deployment, troubleshooting, reporting, OSD, and SCCM automation scripts developed for enterprise environments.

### Repository Structure

- **scripts/App-Install/** → Application installation and removal scripts
- **scripts/Windows-Updates/** → Windows Update installation and reset scripts
- **scripts/Reporting/** → Active Directory and inventory reporting scripts
- **scripts/OSD/** → Scripts used during Operating System Deployment (Task Sequences)
- **scripts/SCCM-Automation/** → Automation scripts for SCCM server-side tasks
- **scripts/SCCM-Queries/** → WQL queries for Collections and Reports
- **scripts/Templates/** → Reusable script templates

---

### Scripts Overview

#### App-Install
- `Install-7Zip.ps1`
- `Install-Git.ps1`
- `Install-MSTeams.ps1`
- `Install-SnippingToolAndPhotos.ps1`
- `Remove-NewOutlook.ps1`
- `Uninstall-DellSupportAssist.ps1`
- `Uninstall-Git.ps1`
- `Uninstall-SpreadsheetServerSuite.ps1`
- `Set-LockScreenImage.ps1`

#### Windows-Updates
- `Install-KB5003791.ps1`
- `Fix-HungWindowsUpdates.ps1`
- `Reset-WindowsUpdate.ps1`

#### Reporting
- `Get-ADComputerActiveLast120Days.ps1`
- `Get-ADComputerPasswordLastSet.ps1`
- `Get-ADTombstoneComputers.ps1`
- `Get-RemoteComputerInventory.ps1`

#### OSD
- `Fix-IEError1509.ps1`
- `Set-CMTraceAsDefaultLogViewer.ps1`
- `New-OSDTattoo.ps1`

#### SCCM-Automation
- `Update-DriverPackageXML.ps1` → Exports driver packages to XML and updates DPs

#### SCCM-Queries
- `Query-OldMSIExecVersion.wql`

#### Templates
- `PS_Script_Template.ps1`

---

### How to Use

All PowerShell scripts are designed to run with **Administrator** rights.

```powershell
# Example - OSD Script
.\scripts\OSD\New-OSDTattoo.ps1 -All

# Example - SCCM Automation
.\scripts\SCCM-Automation\Update-DriverPackageXML.ps1
```

---

### Requirements

- PowerShell 5.1 or PowerShell 7+
- Appropriate SCCM admin permissions
- SCCM / MECM environment (recommended for detection rules)
- Administrative privileges
- ActiveDirectory module (for reporting scripts)
- WinRM enabled (for remote inventory)

---

### Disclaimer

Test all scripts in a non-production environment first. Some scripts may need minor adjustments for your specific environment.

---

### Credits & Contact

Some scripts converted and improved from original BAT/VBS scripts by SecretSquirrel, Matthew Teegarden and others.
Maintained by M-Endymion

Feel free to open Issues or Pull Requests if you have improvements!

---

⭐ Star this repo if you find it useful!
