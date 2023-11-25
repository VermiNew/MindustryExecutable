@echo off
title Mindustry Game Installer
setlocal enabledelayedexpansion

REM Pytanie o ścieżkę źródłową
set "source=jre"
if not exist "!source!" (
    echo Source folder not found.
    exit /b 1
)

REM Pytanie o ścieżkę docelową
set /p "destination=Enter the destination path: "
if not exist "!destination!" (
    mkdir "!destination!"
)

REM Skopiowanie folderu do docelowej ścieżki
echo Copying folder to the destination...
xcopy /s /e /i "!source!" "!destination!\jre"

REM Kopiowanie plików
copy "config.json" "!destination!"
copy "Mindustry.exe" "!destination!"
copy "MSVCR100.dll" "!destination!"

echo Folder copied successfully.

REM Pytanie o ID update gry
set /p "updateID=Enter the game update ID: "

REM Utworzenie linku do pobrania pliku
set "downloadLink=https://github.com/Anuken/MindustryBuilds/releases/download/%updateID%/Mindustry-BE-Desktop-%updateID%.jar"

REM Sprawdzenie, czy link jest poprawny
powershell -command "& { try { $webRequest = [System.Net.WebRequest]::Create('%downloadLink%'); $webRequest.GetResponse(); echo 'Link is valid.'; } catch { echo 'Invalid link. Please check the update ID.'; exit 1; } }"

REM Pobranie pliku do folderu download
echo Downloading file to the current directory...
powershell -command "& { Invoke-WebRequest -Uri '%downloadLink%' -OutFile '.\desktop.jar'; }"

REM Przeniesienie pliku do docelowej ścieżki
echo Moving file to the destination...
move ".\desktop.jar" "!destination!\jre"

echo File moved successfully.

echo File downloaded and moved successfully.
pause
