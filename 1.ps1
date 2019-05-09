## This script will change computer name, give it a static ip, remove not administrator
## users & run another script/s on next login so be aware of what you are doing ..
function rename_and_set_ip {
  param(
    [string]$computer_name = "DC01",
    [string]$Administrator_Username = "Administrator",
    [string]$Administrator_Password = "Ucas!",
    
    [string]$IP = "10.10.40.1",
    [string]$Mask_Number = "8",
    [string]$DNS_Ip = $IP,
    #$gate_way_ip = "10.10.40.1"
    
    [bool]$auto_login_administrator = $true,
    [bool]$auto_run_next_script = $true,
    [string]$scipts_new_path = "C:\scripts"
  )
  ## script start
  if (-not (.\lib\Check_Administrator.ps1)) {
    (New-Object -ComObject wscript.shell).popup("Log out from this user and run this script from administrator account please",0,"Error message");
    shutdown -l;
    exit
  }


  # moving files
  $current_path = Get-Location
  $current_path = $current_path.Path;
  if (-not (Test-Path C:\scripts)) {
    New-Item $scipts_new_path -ItemType Directory
  }

  if (-not ($current_path -eq $scipts_new_path)) {
    Move-Item ($current_path + "\lib\") ($scipts_new_path + "\lib\") -Force
    $scripts = ls $current_path *.ps1
    foreach ($script in $scripts) {
      Move-Item $script ($scipts_new_path + "\")
    }
  }


  # renaming computer
  Rename-Computer $computer_name

  # get ipv4 ethernet interface
  $ip_v4_interfaces = Get-NetIPInterface | Where-Object AddressFamily -EQ "IPv4" | Where-Object InterfaceAlias -NotMatch "Loopback";
  $Ethernet_interface = $ip_v4_interfaces[0].InterfaceAlias;


  # To give a static ip & dns
  New-NetIPAddress `
     -IPAddress $IP `
     -InterfaceAlias $Ethernet_interface `
     -AddressFamily IPv4 `
     -PrefixLength $Mask_Number #-DefaultGateway $gate_way_ip
  Set-DnsClientServerAddress -InterfaceAlias $Ethernet_interface -ServerAddresses $DNS_Ip

  # removing not Administrator & Guest users
  $all_not_admin_users = @(Get-WmiObject -Class Win32_UserAccount -Filter "LocalAccount='True'" | Where-Object "name" -NE "Administrator" | Where-Object "name" -NE "Guest" | Select-Object name);
  $all_not_admin_users.ForEach({
      ([adsi]"WinNT://$env:COMPUTERNAME").Delete("user",$_.Name);
    });

  if ($auto_login_administrator) {
    $RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
    Set-ItemProperty $RegPath "AutoAdminLogon" -Value "1" -Type String
    Set-ItemProperty $RegPath "DefaultUsername" -Value "$Administrator_Username" -Type String
    Set-ItemProperty $RegPath "DefaultPassword" -Value "$Administrator_Password" -Type String
  }

  # creating cmd file that will run 2.ps1 on the next login
  if ($auto_run_next_script) {
    C:\scripts\lib\Start_Next_Script -Script_Name "2.ps1"
  }
}

# call the function
rename_and_set_ip

# restarting computer
Restart-Computer
