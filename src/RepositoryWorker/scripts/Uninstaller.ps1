# Check if the script is running "as Administrator"
$userId=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$userPrincipal=new-object System.Security.Principal.WindowsPrincipal($userId)
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator

if (-not $userPrincipal.IsInRole($adminRole)){
    Write-host "This script needs to be run As Admin";
    exit;
}

Write-Host "Uninstallation PS modules for Git workers"

Remove-Module -Name "GitWorker"
Remove-Module -Name "GitWorkerRestore"

Write-Host "Removing urls files"

if ((Test-Path repositories.txt) -and (Test-Path repositories.txt)) {
  Remove-Item repositories.txt
}

Write-Host "Uninstallation done"