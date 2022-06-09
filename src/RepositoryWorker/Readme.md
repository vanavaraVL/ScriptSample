# 1. Project descriptions
Repository worker allows to get all remote repository's urls, saves them into the file for the future correctioning and moves master branch into the development branch with saving existing development branch as backup 

## Prerequirements: 

Before execute the script the following steps should be done first.
In the [Initializator](./scripts/Initializator.ps1) the parameters have to be configured as:

1) $repositoryUrl - organization's url to the git repository
2) $token - user's personal access token in the git repository. Can be initialized for the specific user or used as internal system user:
```
Git->User settings->Access tokens->Personal access tokens
```
Selected scopes should be defined in order to allow access using git API

3) $gitGroup - identity of the selected project's group in the git

## Short script description:

[Initializator](./scripts/Initializator.ps1) 
The script for environment initialization. Performs the following steps:
- Install mandatory modules of the script to the PowerShell folder (see #2 for more details)
- Get all remote repositories from the organization's git repository and save project's urls into the text file 'repositories.txt' in the ongoing script's folder
- Text file [repositories.txt] could be modified manually for certain selected project's urls only or keep as is  

Usage (should be run with Administrative privileges):
```
.\Initializator.ps1
```

[RepositoryWorker](./scripts/RepositoryWorker.ps1)
Entry point for script execution.
Allows to move master branch of ongoing project to the development with saving development branch as backup.
Can be run in two ways:

- Main bullet:
Moves master branch for each remote project that is in the repositories.txt file
Src folder will be used as temporary folder that contains all downloaded remote projects
```
.\RepositoryWorker.ps1
```

- Revert bullet:
Allows to revert changes that have been made on main bullet way (restores development branch from the created backup in main bullet way)
```
.\RepositoryWorker.ps1 restore
```

[Uninstaller](./scripts/Uninstaller.ps1)
Performs uninstallation process:
- Removes modules from the PowerShell folder
- Removes the repositories.txt file

Usage (should be run with Administrative privileges):
```
.\Uninstaller.ps1
```

# 2. Ongoing modules

## a) Main bullet servicing module:

[Git worker](./scripts/Modules/GitWorker.psm1)
Allows to move master to development branch and save existing development branch as backup with _backup postfix

Internal script's module. Needs to be deployed using [Initializator](./scripts/Initializator.ps1)

## b) Revert bullet servicing module:

[Git restorer](./scripts/Modules/GitWorkerRestore.psm1)
Allows to revert development branch from backup development's branch

Internal script's module. Needs to be deployed using [Initializator](./scripts/Initializator.ps1) 
