## This script will install DHCP , create some scopes & maybe run another script\s on 
## next login so be aware ..
## TODO : make an alert if this script started from auto run..

# removing autorun if found
if (Test-Path "C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\autostart.cmd") {
  rm "C:\Users\Administrator\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\autostart.cmd"
}

function install_dhcp {
  param(
    [string]$dhcp_scope_name = "10.10.30.0 IT",
    [string]$dhcp_scope_StartRange = "10.10.30.1",
    [string]$dhcp_scope_EndRange = "10.10.30.254",
    [string]$dhcp_scope_SubnetMask = "255.255.255.0",

    [string]$dhcp_dns_domain = "ucas.edu",
    [string]$dhcp_dns_server = "10.10.40.1"
  )

  # To install DHCP
  Install-WindowsFeature DHCP -IncludeManagementTools
  Set-ItemProperty -Path registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager\Roles\12 -Name ConfigurationState -Value 2

  # Authorize the DHCP server
  Add-DhcpServerInDC -DnsName dc01.ucas.edu

  # To create a new DHCP scope
  Add-DhcpServerv4Scope `
     -Name $dhcp_scope_name `
     -StartRange $dhcp_scope_StartRange `
     -EndRange $dhcp_scope_EndRange `
     -SubnetMask $dhcp_scope_SubnetMask -State Active

  Set-DhcpServerv4OptionValue `
     -DnsDomain $dhcp_dns_domain `
     -DnsServer $dhcp_dns_server;
}

# call the function
install_dhcp
