# Script Templates

This folder contains reusable templates to help maintain consistency across all scripts in this repository.

### Available Templates

| File Name                        | Description                                                                 |
|----------------------------------|-----------------------------------------------------------------------------|
| `PS_Script_Template.ps1`         | Modern, clean PowerShell script template with built-in logging, error handling, and best practices |

---

### How to Use the Template

1. Copy `PS_Script_Template.ps1` and rename it to match your new script (e.g. `Install-Something.ps1`).
2. Update the `.SYNOPSIS`, `.DESCRIPTION`, `.NOTES`, and `.EXAMPLE` sections.
3. Fill in the parameters and main script logic.

### Why This Template?

- Uses `Start-Transcript` for reliable logging (no external modules required)
- Consistent structure and formatting
- Good error handling with `try/catch/finally`
- Easy to read and maintain
- Professional appearance for sharing or job portfolios

### Best Practices When Using This Template

- Always include clear `.SYNOPSIS` and `.EXAMPLE` sections
- Use `Write-Log` function for important messages
- Add proper parameter validation when needed
- Test thoroughly before deploying via SCCM/MECM

---

**Feel free to create additional templates** (e.g., for functions, modules, or GUI tools) as your collection grows.
