# SCCM-Compliance Scripts

This folder contains **Discovery** and **Remediation** script pairs used for SCCM/MECM Compliance Items and Baselines.

---

### Compliance Items

#### 1. Root Certificate

| Script Name                    | Type          | Purpose                                                                 |
|--------------------------------|---------------|-------------------------------------------------------------------------|
| `Get-RootCertificate.ps1`      | Discovery     | Checks for presence of a specific Root CA certificate (by Thumbprint)   |
| `Add-RootCertificate.ps1`      | Remediation   | Imports the Root CA certificate into Root and TrustedPublisher stores   |

#### 2. Visual C++ Redistributables

| Script Name                              | Type          | Purpose                                                                 |
|------------------------------------------|---------------|-------------------------------------------------------------------------|
| `Get-VisualCRedistributables.ps1`        | Discovery     | Checks for required Microsoft Visual C++ Redistributable versions       |
| `Install-VisualCRedistributables.ps1`    | Remediation   | Downloads and installs missing Visual C++ runtimes (2015–2022)          |

---

### How to Set Up a Compliance Item

#### General Steps:
1. Create a new **Compliance Item**
2. Paste the **Discovery Script**
3. Create a **Compliance Rule**:
   - Rule type: **Value**
   - Operator: **Equals**
   - Value: `Compliant`
4. Add the **Remediation Script**
5. Add the Compliance Item to a **Baseline** and deploy it

---

### Usage Examples

**Visual C++ Pair:**
- Discovery checks for required VC++ versions
- Remediation automatically downloads and installs missing ones

**Root Certificate Pair:**
- Discovery checks by Thumbprint (most reliable)
- Remediation imports the `.cer` file from the package

---

### Best Practices

- Use **Thumbprint** for certificate discovery (more reliable than Serial Number)
- Include required files (`.cer`, etc.) in the same package as the remediation script
- Test Compliance Items on a pilot collection first
- Use success marker files (`*.done`) when combining with Task Sequences

---

More Compliance Items (Discovery + Remediation pairs) will be added here as needed.
