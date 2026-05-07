# Tools Scripts

This folder contains **standalone utility tools** and GUI applications that help with troubleshooting, maintenance, and day-to-day SCCM/MECM administration.

---

### Scripts

| Script Name                    | Description                                                                 | Type          |
|--------------------------------|-----------------------------------------------------------------------------|---------------|
| `Start-TSRerunTool.ps1`        | GUI tool to find, delete, and re-run Task Sequence scheduled items          | GUI Utility   |

---

### Purpose of This Folder

- General purpose troubleshooting tools
- GUI-based utilities for common SCCM tasks
- Scripts that don't fit neatly into OSD, Reporting, or Automation categories

---

### How to Use

#### Start-TSRerunTool.ps1

A helpful GUI tool when you need to force a Task Sequence step to re-run.

**Usage:**
```powershell
.\Start-TSRerunTool.ps1
```

---

### Features:

- Search by Package ID on local or remote computers
- View scheduled items in the CCM Scheduler
- Delete specific scheduled items
- Restart the SMS Agent (CCMExec) service

---

### Common Use Cases:

- Forcing a failed Task Sequence step to retry
- Re-running Application or Package deployments
- Troubleshooting stuck Task Sequence policies

---

### Best Practices

- Run with administrative privileges
- Remote functionality requires WinRM and appropriate permissions
- Use cautiously in production environments

---

More tools and utilities will be added here as they are developed or modernized.
