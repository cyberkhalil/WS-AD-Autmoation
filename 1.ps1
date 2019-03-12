# TODO here check privileages
if (-Not (.\Check_Administrator.ps1)) {
(new-object -comobject wscript.shell).popup("Log out from this user and run this script from administrator account please",0,"Error message")
}
# To rename computer
$computer_name = "DC01"
Rename-Computer $computer_name

# To give a static ip & dns
$IP = "10.10.40.1"
$Mask_Number = "8"
$DNS_Ip = $IP
#1 $gate_way_ip

New-NetIPAddress `
-IPAddress $IP `
-InterfaceAlias "Ethernet" `
-AddressFamily IPv4 `
-PrefixLength $Mask_Number #1 `
#1 -DefaultGateway $gate_way_ip
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses $DNS_Ip

# To restart computer
Restart-Computer

# TODO make it auto run script 2
