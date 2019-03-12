## This script will change computer name , give it a static ip 
## & run another scripts so be aware what you are doing ..

## used variables
$computer_name = "DC01"

$IP = "10.10.40.1"
$Mask_Number = "8"
$DNS_Ip = $IP
#$gate_way_ip = "10.10.40.1"
$Interface_Type = "Ethernet"

## script start
if (-Not (.\Check_Administrator.ps1)) {
(new-object -comobject wscript.shell).popup("Log out from this user and run this script from administrator account please",0,"Error message")
}

# To rename computer
Rename-Computer $computer_name

# To give a static ip & dns
New-NetIPAddress `
-IPAddress $IP `
-InterfaceAlias $Interface_Type `
-AddressFamily IPv4 `
-PrefixLength $Mask_Number #-DefaultGateway $gate_way_ip
Set-DnsClientServerAddress -InterfaceAlias $Interface_Type -ServerAddresses $DNS_Ip

# To restart computer
Restart-Computer

# TODO make it auto run script 2
