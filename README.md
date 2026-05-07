# powershell-sccm

**PowerShell scripts for Microsoft Endpoint Configuration Manager (SCCM / MECM)**

A collection of real-world automation, deployment, troubleshooting, reporting, OSD, and utility scripts developed for enterprise environments.

### Repository Structure

- **scripts/App-Install/** → Application installation and removal scripts
- **scripts/Windows-Updates/** → Windows Update installation and reset scripts
- **scripts/Reporting/** → Active Directory and inventory reporting scripts
- **scripts/OSD/** → Scripts used during Operating System Deployment (Task Sequences)
- **scripts/SCCM-Automation/** → Automation scripts for SCCM server-side tasks
- **scripts/SCCM-Queries/** → WQL queries for Collections and Reports
- **scripts/Tools/** → General troubleshooting and utility tools
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
- `Export-BuiltInAppsList.ps1`
- `Remove-BuiltInApps.ps1`
- `Replace-Wallpaper.ps1`
- `Set-StartMenuUserPins.ps1`
- `Set-PowerPlan.ps1`
- `Fix-IEError1509.ps1`
- `Set-CMTraceAsDefaultLogViewer.ps1`
- `New-OSDTattoo.ps1`

#### SCCM-Automation
- `Update-DriverPackageXML.ps1`

#### SCCM-Compliance
- `Get-RootCertificate.ps1` (Discovery)
- `Add-RootCertificate.ps1` (Remediation)

#### SCCM-Queries
- `Query-OldMSIExecVersion.wql`

#### Tools
- `Start-TSRerunTool.ps1` → GUI tool to re-run Task Sequence items

#### Templates
- `PS_Script_Template.ps1`

---

### How to Use

```powershell
# Example - OSD
.\scripts\OSD\Set-PowerPlan.ps1 -PowerPlan High

# Example - Troubleshooting Tool
.\scripts\Tools\Start-TSRerunTool.ps1
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

Some scripts converted and improved from original BAT/VBS scripts by SecretSquirrel, Matthew Teegarden, Nickolaj Andersen, Michael Niehaus, and others.

Maintained by M-Endymion

Feel free to open Issues or Pull Requests if you have improvements!

---

⭐ Star this repo if you find it useful!
