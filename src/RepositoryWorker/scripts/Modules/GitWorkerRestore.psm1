Function Git-Worker-Restore([string]$projectUrl)
{
	$url = [uri]$projectUrl
	$path_segment = $url.segments[-1]
	$project_name = ([io.fileinfo]$path_segment).basename

	Write-Host "Getting project $project_name"
	
	cd src
	git clone $url
	cd $project_name

	git switch master
	git pull

	Write-Host "Restoring development branch"

	git switch develop_backup
	git pull

	git branch -d develop
	git push origin --delete develop

	git branch -m develop
	git push origin :develop_backup  develop
	git push origin -u develop

	git switch develop
	git pull
	
	Write-Host "Development is up to date"
	
	cd ../..
}