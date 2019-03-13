## This script will install DHCP , create some scopes & maybe run another script\s on 
## next login so be aware ..
## TODO : make an alert if this script started from auto run..

## variables can be parameters
$dhcp_scope_name = "10.10.30.0 IT"
$dhcp_scope_StartRange = "10.10.30.1"
$dhcp_scope_EndRange = "10.10.30.254"
$dhcp_scope_SubnetMask = "255.255.255.0"


## script start

# removing autorun if found
if (Test-Path "C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\autostart.cmd"){
rm "C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\autostart.cmd"
}

# To install DHCP
Install-WindowsFeature DHCP -IncludeManagementTools
Set-ItemProperty –Path registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager\Roles\12 –Name ConfigurationState –Value 2

# Authorize the DHCP server
Add-DhcpServerInDC -DnsName dc01.ucas.edu

# To create a new DHCP scope
Add-DhcpServerv4Scope `
-name $dhcp_scope_name `
-StartRange $dhcp_scope_StartRange `
-EndRange $dhcp_scope_EndRange `
-SubnetMask $dhcp_scope_SubnetMask -State Active

Set-DhcpServerv4OptionValue `
-DnsDomain "ucas.edu" `
-DnsServer "10.10.40.1"
 
