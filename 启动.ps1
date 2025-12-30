# PowerShell启动脚本
# Domain Controller Web - AD Management System

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Domain Controller Web - AD Management System" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查Python
$pythonFound = $false
$pythonCmd = $null

# 尝试 python 命令
try {
    $pythonVersion = python --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        $pythonFound = $true
        $pythonCmd = "python"
    }
} catch {
    # 继续检查
}

# 尝试 python3 命令
if (-not $pythonFound) {
    try {
        $pythonVersion = python3 --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            $pythonFound = $true
            $pythonCmd = "python3"
        }
    } catch {
        # 继续检查
    }
}

if (-not $pythonFound) {
    Write-Host "[ERROR] Python not found. Please install Python 3.8+" -ForegroundColor Red
    Write-Host ""
    Write-Host "Solutions:" -ForegroundColor Yellow
    Write-Host "1. Download from: https://www.python.org/downloads/" -ForegroundColor White
    Write-Host "2. During installation, check 'Add Python to PATH'" -ForegroundColor White
    Write-Host "3. Run '.\检查环境.ps1' to check your system" -ForegroundColor White
    Write-Host ""
    Write-Host "Or install from Microsoft Store: Search 'Python'" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "[1/4] Checking Python environment..." -ForegroundColor Green
& $pythonCmd --version
Write-Host ""

# 检查虚拟环境
if (-not (Test-Path "venv")) {
    Write-Host "[2/4] Creating virtual environment..." -ForegroundColor Green
    & $pythonCmd -m venv venv
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] Failed to create virtual environment" -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
    Write-Host "Virtual environment created successfully." -ForegroundColor Green
} else {
    Write-Host "[2/4] Virtual environment exists." -ForegroundColor Green
}
Write-Host ""

# 激活虚拟环境
Write-Host "[3/4] Activating virtual environment..." -ForegroundColor Green
& "venv\Scripts\Activate.ps1"
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Failed to activate virtual environment" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}
Write-Host "Virtual environment activated." -ForegroundColor Green
Write-Host ""

# 安装依赖
Write-Host "[4/4] Installing dependencies..." -ForegroundColor Green
& $pythonCmd -m pip install --upgrade pip | Out-Null
& $pythonCmd -m pip install -r requirements.txt
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Failed to install dependencies" -ForegroundColor Red
    Write-Host "Please check your internet connection and try again." -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}
Write-Host "Dependencies installed successfully." -ForegroundColor Green
Write-Host ""

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

# 启动应用
& $pythonCmd app.py

