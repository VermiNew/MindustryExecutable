@echo off
setlocal EnableDelayedExpansion
color 0b

echo ************************************************************
echo * Welcome to the Mindustry Installer                       *
echo ************************************************************
echo.

timeout 1 /NOBREAK
echo Starting...

cd files

set "installerPath=..\bin\installer.bat"

if not exist "!installerPath!" (
    echo Error: Installer not found in the specified location.
    echo Please make sure the installer is in the 'bin' directory.
    color 0c
    exit /b 1
)

cls
call "!installerPath!"

if %errorlevel% neq 0 (
    echo An error occurred during installation. Please check the logs for details.
    color 0c
    exit /b %errorlevel%
)

echo.
echo ************************************************************
echo * Mindustry Installation Completed                         *
echo ************************************************************

color 0f
title Mindustry Installer - Completed
endlocal
