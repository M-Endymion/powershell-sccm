# SCCM / MECM Queries

This folder contains **WQL Queries** (Windows Query Language) used in Microsoft Endpoint Configuration Manager (SCCM / MECM).

These queries are typically used for:
- Creating **Collections**
- Building **Reports**
- Custom detection rules
- Identifying systems that need remediation

---

### Queries

| File Name                              | Description                                                                 | Use Case                          |
|----------------------------------------|-----------------------------------------------------------------------------|-----------------------------------|
| `Query-OldMSIExecVersion.wql`          | Finds computers with outdated `msiexec.exe` version (< 3.1.4000.2435)       | Windows Installer remediation     |

---

### How to Use These Queries

1. Open the **SCCM Console**
2. Go to **Monitoring** → **Queries** (or directly in a Collection query)
3. Create a new Query
4. Paste the contents of the `.wql` file
5. Adjust column names or criteria as needed

### Tips

- Most queries use `SMS_R_System` joined with inventory classes (`SMS_G_System_*`)
- Always test queries in a small collection first
- You can convert many of these into PowerShell scripts using the `ConfigurationManager` module

---

**Want more queries?**  
Feel free to add any other WQL queries you use for collections, reports, or compliance.

This folder helps keep your SCCM-specific queries organized and documented.
