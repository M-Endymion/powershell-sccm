# App-Install Scripts

This folder contains scripts for **installing and uninstalling applications** via MECM/SCCM.

---

### Scripts

| Script Name                              | Description                                                                 | Type          |
|------------------------------------------|-----------------------------------------------------------------------------|---------------|
| `Install-Git.ps1`                        | Installs Git with custom components and registry tattoo                    | Installer     |
| `Uninstall-Git.ps1`                      | Uninstalls Git and cleans up registry tattoo                               | Uninstaller   |
| `Install-7Zip.ps1`                       | Installs 7-Zip (auto-detects x64/x86)                                      | Installer     |
| `Uninstall-AdobeCreativeCloud.ps1`       | Uninstalls all Adobe Creative Cloud apps using official uninstaller         | Uninstaller   |
| `Uninstall-DellSupportAssist.ps1`        | Uninstalls Dell SupportAssist while preserving Business versions            | Uninstaller   |
| `Remove-NewOutlook.ps1`                  | Removes the new Outlook app (Microsoft.OutlookForWindows)                   | Uninstaller   |
| `Install-MSTeams.ps1`                    | Installs Microsoft Teams (optimized for Amazon WorkSpaces)                 | Installer     |
| `Install-SnippingToolAndPhotos.ps1`      | Installs Snipping Tool + Microsoft Photos via winget                        | Installer     |

---

### Usage Examples

---

**Uninstall Adobe Creative Cloud:**
```powershell
.\Uninstall-AdobeCreativeCloud.ps1
```

---

**Install Git:**
```powershell
.\Install-Git.ps1
```

---

**Remove New Outlook:**
```powershell
.\Remove-NewOutlook.ps1
```

---

### Best Practices

- Place any required ```.exe```, ```.msi```, or ```.msu``` files in the same folder as the script when creating the SCCM Application
- All scripts create a registry tattoo under ```HKLM:\SOFTWARE\Contoso\ApplicationTattoos\```
- All scripts create a detection marker in ```C:\Windows\CCM\Logs\```
- Use ```-WhatIf``` to simulate actions where supported

---

More application install/uninstall scripts will be added here as needed.
