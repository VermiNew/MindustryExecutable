@echo off
title Mindustry Game Installer
color 0b
setlocal enabledelayedexpansion

:retry
REM Prompt for the source path
set "source=jre"
if not exist "!source!" (
    echo Source folder not found.
    exit /b 1
)

REM Prompt for the destination path
:validate_destination
set /p "destination=> Enter the destination path: "

REM Check if anything is entered
if not defined destination (
    echo You must enter a destination path.
    goto validate_destination
)

REM Check if the destination path already exists
if exist "!destination!\jre" (
    echo The destination path already exists. Please choose a different destination.
    goto validate_destination
)

REM Validate the destination path using PowerShell
powershell -command "& { if (Test-Path -PathType Container -LiteralPath ([System.IO.Path]::GetFullPath('%destination%'))) { exit 0 } else { exit 1 } }"
if errorlevel 1 (
    echo The destination path is invalid or does not exist.
    echo Please make sure to provide a correct and existing path.
    goto validate_destination
)

REM Append "MindustryLauncher" to the destination path if it's not already present
if not "!destination:~-1!"=="\" set "destination=!destination!\"
if not "!destination!"=="!destination!MindustryLauncher" (
    set "destination=!destination!MindustryLauncher"
)

REM Confirm the destination path with the user
echo You've entered the following destination path:
echo "!destination!"
set /p "confirm=Is this correct? (Y/N): "
if /i "%confirm%" neq "Y" goto retry

REM Copy the folder to the destination path
echo Copying folder to the destination...
xcopy /s /e /i "!source!" "!destination!\jre" > nul
if errorlevel 1 (
    echo Error copying the folder.
    goto retry
) else (
    echo Folder copied successfully.
)

REM Copy files to the destination path
for %%i in ("config.json" "Mindustry.exe" "MSVCR100.dll") do (
    copy "%%i" "!destination!" > nul
    if errorlevel 1 (
        echo Error copying file: %%i
        goto retry
    ) else (
        echo File copied successfully: %%i
    )
)

echo All files copied successfully.

REM Display the latest version of the repository
echo Checking the latest version of the repository...
set "latestVersion="
for /f "tokens=*" %%a in ('powershell -command "& {(Invoke-RestMethod -Uri 'https://api.github.com/repos/Anuken/MindustryBuilds/releases/latest').tag_name}"') do set "latestVersion=%%a"
echo Latest version of the repository: !latestVersion!

REM Prompt for the game update ID
set /p "updateID=Enter the game update ID: "

REM Validate the update ID using PowerShell
powershell -command "& { try { [System.Net.WebRequest]::Create('https://github.com/Anuken/MindustryBuilds/releases/download/%updateID%/Mindustry-BE-Desktop-%updateID%.jar').GetResponse(); exit 0; } catch { exit 1; } }"
if errorlevel 1 (
    echo Invalid update ID. Please check the update ID.
    goto retry
)

REM Create the download link
set "downloadLink=https://github.com/Anuken/MindustryBuilds/releases/download/%updateID%/Mindustry-BE-Desktop-%updateID%.jar"

REM Download the file to the current directory
echo Downloading file to the current directory...
powershell -command "& { Invoke-WebRequest -Uri '%downloadLink%' -OutFile '.\desktop.jar'; }"
if errorlevel 1 (
    echo Error downloading the file.
    goto retry
) else (
    echo File downloaded successfully.
)

REM Move the file to the destination path
echo Moving file to the destination...
move ".\desktop.jar" "!destination!\jre" > nul
if errorlevel 1 (
    echo Error moving the file.
    goto retry
) else (
    echo File moved successfully.
)

echo Installation completed successfully.
explorer "!destination!"
pause
