## This script will create some OU's & user's data from an imeginary company & maybe
## run another script\s on next login so be aware ..

$tech_path = "OU=Tech,DC=ucas,DC=edu"
$managers_path = "OU=Managers,DC=ucas,DC=edu"
NEW-ADOrganizationalUnit "Tech" -Path "DC=ucas,DC=edu" -ProtectedFromAccidentalDeletion $false
NEW-ADOrganizationalUnit "Managers" -Path "DC=ucas,DC=edu" -ProtectedFromAccidentalDeletion $false

$users_password = "Password!123"
$secure_password = ConvertTo-SecureString $users_password -AsPlainText -Force

New-ADUser -Name "Jack Robinson" -GivenName "Jack" -Surname "Robinson" -SamAccountName "J.Robinson" -Path "OU=Tech,DC=ucas,DC=edu" -AccountPassword $secure_password -Enabled $true
New-ADUser -Name "Bill Jackson" -GivenName "Bill" -Surname "Jackson" -SamAccountName "B.Jackson" -Path "OU=Tech,DC=ucas,DC=edu" -AccountPassword $secure_password -Enabled $true
New-ADUser -Name "Ahmed Saed" -GivenName "Ahmed" -Surname "Saed" -SamAccountName "A.Saed" -Path "OU=Tech,DC=ucas,DC=edu" -AccountPassword $secure_password -Enabled $true
New-ADUser -Name "Max Swift" -GivenName "Max" -Surname "Swift" -SamAccountName "M.Swift" -Path "OU=Managers,DC=ucas,DC=edu" -AccountPassword $secure_password -Enabled $true
New-ADUser -Name "Chew David" -GivenName "Chew" -Surname "David" -SamAccountName "C.David" -Path "OU=Tech,DC=ucas,DC=edu" -AccountPassword $secure_password -Enabled $true

New-ADGroup -Name "Tech" -GroupScope DomainLocal -Path $tech_path
$Users = Get-ADUser -SearchBase $tech_path -Filter *
$Group = Get-ADGroup -Identity ("CN=Tech," + $tech_path)
Add-ADGroupMember -Identity $Group -Members $Users


New-ADGroup -Name "Managers" -GroupScope DomainLocal -Path $managers_path
$Users = Get-ADUser -SearchBase $managers_path -Filter *
$Group = Get-ADGroup -Identity ("CN=Managers," + $managers_path)
Add-ADGroupMember -Identity $Group -Members $Users

C:\scripts\5.ps1
