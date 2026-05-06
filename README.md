# powershell-sccm

**PowerShell scripts for Microsoft Endpoint Configuration Manager (SCCM / MECM)**

A collection of real-world automation scripts I’ve developed and used in enterprise environments.

### Main Categories

- **Software / Application Installation**
- **Windows Update Management & Fixes**
- **OS Configuration & Hardening**
- **Client Health & Remediation**
- **Reporting & Inventory**
- **Utilities & Helpers**

---

### Folder Structure

- `scripts/App-Install/` → Application deployment scripts
- `scripts/Windows-Updates/` → Update-related tasks and troubleshooting
- `scripts/OS-Configuration/` → OS settings, features, registry changes
- `scripts/Client-Health/` → SCCM client health checks and fixes
- `scripts/Reporting/` → Detailed reporting scripts
- `scripts/Utilities/` → General helper functions

---

### How to Use

All scripts are designed to run with **elevated (Administrator)** rights.

Example:
```powershell
# Run with verbose output
.\scripts\App-Install\Install-CompanySoftware.ps1 -ComputerName "PC001" -Verbose
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
