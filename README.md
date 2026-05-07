# powershell-sccm

**PowerShell scripts for Microsoft Endpoint Configuration Manager (SCCM / MECM)**

A collection of real-world automation, deployment, troubleshooting, and reporting scripts developed for enterprise environments.

### Repository Structure

- **scripts/App-Install/** → Application installation and removal scripts
- **scripts/Windows-Updates/** → Windows Update installation and reset scripts
- **scripts/Reporting/** → Active Directory and inventory reporting scripts
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

#### Windows-Updates
- `Install-KB5003791.ps1`
- `Fix-HungWindowsUpdates.ps1`
- `Reset-WindowsUpdate.ps1`

#### Reporting
- `Get-ADComputerActiveLast120Days.ps1`
- `Get-ADComputerPasswordLastSet.ps1`
- `Get-ADTombstoneComputers.ps1`
- `Get-RemoteComputerInventory.ps1`

#### Templates
- `PS_Script_Template.ps1` → Modern reusable template with logging and error handling

---

### How to Use

All scripts are designed to run with **Administrator** rights.

```powershell
# Example
.\scripts\App-Install\Install-7Zip.ps1

# Remote inventory
.\scripts\Reporting\Get-RemoteComputerInventory.ps1 -ComputerName "PC001" -GridView
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

Some scripts converted and improved from original BAT/VBS scripts by SecretSquirrel and others.
Maintained by M-Endymion
Maintained by M-Endymion

Feel free to open Issues or Pull Requests if you have improvements!

---

⭐ Star this repo if you find it useful!
