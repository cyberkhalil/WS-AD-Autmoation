## This script will install Active Directory Domain Services, Create new forest
## & run another script\s on next login so be aware ..
## TODO : make an alert if this script started from auto run..

# removing autorun if found
if (Test-Path "C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\autostart.cmd") {
  rm "C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\autostart.cmd"
}

function install_active_directory {
  param(
    [string]$Domain_Name = "ucas.edu",
    [string]$Netbios_Name = "UCAS",
    [string]$Domain_Mode = "Win2008",# can be Win2012 too
    [string]$Forest_Mode = "Win2008",# can be Win2012 too
    [bool]$auto_run_next_script = $true,
    [string]$password = "Ucas!"
  )
  $Safe_Mode_Pass = ConvertTo-SecureString $password -AsPlainText -Force

  # installing Active Directory Domain Services
  Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
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
  if ($auto_run_next_script) {
    C:\scripts\lib\Start_Next_Script -Script_Name "3.ps1"
  }

}
# call the function
install_active_directory

# force restarting the computer
Restart-Computer
