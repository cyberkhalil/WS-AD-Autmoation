## This script will install Active Directory Domain Services, Create new forest
## & run another script\s on next login so be aware ..
## TODO : make it auto run 3.ps1 in the next login..
##        make an alert if this script started from auto run..

## variables can be parameters
$Domain_Name = "ucas.edu"
$Netbios_Name = "UCAS"
$Domain_Mode = "Win2008" # there is Win2012 too
$Forest_Mode = "Win2008" # there is Win2012 too

$Safe_Mode_Pass = ConvertTo-SecureString "Ucas!" -AsPlainText -Force

## script start

# installing Active Directory Domain Services
Install-windowsfeature -name AD-Domain-Services -IncludeManagementTools
Import-Module ADDSDeployment

# To install a new Forest (AD-Domain-Services windowsfeature must be installed)
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "Win2008" `
-DomainName $Domain_Name `
-DomainNetbiosName "UCAS" `
-ForestMode "Win2008" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true `
-SafeModeAdministratorPassword $Safe_Mode_Pass
