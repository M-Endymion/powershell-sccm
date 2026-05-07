' ****************************************************************************
' OSD Tattoo Script (Legacy VBS)
' Modern replacement: New-OSDTattoo.ps1 (recommended)
' ****************************************************************************

Dim env, oReg, strKeyPath
Const HKEY_LOCAL_MACHINE = &H80000002

Set env = CreateObject("Microsoft.SMS.TSEnvironment")
Set oReg = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\default:StdRegProv")

' Registry path
strKeyPath = "SOFTWARE\Contoso\OSD"

' Create main registry key
oReg.CreateKey HKEY_LOCAL_MACHINE, strKeyPath

' Helper function
Sub WriteReg(ValueName, Value)
    oReg.SetStringValue HKEY_LOCAL_MACHINE, strKeyPath, ValueName, Value
End Sub

' Write common Task Sequence variables
WriteReg "Installed Date",       FormatDateTime(Date, 2) & " " & FormatDateTime(Time, 3)
WriteReg "AdvertisementID",      env("_SMSTSAdvertID")
WriteReg "Task Sequence Name",   env("_SMSTSPackageName")
WriteReg "Task Sequence ID",     env("_SMSTSPackageID")
WriteReg "Media Type",           env("_SMSTSMediaType")
WriteReg "Computer Name",        env("_SMSTSMachineName")
WriteReg "Installation Mode",    env("_SMSTSLaunchMode")

WScript.Echo "OSD Tattoo completed (Legacy VBS)"
