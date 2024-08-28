@echo off
:: Set the directory where the GitHub repository is located
set "REPO_DIR=C:\path\to\your\repository"

:: directory where google drive is synced
set "BACKUP_DIR=C:\path\to\GoogleDrive\Backups"

:: replace with your github Personal Access Token
set "GITHUB_TOKEN=your_personal_access_token"

:: Github repo URL (replace with your own)
set "GITHUB_REPO=https://%GITHUB_TOKEN%@github.com/username/repository.git"

:: Sets time interval in seconds for backup. Modify to whatever you want.
set "INTERVAL=3600"

:: Start the loop for automatic backups
:LOOP
echo Backing up the repository...

:: Change to the repository directory
cd /d "%REPO_DIR%"

:: Pull the latest changes from the GitHub repository using the token for authentication
git pull %GITHUB_REPO%

:: copies repository to google drive
xcopy "%REPO_DIR%" "%BACKUP_DIR%\repository_backup" /e /y /i

:: wait for next backup
timeout /t %INTERVAL% /nobreak

:: repeats loop
goto LOOP
