## This script will configure file service , create some files and directorie , share them
## & maybe run another script\s on next login so be aware ..

$shared_path = "C:\shared"
$tech_path = "C:\shared\Tech"
$managers_path = "C:\shared\Managers"

# create if not exist path's
if (-not (Test-Path C:\shared)) {
  New-Item $shared_path -ItemType Directory
  New-Item $tech_path -ItemType Directory
  New-Item $managers_path -ItemType Directory
} else { if (-not (Test-Path C:\shared\Tech)) {
    New-Item $tech_path -ItemType Directory
  }
  if (-not (Test-Path C:\shared\Managers)) {
    New-Item $managers_path -ItemType Directory
  }
}

# share permision
New-SmbShare -Name "shared" -Path $shared_path -FullAccess "Authenticated Users"

# ntfs permision
function Set-Permission {
  param(
    [string]$StartingDir,
    [string]$UserOrGroup = "",
    [string]$InheritedFolderPermissions = "ContainerInherit, ObjectInherit",
    [string]$AccessControlType = "Allow",
    [string]$PropagationFlags = "None",
    [string]$AclRightsToAssign)
  ### The possible values for Rights are:
  # ListDirectory, ReadData, WriteData, CreateFiles, CreateDirectories, AppendData, Synchronize, FullControl
  # ReadExtendedAttributes, WriteExtendedAttributes, Traverse, ExecuteFile, DeleteSubdirectoriesAndFiles, ReadAttributes 
  # WriteAttributes, Write, Delete, ReadPermissions, Read, ReadAndExecute, Modify, ChangePermissions, TakeOwnership
  ### Principal expected
  # domain\username 
  ### Inherited folder permissions:
  # Object inherit    - This folder and files. (no inheritance to subfolders)
  # Container inherit - This folder and subfolders.
  # Inherit only      - The ACE does not apply to the current file/directory
  #define a new access rule.
  $acl = Get-Acl -Path $StartingDir
  $perm = $UserOrGroup,$AclRightsToAssign,$InheritedFolderPermissions,$PropagationFlags,$AccessControlType
  $rule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $perm
  $acl.SetAccessRule($rule)
  Set-Acl -Path $StartingDir $acl
}
function Remove-Permission ($StartingDir,$UserOrGroup = "",$All = $false) {
  $acl = Get-Acl -Path $StartingDir
  if ($UserOrGroup -ne "") {
    foreach ($access in $acl.Access) {
      if ($access.IdentityReference.Value -eq $UserOrGroup) {
        $acl.RemoveAccessRule($access) | Out-Null
      }
    }
  }
  if ($All -eq $true) {
    foreach ($access in $acl.Access) {
      $acl.RemoveAccessRule($access) | Out-Null
    }
  }
  Set-Acl -Path $StartingDir -AclObject $acl
}
Remove-Permission -StartingDir $managers_path -UserOrGroup "Users" -All $true
Remove-Permission -StartingDir $tech_path -UserOrGroup "Users" -All $true
Set-Permission -StartingDir $managers_path -UserOrGroup "Managers" -AclRightsToAssign "Modify"
Set-Permission -StartingDir $tech_path -UserOrGroup "Tech" -AclRightsToAssign "Modify"

# remove inheritance option for tech folder
$tech_acl = Get-Acl -Path $tech_path
$tech_acl.SetAccessRuleProtection($True,$True)
Set-Acl -Path $tech_path -AclObject $tech_acl

# remove inheritance option for managers folder
$managers_acl = Get-Acl -Path $managers_path
$managers_acl.SetAccessRuleProtection($True,$True)
Set-Acl -Path $managers_path -AclObject $managers_acl

C:\scripts\6.ps1
