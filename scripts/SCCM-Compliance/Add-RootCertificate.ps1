<#
.SYNOPSIS
    Remediation script - Imports a Root CA or Trusted Publisher certificate.

.DESCRIPTION
    Imports a .cer file into the LocalMachine Root and TrustedPublisher stores.
    Designed for use as an SCCM/MECM Compliance Item Remediation Script.

.NOTES
    Author:      M-Endymion
    Version:     2.0
    Last Updated:2026-05-06
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$CertificatePath
)

# =============================================================================
# Main Script
# =============================================================================
try {
    if (-not (Test-Path $CertificatePath)) {
        Write-Error "Certificate file not found: $CertificatePath"
        exit 1
    }

    $Certificate = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
    $Certificate.Import($CertificatePath)

    $Stores = @('Root', 'TrustedPublisher')

    foreach ($StoreName in $Stores) {
        $Store = New-Object System.Security.Cryptography.X509Certificates.X509Store($StoreName, "LocalMachine")
        $Store.Open("ReadWrite")
        $Store.Add($Certificate)
        $Store.Close()

        Write-Host "Certificate successfully added to $StoreName store" -ForegroundColor Green
    }

    # Success marker
    New-Item -Path "C:\Windows\CCM\Logs\RootCertificate_Added.done" -ItemType File -Force | Out-Null

    Write-Host "Root Certificate remediation completed successfully." -ForegroundColor Green
    exit 0
}
catch {
    Write-Error "Failed to import certificate: $($_.Exception.Message)"
    exit 1
}
