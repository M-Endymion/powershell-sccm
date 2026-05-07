# Tools Scripts

This folder contains **standalone utility tools** and GUI applications that help with troubleshooting, maintenance, and day-to-day SCCM/MECM administration.

---

### Scripts

| Script Name                        | Description                                                                 | Type          |
|------------------------------------|-----------------------------------------------------------------------------|---------------|
| `Start-TSRerunTool.ps1`            | GUI tool to find, delete, and re-run Task Sequence scheduled items          | GUI Utility   |
| `Start-BatchInstall.ps1`           | Interactive batch installer with persistent settings and progress display   | Interactive Tool |

---

### Usage

---

#### Start-TSRerunTool.ps1
```powershell
.\Start-TSRerunTool.ps1
```

### Features:

- Search by Package ID on local or remote computers
- View scheduled items in the CCM Scheduler
- Delete specific scheduled items
- Restart the SMS Agent (CCMExec) service

### Common Use Cases:

- Forcing a failed Task Sequence step to retry
- Re-running Application or Package deployments
- Troubleshooting stuck Task Sequence policies

---

### Start-BatchInstall.ps1
```powershell
.\Start-BatchInstall.ps1
```
This tool provides a menu-driven installation experience with the following options:

- Install Type (Server/Client)
- Installation Size (Full/Regular/Mini)
- Show ReadMe when finished

Settings are automatically saved between runs.

---

### Best Practices

- Run with administrative privileges
- Remote functionality requires WinRM and appropriate permissions
- Use cautiously in production environments

---

More tools and utilities will be added here as they are developed or modernized.
