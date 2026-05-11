# Deployment Best Practices

### Recommended Practices

1. **Always use System Context**
2. **Include proper logging** (Start-Transcript)
3. **Create registry tattoos** for detection
4. **Use detection markers** (`*.done` files)
5. **Support `-WhatIf`** where possible
6. **Test on multiple OS versions** (Win10 + Win11)

### Application Creation Tips

- Use **Script Installer** type in MECM
- Set proper detection rules
- Include uninstall scripts when applicable
- Add meaningful descriptions and publisher info

### Security & Maintenance

- Remove any hardcoded credentials or sensitive data
- Keep scripts modular and reusable
- Update documentation when making changes

---

Following these practices helps ensure reliable, maintainable enterprise deployments.
