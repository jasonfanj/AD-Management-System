# Start script using full Python path
# 使用完整路径启动脚本

$pythonPath = "C:\Users\CEM\AppData\Local\Programs\Python\Python314"
$pythonExe = Join-Path $pythonPath "python.exe"

if (-not (Test-Path $pythonExe)) {
    Write-Host "[ERROR] Python not found at: $pythonExe" -ForegroundColor Red
    Write-Host "Please run .\check-env.ps1 to find Python installation" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Domain Controller Web - AD Management System" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Using Python: $pythonExe" -ForegroundColor Yellow
Write-Host ""

# Check virtual environment
if (-not (Test-Path "venv")) {
    Write-Host "Creating virtual environment..." -ForegroundColor Green
    & $pythonExe -m venv venv
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] Failed to create virtual environment" -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
    Write-Host "Virtual environment created." -ForegroundColor Green
    Write-Host ""
}

# Activate virtual environment
Write-Host "Activating virtual environment..." -ForegroundColor Green
& "venv\Scripts\Activate.ps1"
Write-Host ""

# Install dependencies if needed
if (-not (Test-Path "venv\Lib\site-packages\flask")) {
    Write-Host "Installing dependencies..." -ForegroundColor Green
    & $pythonExe -m pip install --upgrade pip | Out-Null
    & $pythonExe -m pip install -r requirements.txt
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] Failed to install dependencies" -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
    Write-Host "Dependencies installed." -ForegroundColor Green
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Starting backend service..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Backend API: http://localhost:5000/api" -ForegroundColor Yellow
Write-Host "Frontend: Open frontend/index.html in browser" -ForegroundColor Yellow
Write-Host "Default account: admin / admin123" -ForegroundColor Yellow
Write-Host ""
Write-Host "Press Ctrl+C to stop the service" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Start application
& $pythonExe app.py

