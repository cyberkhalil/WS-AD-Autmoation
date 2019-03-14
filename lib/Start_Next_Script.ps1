<#
    .DESCRIPTION
    this script will take a .PARAMETER Script_Name which will start on the next time you login ..
#>
param([string]$Script_Name)

Set-Content `
 -Path 'C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\autostart.cmd' `
 -Value ("Powershell -File c:/scripts/"+$Script_Name)
