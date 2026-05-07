<#
.SYNOPSIS
    Discovery script - Checks if a specific Root or Trusted Publisher certificate exists.

.DESCRIPTION
    Used as a Discovery Script in SCCM/MECM Compliance Items to detect the presence of
    an internal Root CA certificate by its Serial Number.

.NOTES
    Author:      M-Endymion (Modern PowerShell rewrite)
    Original:    Ioan Popovici
    Version:     2.0
    Last Updated:2026-05-06
#>

# =============================================================================
# Configuration - Update this section
# =============================================================================
$CertificateSerial = '00adb9a3cfdba68ff1'   # ← Change to your certificate's serial number

# =============================================================================
# Main Logic
# =============================================================================
try {
    $Stores = @('Root', 'TrustedPublisher')
    $Results = @()

    foreach ($StoreName in $Stores) {
        try {
            $Store = New-Object System.Security.Cryptography.X509Certificates.X509Store($StoreName, "LocalMachine")
            $Store.Open("ReadOnly")

            $Cert = $Store.Certificates | Where-Object { $_.SerialNumber -eq $CertificateSerial }

            if ($Cert) {
                $Results += [PSCustomObject]@{
                    Store       = $StoreName
                    Status      = "Found"
                    Serial      = $Cert.SerialNumber
                    Subject     = $Cert.Subject
                    Thumbprint  = $Cert.Thumbprint
                }
            }
            else {
                $Results += [PSCustomObject]@{
                    Store  = $StoreName
                    Status = "Not Found"
                }
            }

            $Store.Close()
        }
        catch {
            $Results += [PSCustomObject]@{
                Store  = $StoreName
                Status = "Error"
            }
        }
    }

    # If certificate is found in any store → Compliant
    if ($Results | Where-Object { $_.Status -eq "Found" }) {
        Write-Output "Compliant"
    }
    else {
        # Return details for reporting (SCCM will show as Non-Compliant)
        $Results | Format-Table -HideTableHeaders -AutoSize | Out-String | Write-Output
    }
}
catch {
    Write-Output "Error during certificate check"
}
