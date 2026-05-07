<#
.SYNOPSIS
    Discovery script - Checks if a specific Root CA certificate exists.

.DESCRIPTION
    Used as the Discovery Script in SCCM/MECM Compliance Items.
    Checks for the presence of a certificate by Thumbprint (recommended) or Serial Number.

.NOTES
    Author:      M-Endymion
    Version:     2.0
    Last Updated:2026-05-06
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$CertificateThumbprint   # Preferred method - more reliable than Serial Number
)

# =============================================================================
# Main Script
# =============================================================================
try {
    $Stores = @('Root', 'TrustedPublisher')
    $Found = $false

    foreach ($StoreName in $Stores) {
        $Store = New-Object System.Security.Cryptography.X509Certificates.X509Store($StoreName, "LocalMachine")
        $Store.Open("ReadOnly")

        $Cert = $Store.Certificates | Where-Object { $_.Thumbprint -eq $CertificateThumbprint }

        if ($Cert) {
            Write-Host "Certificate found in $StoreName store" -ForegroundColor Green
            $Found = $true
        }

        $Store.Close()
    }

    # SCCM Compliance Rule should check for output = "Compliant"
    if ($Found) {
        Write-Output "Compliant"
    }
    else {
        Write-Output "Non-Compliant"
    }
}
catch {
    Write-Output "Error"
    Write-Error "Failed to check certificate: $($_.Exception.Message)"
}
