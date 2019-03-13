## This script will change computer name, give it a static ip, remove not administrator users
## & run another script/s on next login so be aware of what you are doing ..

## variables can be parameters

$computer_name = "DC01"

$IP = "10.10.40.1"
$Mask_Number = "8"
$DNS_Ip = $IP
#$gate_way_ip = "10.10.40.1"

$auto_login_administrator = $true;

$Administrator_Username = "Administrator";
$Administrator_Password = "Ucas!";

$auto_run_next_script = $true;

## script start
if (-Not (.\lib\Check_Administrator.ps1)) {
(new-object -comobject wscript.shell).popup("Log out from this user and run this script from administrator account please",0,"Error message");
shutdown -l;
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

# get ipv4 ethernet interface
$ip_v4_interfaces = Get-NetIPInterface | ? AddressFamily -eq "IPv4" | ? InterfaceAlias -notmatch "Loopback";
$Ethernet_interface = $ip_v4_interfaces[0].InterfaceAlias;


# To give a static ip & dns
New-NetIPAddress `
-IPAddress $IP `
-InterfaceAlias $Ethernet_interface `
-AddressFamily IPv4 `
-PrefixLength $Mask_Number #-DefaultGateway $gate_way_ip
Set-DnsClientServerAddress -InterfaceAlias $Ethernet_interface -ServerAddresses $DNS_Ip

# creating cmd file that will run 2.ps1 on the next login
if ($auto_run_next_script){
C:\scripts\lib\Start_Next_Script -Script_Name "2.ps1"
}

# removing not Administrator & Guest users
$all_not_admin_users= @(Get-WmiObject -Class Win32_UserAccount -Filter  "LocalAccount='True'"| where "name" -ne "Administrator"| where "name" -ne "Guest" | select name);
$all_not_admin_users.foreach({
([ADSI]"WinNT://$env:COMPUTERNAME").delete("user",$_.name);
});

if ($auto_login_administrator){
$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
Set-ItemProperty $RegPath "AutoAdminLogon" -Value "1" -type String 
Set-ItemProperty $RegPath "DefaultUsername" -Value "$Administrator_Username" -type String 
Set-ItemProperty $RegPath "DefaultPassword" -Value "$Administrator_Password" -type String
}

# restarting computer
Restart-Computer
