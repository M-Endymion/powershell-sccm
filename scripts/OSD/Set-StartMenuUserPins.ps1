<#
.SYNOPSIS
    Pins specified applications to the Start Menu for each user (via Active Setup).

.DESCRIPTION
    Uses Active Setup to run once per user and pin applications to the Start Menu.
    Works on Windows 10 and Windows 11.

.NOTES
    Author:      M-Endymion (Modern rewrite)
    Original:    Nickolaj Andersen (2018)
    Version:     2.0
    Last Updated:2026-05-06

.EXAMPLE
    # Stage during OSD
    .\Set-StartMenuUserPins.ps1 -RunMode Stage
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("Stage", "Execute")]
    [string]$RunMode
)

# =============================================================================
# Configuration - Edit apps you want to pin here
# =============================================================================
$AppsToPin = @(
    "Outlook",
    "Google Chrome",
    "Microsoft Edge",
    "Excel",
    "Word"
)

# =============================================================================
# Main Logic
# =============================================================================
switch ($RunMode) {
    "Stage" {
        Write-Host "Staging Start Menu pinning script for Active Setup..." -ForegroundColor Cyan

        $ScriptDestination = Join-Path $env:SystemRoot "Set-StartMenuUserPins.ps1"

        try {
            Copy-Item -Path $MyInvocation.MyCommand.Definition -Destination $ScriptDestination -Force -ErrorAction Stop
        }
        catch {
            Write-Warning "Failed to stage script: $($_.Exception.Message)"
            exit 1
        }

        # Configure Active Setup
        $ActiveSetupPath = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\StartMenuUserPins"
        New-Item -Path $ActiveSetupPath -Force | Out-Null
        New-ItemProperty -Path $ActiveSetupPath -Name "Version" -Value "1" -Force | Out-Null
        New-ItemProperty -Path $ActiveSetupPath -Name "StubPath" -Value "powershell.exe -ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -File `"$ScriptDestination`" -RunMode Execute" -PropertyType ExpandString -Force | Out-Null

        Write-Host "Active Setup configured successfully." -ForegroundColor Green
    }

    "Execute" {
        Write-Host "Executing Start Menu pinning for current user..." -ForegroundColor Cyan

        foreach ($AppName in $AppsToPin) {
            try {
                $Shell = New-Object -ComObject Shell.Application
                $StartMenu = $Shell.NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}')

                $Item = $StartMenu.Items() | Where-Object { $_.Name -like "*$AppName*" } | Select-Object -First 1

                if ($Item) {
                    $Verbs = $Item.Verbs()
                    $PinVerb = $Verbs | Where-Object { $_.Name -replace '&', '' -like '*Pin to Start*' }

                    if ($PinVerb) {
                        $PinVerb.DoIt()
                        Write-Host "Pinned: $AppName" -ForegroundColor Green
                    }
                    else {
                        Write-Host "Already pinned or no pin option: $AppName" -ForegroundColor Gray
                    }
                }
                else {
                    Write-Warning "Application not found: $AppName"
                }
            }
            catch {
                Write-Warning "Failed to pin $AppName : $($_.Exception.Message)"
            }
        }

        Write-Host "Start Menu pinning completed for current user." -ForegroundColor Green
    }
}
