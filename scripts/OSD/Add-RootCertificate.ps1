<#
.SYNOPSIS
    Adds one or more Root or Trusted Publisher certificates during OSD.

.DESCRIPTION
    Imports Base64-encoded certificates into the LocalMachine certificate store.
    Designed for use in SCCM/MECM Task Sequences to deploy internal Root CAs.

.NOTES
    Author:      M-Endymion (Modern rewrite)
    Original:    Ioan Popovici
    Version:     2.0
    Last Updated:2026-05-06

.EXAMPLE
    # Add a single certificate
    .\Add-RootCertificate.ps1 -CertificatePath ".\InternalRootCA.cer"

.EXAMPLE
    # Add multiple certificates
    .\Add-RootCertificate.ps1 -CertificatePath ".\certs\RootCA.cer",".\certs\Intermediate.cer"
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string[]]$CertificatePath
)

# =============================================================================
# Logging
# =============================================================================
$LogPath = "C:\Windows\CCM\Logs\Add-RootCertificate.log"
Start-Transcript -Path $LogPath -Append -Force
Write-Host "Starting Root Certificate Import..." -ForegroundColor Cyan

# =============================================================================
# Main Script
# =============================================================================
try {
    $Stores = @('Root', 'TrustedPublisher')

    foreach ($CertFile in $CertificatePath) {
        if (-not (Test-Path $CertFile)) {
            Write-Warning "Certificate file not found: $CertFile"
            continue
        }

        Write-Host "Importing certificate: $CertFile" -ForegroundColor Yellow

        foreach ($StoreName in $Stores) {
            try {
                $Cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
                $Cert.Import($CertFile)

                $Store = New-Object System.Security.Cryptography.X509Certificates.X509Store($StoreName, "LocalMachine")
                $Store.Open("ReadWrite")
                $Store.Add($Cert)
                $Store.Close()

                Write-Host "Successfully added to $StoreName store" -ForegroundColor Green
            }
            catch {
                Write-Warning "Failed to add to $StoreName store: $($_.Exception.Message)"
            }
        }
    }

    # Success marker
    New-Item -Path "C:\Windows\CCM\Logs\RootCertificate_Added.done" -ItemType File -Force | Out-Null

    Write-Host "Root certificate import completed successfully!" -ForegroundColor Green
    Stop-Transcript
    exit 0
}
catch {
    Write-Error "Critical error during certificate import: $($_.Exception.Message)"
    Stop-Transcript
    exit 1
}
