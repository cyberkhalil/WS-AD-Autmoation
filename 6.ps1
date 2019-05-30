## This script will configure the group policies.

# commands for listting
# Get-GPO -all
# Get-GPO -name "Default Domain Policy"
# Get-GPPermissions -name "Default Domain Policy" -all
new-gpo -name TechGPO `
| new-gplink -target "ou=Tech,dc=ucas,dc=edu" `
| set-gppermissions -replace -permissionlevel none -targetname "Authenticated Users" -targettype group `
| set-gppermissions -permissionlevel gpoapply -targetname "Tech" -targettype group

new-gpo -name ManagersGPO `
| new-gplink -target "ou=Managers,dc=ucas,dc=edu" `
| set-gppermissions -replace -permissionlevel none -targetname "Authenticated Users" -targettype group `
| set-gppermissions -permissionlevel gpoapply -targetname "Managers" -targettype group
