@echo off
chcp 65001 >nul 2>&1
cls
title Domain Controller Web - Quick Start

REM Check if virtual environment exists
if not exist "venv" (
    echo Virtual environment not found. Running install.bat first...
    echo.
    call install.bat
    if errorlevel 1 (
        echo Installation failed. Please check the errors above.
        pause
        exit /b 1
    )
)

REM Activate virtual environment and start
echo Activating virtual environment...
call venv\Scripts\activate.bat

echo.
echo Starting server...
echo.
python app.py

pause

