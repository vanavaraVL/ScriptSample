Import-Module GitWorker
Import-Module GitWorkerRestore

$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
$file = "$scriptPath" + "\" + "repositories.txt"

Write-host "Working with the file: $file";

$pipeline=$args[0]

$stream_reader = New-Object System.IO.StreamReader($file)
$line_number = 1

while (($current_line =$stream_reader.ReadLine()) -ne $null)
{
	if ($pipeline -eq 'restore') {
		Git-Worker-Restore -projectUrl $current_line
	} else {
		Git-Worker -projectUrl $current_line
	}
	
	$line_number++
}

$stream_reader.Close()