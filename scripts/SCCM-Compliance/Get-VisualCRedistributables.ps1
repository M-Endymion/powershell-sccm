<#
.SYNOPSIS
    Discovery script - Checks for required Microsoft Visual C++ Redistributables.

.DESCRIPTION
    Detects installed Visual C++ Redistributable versions (x86 and x64).
    Designed for use as an SCCM/MECM Compliance Item Discovery Script.

.NOTES
    Author:      M-Endymion (Modern rewrite)
    Version:     2.0
    Last Updated:2026-05-06
#>

# =============================================================================
# Configuration - Add or remove versions as needed
# =============================================================================
$RequiredVC = @{
    "2005"      = $true
    "2008x86"   = $true
    "2010x86"   = $true
    "2012x86"   = $true
    "2013x86"   = $true
    "2015-2019x86" = $true   # Covers 2015, 2017, 2019
    "2015-2019x64" = $true
    # Add 2022 if needed:
    # "2022x86" = $false
    # "2022x64" = $false
}

# =============================================================================
# Main Detection Logic
# =============================================================================
$Found = @{}

# Check both 32-bit and 64-bit registry paths
$RegPaths = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
)

foreach ($Path in $RegPaths) {
    Get-ChildItem -Path $Path -ErrorAction SilentlyContinue | ForEach-Object {
        $DisplayName = $_.GetValue("DisplayName")

        if ($DisplayName -match "Microsoft Visual C\+\+.*Redistributable") {
            $Year = if ($DisplayName -match "(\d{4})") { $Matches[1] } else { "Unknown" }
            $Arch = if ($DisplayName -match "x64") { "x64" } else { "x86" }

            $Key = if ($Year -in "2015","2017","2019") { "2015-2019$Arch" } else { "$Year$Arch" }

            if ($RequiredVC.ContainsKey($Key)) {
                $Found[$Key] = $true
            }
        }
    }
}

# Check which required packages are missing
$Missing = $RequiredVC.Keys | Where-Object { -not $Found.ContainsKey($_) }

if ($Missing.Count -eq 0) {
    Write-Output "Compliant"
    Write-Output "All required Visual C++ Redistributables are installed."
}
else {
    Write-Output "Non-Compliant"
    Write-Output "Missing Visual C++ versions: $($Missing -join ', ')"
}
