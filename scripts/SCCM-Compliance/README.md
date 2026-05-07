# SCCM-Compliance Scripts

This folder contains **Discovery** and **Remediation** scripts used for SCCM/MECM Compliance Items and Baselines.

---

### Root Certificate Compliance Item

| Script Name                    | Type          | Purpose                                                                 |
|--------------------------------|---------------|-------------------------------------------------------------------------|
| `Get-RootCertificate.ps1`      | Discovery     | Checks if the specified Root CA certificate exists                      |
| `Add-RootCertificate.ps1`      | Remediation   | Imports the Root CA certificate into Root and TrustedPublisher stores   |

---

### How to Set Up in SCCM / MECM

#### 1. Create the Compliance Item

**Discovery Script** (`Get-RootCertificate.ps1`):
- Use the script from this folder.
- Set the parameter `-CertificateThumbprint` to your certificate's thumbprint.

**Compliance Rule**:
- Rule type: **Value**
- Operator: **Equals**
- Value: `Compliant`

#### 2. Create the Remediation Script

**Remediation Script** (`Add-RootCertificate.ps1`):
- Set the parameter: `-CertificatePath "InternalRootCA.cer"`
- Make sure the `.cer` file is included in the same package as the script.

#### 3. Create a Baseline

- Add the Compliance Item to a new Baseline
- Deploy the Baseline to your target collections

---

### Usage Examples

**Discovery Script:**
```powershell
.\Get-RootCertificate.ps1 -CertificateThumbprint "A1B2C3D4E5F67890123456789ABCDEF012345678"
```

**Remediation Script:**
```powershell
.\Add-RootCertificate.ps1 -CertificatePath ".\InternalRootCA.cer"
```

---

### Best Practices

- Use Thumbprint for discovery (more reliable than Serial Number)
- Always include the .cer file in the same package as the remediation script
- Test the Compliance Item on a pilot collection first
- Use success marker files (*.done) for conditional Task Sequence steps if needed

---

More Compliance Items (Discovery + Remediation pairs) will be added here as needed.
This structure makes it easy to maintain and audit your SCCM compliance configuration.
