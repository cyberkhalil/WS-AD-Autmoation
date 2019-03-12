# To install DHCP
Install-WindowsFeature DHCP -IncludeManagementTools
Set-ItemProperty –Path registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager\Roles\12 –Name ConfigurationState –Value 2

# Authorize the DHCP server
Add-DhcpServerInDC -DnsName dc01.ucas.edu

# To create a new DHCP scope
$dhcp_scope_name = "10.10.30.0 IT"
$dhcp_scope_StartRange = "10.10.30.1"
$dhcp_scope_EndRange = "10.10.30.254"
$dhcp_scope_SubnetMask = "255.255.255.0"

Add-DhcpServerv4Scope `
-name $dhcp_scope_name `
-StartRange $dhcp_scope_StartRange `
-EndRange $dhcp_scope_EndRange `
-SubnetMask $dhcp_scope_SubnetMask -State Active

Set-DhcpServerv4OptionValue `
-DnsDomain "ucas.edu" `
-DnsServer "10.10.40.1"

# To preview organization units
Get-ADOrganizationalUnit -Filter * `
| Format-Table Name, DistinguishedName


# To create new organization unit
New-ADOrganizationalUnit -Name "UCAS" `
-Path 'DC=ucas,DC=edu' `
-ProtectedFromAccidentalDeletion $false `
-Description "ucas"

# To create new organization unit
New-ADOrganizationalUnit -Name "ENG" `
-Path 'OU=ucas,DC=ucas,DC=edu' `
-ProtectedFromAccidentalDeletion $false `
-Description "Eng's OU"


# To create new user
$new_user_first_name = "Ahmed"
$new_user_last_name = "Ledo"
$new_user_password = ConvertTo-SecureString Ucas!123 -AsPlainText -Force
$new_user_OUPath = "OU=ENG,OU=ucas,DC=ucas,DC=edu"
$new_user_account_name = $new_user_first_name.Chars(0)+$new_user_last_name
$new_user_name = $new_user_first_name+" "+$new_user_last_name;

New-ADUser -Name $new_user_name `
-GivenName $new_user_first_name `
-Surname $new_user_last_name `
-SamAccountName $new_user_account_name `
-AccountPassword $new_user_password `
-Path $new_user_OUPath `
-Enable $true

# To Preview DNS records
Get-DnsServerResourceRecord `
-ZoneName "ucas.edu"


# To add DNS A record
Add-DnsServerResourceRecordA -AllowUpdateAny `
-Name "a" `
-ZoneName "ucas.edu" `
-IPv4Address "10.10.40.1"

# To install web server
install-windowsfeature Web-Server






<#
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

# To install Active Directory Domain Services
Install-windowsfeature -name AD-Domain-Services –IncludeManagementTools
Import-Module ADDSDeployment


# To install a new Forest (AD-Domain-Services windowsfeature must be installed)
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "Win2008" `
-DomainName "ucas.edu" `
-DomainNetbiosName "UCAS" `
-ForestMode "Win2008" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true # the 2 lines below contains the SafeModeAdministratorPassword !!

Ucas!
Ucas!




# TODO's
-------------------
## DHCP Exclusion Range
$dhcp_scope_ExclusionRange_ScopeID = "10.0.1.0"
$dhcp_scope_ExclusionRange_StartRange = "10.0.1.1"
$dhcp_scope_ExclusionRange_EndRange = "10.0.1.15"

Add-DhcpServerv4ExclusionRange `
-ScopeID $dhcp_scope_ExclusionRange_ScopeID `
-StartRange $dhcp_scope_ExclusionRange_StartRange `
-EndRange $dhcp_scope_ExclusionRange_EndRange

Set-DhcpServerv4OptionValue -OptionID 3 -Value 10.0.0.1 -ScopeID 10.0.0.0 -ComputerName DHCP1.corp.contoso.com`



--------------------
## TODO : make the scripts above as methods

Function Get-BatAvg {
[cmdletbinding()]
Param (
[string]$Name,
[int]$Hits, [int]$AtBats
)
# End of Parameters
 Process {
Clear-Host
"Enter Name Hits AtBats..."
$Avg = [int]($Hits / $AtBats*100)/100
if($Avg -gt 1)
{
Clear-Host
"$Name's cricket average = $Avg : $Hits Runs, $AtBats dismissals"
} # End of If
Else {
Clear-Host
"$Name's baseball average = $Avg : $Hits Hits, $AtBats AtBats"
} # End of Else.
   } # End of Process
}


----------------------
## TODO : make parms like this
$Params = @{
    CreateDnsDelegation = $false
    DatabasePath = 'C:\Windows\NTDS'
    DomainMode = 'WinThreshold'
    DomainName = 'mikefrobbins.com'
    DomainNetbiosName = 'MIKEFROBBINS'
    ForestMode = 'WinThreshold'
    InstallDns = $true
    LogPath = 'C:\Windows\NTDS'
    NoRebootOnCompletion = $true
    SafeModeAdministratorPassword = $Password
    SysvolPath = 'C:\Windows\SYSVOL'
    Force = $true
}
 
Install-ADDSForest @Params


# To add DNS CName record
Add-DnsServerResourceRecordCName -AllowUpdateAny `
-Name "www" `
-HostNameAlias = "DC01.ucas.edu" `
-ZoneName "ucas.edu"


#>
