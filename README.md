# powershell-sccm

**PowerShell scripts for Microsoft Endpoint Configuration Manager (SCCM / MECM)**

A collection of automation, reporting, maintenance, and troubleshooting scripts I’ve written and used in enterprise environments.

### Purpose
These scripts help with:
- Automated software deployment and patching
- Hardware/software inventory reporting
- Client health checks and remediation
- Maintenance tasks (log cleanup, cache clearing, etc.)
- Compliance and security reporting

### Scripts Included (so far)

| Script Name                    | Description                                      | Status    |
|--------------------------------|--------------------------------------------------|-----------|
| `Update-ClientHealth.ps1`      | Checks and remediates SCCM client health         | Ready     |
| `Export-SoftwareInventory.ps1` | Exports detailed software inventory reports      | Ready     |
| `Clear-SCCMCache.ps1`          | Clears client cache safely                       | Ready     |
| `...`                          | ...                                              | ...       |

*(Add more rows as you upload scripts)*

---

### How to Use

Most scripts are designed to be run with administrative rights, either locally or remotely via PowerShell remoting.

Example:
```powershell
# Run a script with parameters
.\Update-ClientHealth.ps1 -ComputerName "PC001" -Verbose
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
