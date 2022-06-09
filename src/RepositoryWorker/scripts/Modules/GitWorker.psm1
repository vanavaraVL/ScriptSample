Function Git-Worker([string]$projectUrl)
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

	Write-Host "Moving master into development branch"

	git branch develop_tmp
	git push origin develop_tmp
	
	git switch develop
	git pull

	git branch -m develop_backup
	git push origin :develop develop_backup
	git push origin -u develop_backup

	git branch -m develop_tmp develop
	git push origin :develop_tmp develop
	git push origin -u develop
	
	Write-Host "Development is up to date"
	
	cd ../..
}