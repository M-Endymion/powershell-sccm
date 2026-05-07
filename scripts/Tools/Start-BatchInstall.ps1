<#
.SYNOPSIS
    Interactive batch installer with persistent settings.

.DESCRIPTION
    Modern PowerShell replacement for BatchInstall.bat.
    Provides a menu-driven installation experience with persistent choices.

.NOTES
    Author:      M-Endymion (Modern rewrite)
    Original:    BatchInstall.bat framework
    Version:     1.0
    Last Updated:2026-05-06
#>

# =============================================================================
# Configuration - Modify as needed
# =============================================================================
$ScriptVersion = "1.0"
$PersistFile = Join-Path $PSScriptRoot "BatchInstall_Settings.json"

# Default settings
$Settings = @{
    InstallType = "Server"      # Server or Client
    Size        = "Full"        # Full, Regular, Mini
    ShowReadMe  = $false
}

# Load persistent settings if they exist
if (Test-Path $PersistFile) {
    try {
        $Loaded = Get-Content $PersistFile | ConvertFrom-Json
        $Settings = $Loaded
        Write-Host "Loaded previous settings." -ForegroundColor Green
    }
    catch {}
}

# =============================================================================
# Helper Functions
# =============================================================================
function Save-Settings {
    $Settings | ConvertTo-Json | Out-File $PersistFile -Encoding UTF8
    Write-Host "Settings saved." -ForegroundColor Gray
}

function Show-Menu {
    Clear-Host
    Write-Host "=====================================" -ForegroundColor Cyan
    Write-Host "     Batch Installer v$ScriptVersion" -ForegroundColor Cyan
    Write-Host "=====================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Install Type          : $($Settings.InstallType)"
    Write-Host "2. Installation Size     : $($Settings.Size)"
    Write-Host "3. Show ReadMe when done : $($Settings.ShowReadMe)"
    Write-Host ""
    Write-Host "I. Start Installation"
    Write-Host "C. Clear Screen"
    Write-Host "Q. Quit"
    Write-Host ""
}

# =============================================================================
# Main Menu Loop
# =============================================================================
do {
    Show-Menu
    $Choice = Read-Host "Make a choice"

    switch ($Choice) {
        "1" {
            if ($Settings.InstallType -eq "Server") { $Settings.InstallType = "Client" }
            else { $Settings.InstallType = "Server" }
            Save-Settings
        }
        "2" {
            switch ($Settings.Size) {
                "Full" { $Settings.Size = "Regular" }
                "Regular" { $Settings.Size = "Mini" }
                "Mini" { $Settings.Size = "Full" }
            }
            Save-Settings
        }
        "3" {
            $Settings.ShowReadMe = -not $Settings.ShowReadMe
            Save-Settings
        }
        "I" {
            Write-Host "`nStarting installation simulation..." -ForegroundColor Yellow
            
            $MaxFiles = 20
            if ($Settings.Size -eq "Full") { $MaxFiles = 11 }
            elseif ($Settings.Size -eq "Regular") { $MaxFiles = 7 }
            elseif ($Settings.Size -eq "Mini") { $MaxFiles = 3 }

            for ($i = 1; $i -le $MaxFiles; $i++) {
                Write-Progress -Activity "Installing $($Settings.InstallType) files" -Status "File $i of $MaxFiles" -PercentComplete (($i / $MaxFiles) * 100)
                Start-Sleep -Milliseconds 400
            }

            Write-Host "Installation completed successfully!" -ForegroundColor Green

            if ($Settings.ShowReadMe) {
                if (Test-Path "ReadMe.txt") {
                    notepad "ReadMe.txt"
                } else {
                    Write-Host "ReadMe.txt not found." -ForegroundColor Yellow
                }
            }
        }
        "C" { Clear-Host }
        "Q" { 
            Save-Settings
            Write-Host "Goodbye!" -ForegroundColor Cyan
            break 
        }
    }
} while ($Choice -ne "Q")
