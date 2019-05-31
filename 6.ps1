## This script will configure the group policies.

# import firefox admin template
Move-Item (".\lib\Firefox\") ("C:\Windows\PolicyDefinitions") -Force
Remove-Item (".\lib\Firefox")

# commands for listting
# Get-GPO -all
# Get-GPO -name "Default Domain Policy"
# Get-GPPermissions -name "Default Domain Policy" -all
new-gpo -name TechGPO `
| new-gplink -target "ou=Tech,dc=ucas,dc=edu" `
| set-gppermissions -replace -permissionlevel none -targetname "Authenticated Users" -targettype group `
| set-gppermissions -permissionlevel gpoapply -targetname "Tech" -targettype group

Import-GPO -BackupGpoName TechGPO -Path .\lib\GPO -TargetName TechGPO

new-gpo -name ManagersGPO `
| new-gplink -target "ou=Managers,dc=ucas,dc=edu" `
| set-gppermissions -replace -permissionlevel none -targetname "Authenticated Users" -targettype group `
| set-gppermissions -permissionlevel gpoapply -targetname "Managers" -targettype group

Import-GPO -BackupGpoName ManagersGPO -Path .\lib\GPO -TargetName ManagersGPO