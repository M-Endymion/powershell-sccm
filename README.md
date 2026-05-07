# powershell-sccm

**PowerShell scripts for Microsoft Endpoint Configuration Manager (SCCM / MECM)**

A collection of real-world automation, deployment, and troubleshooting scripts developed for enterprise environments.

### Main Categories

- **Software / Application Installation & Removal**
- **Windows Update Management & Fixes**
- **OS Configuration & Hardening** *(coming soon)*
- **Client Health & Remediation**
- **Reporting & Inventory**
- **Utilities**

---

### Scripts Overview

#### App-Install
| Script Name                              | Description                                                                 |
|------------------------------------------|-----------------------------------------------------------------------------|
| `Install-Git.ps1`                        | Installs Git for Windows (standalone)                                       |
| `Install-MSTeams.ps1`                    | Installs Microsoft Teams (per-machine mode – great for WorkSpaces/VDI)     |
| `Install-SnippingToolAndPhotos.ps1`      | Installs Snipping Tool + Microsoft Photos via winget                        |
| `Remove-NewOutlook.ps1`                  | Removes the new Outlook AppX version                                        |
| `Uninstall-DellSupportAssist.ps1`        | Uninstalls Dell SupportAssist (preserves Business versions)                 |
| `Uninstall-Git.ps1`                      | Uninstalls Git with cleanup                                                 |
| `Uninstall-SpreadsheetServerSuite.ps1`   | Uninstalls insightsoftware Spreadsheet Server Suite                         |

#### Windows-Updates
| Script Name                        | Description                                                              |
|------------------------------------|--------------------------------------------------------------------------|
| `Install-KB5003791.ps1`            | Silently installs KB5003791 MSU package                                  |
| `Fix-HungWindowsUpdates.ps1`       | Full reset of Windows Update components to fix hung/stuck updates        |
| `Reset-WindowsUpdate.ps1`          | Clears cache, resets registry, restarts services                         |

---

### How to Use

All scripts are designed to run with **Administrator** rights.

```powershell
# Run locally
.\scripts\App-Install\Install-MSTeams.ps1

# Run remotely
Invoke-Command -ComputerName "PC001" -FilePath ".\scripts\Windows-Updates\Reset-WindowsUpdate.ps1"
```

---

### Requirements

- PowerShell 5.1 or PowerShell 7+
- Appropriate SCCM admin permissions
- SCCM / MECM environment (recommended for detection rules)

---

### Disclaimer

Test all scripts in a non-production environment first. Some scripts may need minor adjustments for your specific environment.

---

### Credits & Contact

Maintained by M-Endymion

Feel free to open Issues or Pull Requests if you have improvements!

⭐ Star this repo if you find it useful!
