## This script will install Active Directory Domain Services, Create new forest
## & run another script\s on next login so be aware ..
## TODO : make an alert if this script started from auto run..

## variables can be parameters
$Domain_Name = "ucas.edu"
$Netbios_Name = "UCAS"
$Domain_Mode = "Win2008" # can be Win2012 too
$Forest_Mode = "Win2008" # can be Win2012 too

$Safe_Mode_Pass = ConvertTo-SecureString "Ucas!" -AsPlainText -Force

## script start

# removing auto generated autorun (while running 2.ps1)
if (Test-Path "C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\autostart.cmd"){
rm "C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\autostart.cmd"
}

# installing Active Directory Domain Services
Install-windowsfeature -name AD-Domain-Services -IncludeManagementTools
Import-Module ADDSDeployment

# To install a new Forest (AD-Domain-Services windowsfeature must be installed)
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode $Domain_Mode `
-DomainName $Domain_Name `
-DomainNetbiosName $Netbios_Name `
-ForestMode $Forest_Mode `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true `
-SafeModeAdministratorPassword $Safe_Mode_Pass

# To run 3.ps1 on the next login
C:\scripts\lib\Start_Next_Script -Script_Name "3.ps1"

# force restarting the computer
Restart-Computer
