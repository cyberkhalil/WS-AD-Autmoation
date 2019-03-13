## This script will change computer name, give it a static ip, remove not administrator users
## & run another script/s on next login so be aware of what you are doing ..
## TODO : remove not administrator users

## variables can be parameters
$computer_name = "DC01"

$IP = "10.10.40.1"
$Mask_Number = "8"
$DNS_Ip = $IP
#$gate_way_ip = "10.10.40.1"
$Interface_Type = "Ethernet"

## script start
if (-Not (.\lib\Check_Administrator.ps1)) {
(new-object -comobject wscript.shell).popup("Log out from this user and run this script from administrator account please",0,"Error message");
exit
}


# moving files
$current_path = pwd
$current_path = $current_path.Path;

$scipts_new_path = "C:\scripts";
if(-Not (test-path C:\scripts)){
ni $scipts_new_path -ItemType Directory
}

if(-Not($current_path -eq $scipts_new_path)){
move ($current_path+"\lib\") ($scipts_new_path+"\lib\") -Force
$scripts = ls $current_path *.ps1
foreach ($script in $scripts){
move $script ($scipts_new_path+"\")
}
}


# renaming computer
Rename-Computer $computer_name

# To give a static ip & dns
New-NetIPAddress `
-IPAddress $IP `
-InterfaceAlias $Interface_Type `
-AddressFamily IPv4 `
-PrefixLength $Mask_Number #-DefaultGateway $gate_way_ip
Set-DnsClientServerAddress -InterfaceAlias $Interface_Type -ServerAddresses $DNS_Ip

# creating cmd file that will run 2.ps1 on the next login
Set-Content -Path 'C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\autostart.cmd' -Value 'PowerShell -File C:\scripts\2.ps1'

# removing not Administrator & Guest users
$all_not_admin_users= @(Get-WmiObject -Class Win32_UserAccount -Filter  "LocalAccount='True'"| where "name" -ne "Administrator"| where "name" -ne "Guest" | select name);
$all_not_admin_users.foreach({
([ADSI]"WinNT://$env:COMPUTERNAME").delete("user",$_.name);
});

# restarting computer
Restart-Computer
