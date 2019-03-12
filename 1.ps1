## This script will change computer name, give it a static ip, remove not administrator users
## & run another script/s on next login so be aware of what you are doing ..

## variables can be parameters
$computer_name = "DC01"

$IP = "10.10.40.1"
$Mask_Number = "8"
$DNS_Ip = $IP
#$gate_way_ip = "10.10.40.1"
$Interface_Type = "Ethernet"

## script start
if (-Not (.\lib\Check_Administrator.ps1)) {
(new-object -comobject wscript.shell).popup("Log out from this user and run this script from administrator account please",0,"Error message")
}


# moving files
$scipts_path = "C:\scripts";
$current_path = pwd
if(-Not($current_path.Path -eq $scipts_path)){
move lib ($scipts_path+"\lib") -Force
$scripts = Get-ChildItem *.ps1
foreach ($script in $scripts){
move $script $scipts_path
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
echo "PowerShell -File C:\scripts\2.ps1" >> "C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\autorun.cmd"

# restarting computer
Restart-Computer
