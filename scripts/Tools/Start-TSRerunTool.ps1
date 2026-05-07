<#
.SYNOPSIS
    GUI Tool to find, delete, and re-run Task Sequence scheduled items in SCCM/MECM.

.DESCRIPTION
    Allows searching for scheduled Task Sequence items on local or remote computers,
    deleting them so they can be re-run, and restarting the SMS Agent service.

.NOTES
    Author:      M-Endymion (Modernized & Completed)
    Original:    Community tool (scconfigmgr.com style)
    Version:     2.0
    Last Updated:2026-05-06
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# =============================================================================
# Form
# =============================================================================
$form = New-Object System.Windows.Forms.Form
$form.Text = "Task Sequence Rerun Tool"
$form.Size = New-Object System.Drawing.Size(700, 580)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false

# Controls
$lblPackageID = New-Object System.Windows.Forms.Label
$lblPackageID.Location = New-Object System.Drawing.Point(20,20)
$lblPackageID.Size = New-Object System.Drawing.Size(100,20)
$lblPackageID.Text = "Package ID:"

$tbPackageID = New-Object System.Windows.Forms.TextBox
$tbPackageID.Location = New-Object System.Drawing.Point(120,18)
$tbPackageID.Size = New-Object System.Drawing.Size(160,20)

$rbLocal = New-Object System.Windows.Forms.RadioButton
$rbLocal.Location = New-Object System.Drawing.Point(20,55)
$rbLocal.Text = "Local"
$rbLocal.Checked = $true

$rbRemote = New-Object System.Windows.Forms.RadioButton
$rbRemote.Location = New-Object System.Drawing.Point(100,55)
$rbRemote.Text = "Remote"

$tbComputer = New-Object System.Windows.Forms.TextBox
$tbComputer.Location = New-Object System.Drawing.Point(190,53)
$tbComputer.Size = New-Object System.Drawing.Size(160,20)
$tbComputer.Enabled = $false

$btnSearch = New-Object System.Windows.Forms.Button
$btnSearch.Location = New-Object System.Drawing.Point(370,18)
$btnSearch.Size = New-Object System.Drawing.Size(100,30)
$btnSearch.Text = "Search"
$btnSearch.Add_Click({ Start-Search })

$dgvResults = New-Object System.Windows.Forms.DataGridView
$dgvResults.Location = New-Object System.Drawing.Point(20,90)
$dgvResults.Size = New-Object System.Drawing.Size(650,200)
$dgvResults.ColumnCount = 1
$dgvResults.Columns[0].Name = "ScheduleID"
$dgvResults.Columns[0].AutoSizeMode = "Fill"
$dgvResults.ReadOnly = $true
$dgvResults.AllowUserToAddRows = $false

$btnDelete = New-Object System.Windows.Forms.Button
$btnDelete.Location = New-Object System.Drawing.Point(20,310)
$btnDelete.Size = New-Object System.Drawing.Size(120,35)
$btnDelete.Text = "Delete Selected"
$btnDelete.Enabled = $false
$btnDelete.Add_Click({ Delete-Selected })

$btnRestart = New-Object System.Windows.Forms.Button
$btnRestart.Location = New-Object System.Drawing.Point(160,310)
$btnRestart.Size = New-Object System.Drawing.Size(140,35)
$btnRestart.Text = "Restart SMS Agent"
$btnRestart.Enabled = $false
$btnRestart.Add_Click({ Restart-SMSAgent })

$txtOutput = New-Object System.Windows.Forms.RichTextBox
$txtOutput.Location = New-Object System.Drawing.Point(20,360)
$txtOutput.Size = New-Object System.Drawing.Size(650,160)
$txtOutput.ReadOnly = $true
$txtOutput.BackColor = "Black"
$txtOutput.ForeColor = "Lime"
$txtOutput.Font = New-Object System.Drawing.Font("Consolas", 9)

$form.Controls.AddRange(@($lblPackageID, $tbPackageID, $rbLocal, $rbRemote, $tbComputer, $btnSearch, 
                         $dgvResults, $btnDelete, $btnRestart, $txtOutput))

# =============================================================================
# Functions
# =============================================================================
function Write-Output {
    param([string]$Message, [string]$Color = "White")
    $timestamp = Get-Date -Format "HH:mm:ss"
    $txtOutput.SelectionColor = $Color
    $txtOutput.AppendText("$timestamp - $Message`n")
    $txtOutput.ScrollToCaret()
}

function Start-Search {
    $txtOutput.Clear()
    $dgvResults.Rows.Clear()
    $btnDelete.Enabled = $false

    $Computer = if ($rbRemote.Checked) { $tbComputer.Text.Trim() } else { $env:COMPUTERNAME }

    if ([string]::IsNullOrWhiteSpace($tbPackageID.Text)) {
        Write-Output "Please enter a Package ID" -Color "Red"
        return
    }

    try {
        Write-Output "Searching on $Computer for PackageID: $($tbPackageID.Text)" -Color "Cyan"

        $Items = Get-WmiObject -Namespace "root\CCM\Scheduler" -Class CCM_Scheduler_History -ComputerName $Computer -ErrorAction Stop |
                 Where-Object { $_.ScheduleID -like "*$($tbPackageID.Text)*" }

        if ($Items) {
            foreach ($Item in $Items) {
                $dgvResults.Rows.Add($Item.ScheduleID) | Out-Null
            }
            Write-Output "Found $($Items.Count) matching scheduled items" -Color "Green"
        } else {
            Write-Output "No matching items found" -Color "Yellow"
        }
    }
    catch {
        Write-Output "Error querying computer $Computer : $($_.Exception.Message)" -Color "Red"
    }
}

function Delete-Selected {
    $SelectedRow = $dgvResults.CurrentRow
    if (-not $SelectedRow) {
        Write-Output "No item selected" -Color "Red"
        return
    }

    $ScheduleID = $SelectedRow.Cells[0].Value
    $Computer = if ($rbRemote.Checked) { $tbComputer.Text.Trim() } else { $env:COMPUTERNAME }

    try {
        Write-Output "Deleting ScheduleID: $ScheduleID on $Computer" -Color "Yellow"

        $Object = Get-WmiObject -Namespace "root\CCM\Scheduler" -Class CCM_Scheduler_History -ComputerName $Computer |
                  Where-Object { $_.ScheduleID -eq $ScheduleID }

        if ($Object) {
            $Object.Delete()
            Write-Output "Successfully deleted scheduled item" -Color "Green"
            $dgvResults.Rows.Remove($SelectedRow)
        }
    }
    catch {
        Write-Output "Failed to delete item: $($_.Exception.Message)" -Color "Red"
    }
}

function Restart-SMSAgent {
    $Computer = if ($rbRemote.Checked) { $tbComputer.Text.Trim() } else { $env:COMPUTERNAME }

    try {
        Write-Output "Restarting SMS Agent (CCMExec) on $Computer..." -Color "Yellow"
        Restart-Service -Name "CCMExec" -ComputerName $Computer -Force -ErrorAction Stop
        Write-Output "SMS Agent service restarted successfully" -Color "Green"
    }
    catch {
        Write-Output "Failed to restart SMS Agent: $($_.Exception.Message)" -Color "Red"
    }
}

# Event Handlers
$dgvResults.Add_CellClick({
    if ($_.RowIndex -ge 0) {
        $btnDelete.Enabled = $true
    }
})

$rbRemote.Add_CheckedChanged({
    $tbComputer.Enabled = $rbRemote.Checked
})

# Show Form
$form.Add_Shown({$form.Activate()})
[void]$form.ShowDialog()
