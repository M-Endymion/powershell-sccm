# Example Application Deployment

This document provides a clean example of how to deploy scripts from this repository as **MECM Applications**.

---

## Example: Deploy "Set-PowerPlan.ps1" as an Application

### Application Properties

- **Name**: Set Power Plan - High Performance
- **Publisher**: M-Endymion
- **Version**: 1.0
- **Description**: Sets the active power plan to High Performance and creates detection tattoo

### Deployment Type

- **Type**: Script Installer
- **Install Program**:
  ```powershell
  powershell.exe -ExecutionPolicy Bypass -File "Set-PowerPlan.ps1" -PowerPlan HighPerformance
  ```
- Uninstall Program: (Optional - can be left blank or use a simple removal script)

### Detection Method
File Exists detection rule:

- Path: ```C:\Windows\CCM\Logs```
- File: ```PowerPlan_Set_HighPerformance.done```

OR Registry detection rule:

- Hive: ```HKEY_LOCAL_MACHINE```
- Key: ```SOFTWARE\Contoso\ApplicationTattoos\PowerPlan```
- Value: ```ActivePowerPlan```
- Data: ```HighPerformance```

---

### Recommended Best Practices

1. Always use System context
2. Include proper detection rules (file marker + registry tattoo)
3. Add meaningful descriptions
4. Test on multiple Windows versions (10 & 11)
5. Use ```-WhatIf``` support during testing

---

### Common Application Types in this Repo

- PowerShell Script Applications (most common)
- Batch / CMD Wrapper Applications
- Configuration-Only Applications (no files, just settings)

___

***Note:*** Adapt these examples to your environment. Always test thoroughly before deploying to production devices.

---
Last Updated: May 11, 2026
