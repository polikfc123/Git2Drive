@echo off
:: set google drive directory here
set "GOOGLE_DRIVE_DIR=C:\path\to\GoogleDrive\Backups"

:: sets directory for temporary clone
set "TEMP_CLONE_DIR=%GOOGLE_DRIVE_DIR%\temp_clone"

:: sets location for final backup location. DO NOT TOUCH!!!!!
set "FINAL_BACKUP_DIR=%GOOGLE_DRIVE_DIR%\repository_backup"

:: put your github personal access token here
set "GITHUB_TOKEN=your_personal_access_token"

:: set github repository URL here
set "GITHUB_REPO=https://%GITHUB_TOKEN%@github.com/username/repository.git"

:: set the time interval (in seconds) for the backup (3600 seconds = 1 hour)
set "INTERVAL=3600"

:: starts loop for automatic backups
:LOOP
echo Backing up the repository...

:: removes old temporary clones
if exist "%TEMP_CLONE_DIR%" (
    echo Removing old temporary clone directory...
    rmdir /s /q "%TEMP_CLONE_DIR%"
)

:: clones repository to temporary directory
echo Cloning repository to temporary directory...
git clone %GITHUB_REPO% "%TEMP_CLONE_DIR%"

:: copies repository to final location
echo Copying repository to final backup location...
xcopy "%TEMP_CLONE_DIR%" "%FINAL_BACKUP_DIR%" /e /y /i

:: removes temporary clone
echo Removing temporary clone directory...
rmdir /s /q "%TEMP_CLONE_DIR%"

:: waits for next backup
timeout /t %INTERVAL% /nobreak

:: repeats the loop
goto LOOP
