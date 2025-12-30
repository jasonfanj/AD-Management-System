@echo off
chcp 65001 >nul 2>&1
cls
echo ========================================
echo Domain Controller Web - AD Management System
echo ========================================
echo.

REM Check Python installation
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found. Please install Python 3.8+
    echo Download: https://www.python.org/downloads/
    pause
    exit /b 1
)

echo [1/4] Checking Python environment...
python --version
echo.

REM Check virtual environment
if not exist "venv" (
    echo [2/4] Creating virtual environment...
    python -m venv venv
    if errorlevel 1 (
        echo [ERROR] Failed to create virtual environment
        pause
        exit /b 1
    )
    echo Virtual environment created successfully.
) else (
    echo [2/4] Virtual environment exists.
)
echo.

REM Activate virtual environment
echo [3/4] Activating virtual environment...
call venv\Scripts\activate.bat
if errorlevel 1 (
    echo [ERROR] Failed to activate virtual environment
    pause
    exit /b 1
)
echo Virtual environment activated.
echo.

REM Install dependencies
echo [4/4] Installing dependencies...
pip install --upgrade pip >nul 2>&1
pip install -r requirements.txt
if errorlevel 1 (
    echo [ERROR] Failed to install dependencies
    echo Please check your internet connection and try again.
    pause
    exit /b 1
)
echo Dependencies installed successfully.
echo.

echo ========================================
echo Starting backend service...
echo ========================================
echo.
echo Backend API: http://localhost:5000/api
echo Frontend: Open frontend/index.html in browser
echo Default account: admin / admin123
echo.
echo Press Ctrl+C to stop the service
echo ========================================
echo.

python app.py

pause
