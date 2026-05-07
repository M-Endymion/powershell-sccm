# Legacy Scripts

This folder contains **older scripts** (VBScript, batch files, etc.) that have been replaced by modern PowerShell versions.

These scripts are kept for historical reference, rollback purposes, or for environments that still require them.

---

### Legacy Scripts

| Script Name                        | Original Purpose                                      | Modern Replacement                          |
|------------------------------------|-------------------------------------------------------|---------------------------------------------|
| `OSD-Tattoo-Legacy.vbs`            | Basic OSD tattooing (registry only)                  | `New-OSDTattoo.ps1`                         |

---

### Policy on Legacy Scripts

- These scripts are **no longer actively maintained**.
- They may contain outdated techniques, proprietary references, or less robust error handling.
- Use the modern PowerShell versions in the parent folders (`OSD/`, `App-Install/`, etc.) unless you have a specific reason to use the legacy version.
- Legacy scripts are kept mainly for:
  - Historical reference
  - Troubleshooting old Task Sequences
  - Rollback scenarios

---

### Recommendation

**Always prefer the modern PowerShell versions** located in the main script folders. They offer better logging, error handling, maintainability, and security.

If you need to retire or archive any legacy scripts, feel free to move them into subfolders or remove them.

---

This folder helps keep the repository clean while preserving the history of your automation journey.
