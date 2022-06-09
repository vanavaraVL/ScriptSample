param (
    [string]$repositoryUrl = "https://git.pik.ru",
    [string]$token= "a9Jh8fcdrSKioRywN6oG",
	[int]$gitGroup = 211
)

# Check if the script is running "as Administrator"
$userId=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$userPrincipal=new-object System.Security.Principal.WindowsPrincipal($userId)
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator

if (-not $userPrincipal.IsInRole($adminRole)){
    Write-host "This script needs to be run As Admin";
    exit;
}

# Copy script modules into the power shell module folder for sharing usage
Write-Host "Copying modules into the PS modules folder"

New-Item -Path "c:\windows\System32\WindowsPowerShell\v1.0\Modules\GitWorker" -Name "GitWorker" -ItemType "directory" -force
Copy-Item .\Modules\GitWorker.psm1 -Destination c:\windows\System32\WindowsPowerShell\v1.0\Modules\GitWorker -force

New-Item -Path "c:\windows\System32\WindowsPowerShell\v1.0\Modules\GitWorkerRestore" -Name "GitWorkerRestore" -ItemType "directory" -force
Copy-Item .\Modules\GitWorkerRestore.psm1 -Destination c:\windows\System32\WindowsPowerShell\v1.0\Modules\GitWorkerRestore -force

Write-Host "Copying done"

Write-Host "Getting remote repositories"

# Get all remote repositories
# Getter requests page by page as soon as it gets the end number of the projects in the git repository
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

if ((Test-Path repositories.txt) -and (Test-Path repositories.txt)) {
  Remove-Item repositories.txt
}


$page = 1
$process = $False

Do {

	$requestUrl = $repositoryUrl + "/api/v4/groups/" + $gitGroup + "/projects?per_page=5000&include_subgroups=true&simple=1&membership=true&page=" + $page
	
	try {
		Write-Host "Getting repositories for $page page GitLab"
		$projects = (Invoke-WebRequest -URI $requestUrl -Headers @{"Private-Token"=$token} ).content | ConvertFrom-Json
	}
	catch [System.Net.WebException] {
		if($_.Exception.Response.StatusCode.value__ -eq 404) {
			write-host "Url is not correct"
		} else {
			write-host $_.Exception.Message
		} 
		exit
	}

	$projects | ForEach-Object {
		if($_.empty_repo -or $_.archived) {
			Write-host  "Skipping empty/archived repository '$_.name'"
			return;
		}
		
		$name =  $_.name
		$namespace=  $_.path_with_namespace.Replace('`\','/')
		$url = $_.http_url_to_repo
			
		Write-Host "Received $name project [$namespace]"
		
		Add-Content -Path repositories.txt -Value $url
	}
	
	$page++
	$requestUrl = ""
	
	if ($projects.Count -gt 0){
		$process = $False
	}
	else {
		$process = $True
	}
}
Until($process)

Write-Host "Initialization has been completed"