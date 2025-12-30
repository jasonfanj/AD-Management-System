@echo off
chcp 65001 >nul 2>&1
cls
echo ========================================
echo Installing Dependencies
echo ========================================
echo.

REM Check Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found!
    echo Please install Python 3.8+ from https://www.python.org/downloads/
    pause
    exit /b 1
)

echo Python found:
python --version
echo.

REM Create virtual environment if not exists
if not exist "venv" (
    echo Creating virtual environment...
    python -m venv venv
    if errorlevel 1 (
        echo [ERROR] Failed to create virtual environment
        pause
        exit /b 1
    )
    echo Virtual environment created.
) else (
    echo Virtual environment already exists.
)
echo.

REM Use virtual environment Python
set VENV_PYTHON=venv\Scripts\python.exe

REM Check if virtual environment Python exists
if not exist "%VENV_PYTHON%" (
    echo [ERROR] Virtual environment Python not found
    pause
    exit /b 1
)

REM Upgrade pip
echo Upgrading pip...
"%VENV_PYTHON%" -m pip install --upgrade pip
echo.

REM Install dependencies
echo Installing dependencies from requirements.txt...
echo This may take a few minutes...
echo.
"%VENV_PYTHON%" -m pip install -r requirements.txt
if errorlevel 1 (
    echo.
    echo [ERROR] Failed to install some dependencies
    echo Please check your internet connection and try again.
    pause
    exit /b 1
)

echo.
echo ========================================
echo Installation completed successfully!
echo ========================================
echo.
echo You can now run start.bat to start the server.
echo.
pause
