# PowerShell安装脚本
# Installing Dependencies

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Installing Dependencies" -ForegroundColor Cyan
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
    Write-Host "[ERROR] Python not found!" -ForegroundColor Red
    Write-Host "Please install Python 3.8+ from https://www.python.org/downloads/" -ForegroundColor Yellow
    Write-Host "Or run '.\检查环境.ps1' to check your system" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "Python found:" -ForegroundColor Green
& $pythonCmd --version
Write-Host ""

# 创建虚拟环境
if (-not (Test-Path "venv")) {
    Write-Host "Creating virtual environment..." -ForegroundColor Green
    & $pythonCmd -m venv venv
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] Failed to create virtual environment" -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
    Write-Host "Virtual environment created." -ForegroundColor Green
} else {
    Write-Host "Virtual environment already exists." -ForegroundColor Green
}
Write-Host ""

# 激活虚拟环境
Write-Host "Activating virtual environment..." -ForegroundColor Green
& "venv\Scripts\Activate.ps1"
Write-Host ""

# 升级pip
Write-Host "Upgrading pip..." -ForegroundColor Green
& $pythonCmd -m pip install --upgrade pip
Write-Host ""

# 安装依赖
Write-Host "Installing dependencies from requirements.txt..." -ForegroundColor Green
Write-Host "This may take a few minutes..." -ForegroundColor Yellow
Write-Host ""
& $pythonCmd -m pip install -r requirements.txt
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "[ERROR] Failed to install some dependencies" -ForegroundColor Red
    Write-Host "Please check your internet connection and try again." -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Installation completed successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "You can now run start.bat or .\启动.ps1 to start the server." -ForegroundColor Yellow
Write-Host ""
Read-Host "Press Enter to exit"

