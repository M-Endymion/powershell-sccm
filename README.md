# powershell-sccm

**PowerShell scripts for Microsoft Endpoint Configuration Manager (SCCM / MECM)**

A collection of real-world automation scripts developed for enterprise environments.

### Main Categories

- **Software / Application Installation & Removal**
- **Windows Update Management & Fixes**
- **OS Configuration & Hardening**
- **Client Health & Remediation**
- **Reporting & Inventory**
- **Utilities**

---

### Scripts Overview

#### App-Install
- `Remove-NewOutlook.ps1`
- `Uninstall-DellSupportAssist.ps1`

#### Windows-Updates
- `Install-KB5003791.ps1`

*(More scripts will be added over time)*

---

### How to Use

All scripts should be run with **Administrator** privileges.

```powershell
# Example local run
.\scripts\Windows-Updates\Install-KB5003791.ps1
```

---

### Requirements

- PowerShell 5.1 or PowerShell 7+
- Appropriate SCCM admin permissions
- Modules: ConfigurationManager, ActiveDirectory (when needed)

---

### Disclaimer

These scripts were written for use in a production environment. Always test in a non-production environment first.

---

### Credits & Contact

Credits & Contact

Maintained by M-Endymion

Feel free to open Issues or Pull Requests if you have improvements!

⭐ Star this repo if you find it useful!
