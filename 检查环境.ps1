# 环境检查脚本
# Check System Environment

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "System Environment Check" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查Python
Write-Host "Checking Python..." -ForegroundColor Yellow
$pythonFound = $false

# 方法1: 检查 python 命令
try {
    $pythonVersion = python --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] Python found: $pythonVersion" -ForegroundColor Green
        $pythonFound = $true
    }
} catch {
    # 继续检查其他方法
}

# 方法2: 检查 python3 命令
if (-not $pythonFound) {
    try {
        $pythonVersion = python3 --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "[OK] Python3 found: $pythonVersion" -ForegroundColor Green
            $pythonFound = $true
        }
    } catch {
        # 继续检查
    }
}

# 方法3: 检查常见安装路径
if (-not $pythonFound) {
    $commonPaths = @(
        "$env:LOCALAPPDATA\Programs\Python",
        "$env:ProgramFiles\Python*",
        "$env:ProgramFiles(x86)\Python*",
        "C:\Python*",
        "$env:USERPROFILE\AppData\Local\Programs\Python"
    )
    
    Write-Host "Checking common Python installation paths..." -ForegroundColor Yellow
    foreach ($path in $commonPaths) {
        $found = Get-ChildItem -Path $path -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "Python*" }
        if ($found) {
            Write-Host "[FOUND] Python may be installed at: $($found.FullName)" -ForegroundColor Yellow
            Write-Host "       But it's not in PATH. You may need to add it manually." -ForegroundColor Yellow
        }
    }
}

# 如果未找到Python
if (-not $pythonFound) {
    Write-Host ""
    Write-Host "[ERROR] Python not found in PATH!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Solutions:" -ForegroundColor Yellow
    Write-Host "1. Install Python 3.8+ from: https://www.python.org/downloads/" -ForegroundColor White
    Write-Host "2. During installation, make sure to check 'Add Python to PATH'" -ForegroundColor White
    Write-Host "3. After installation, restart PowerShell/CMD" -ForegroundColor White
    Write-Host ""
    Write-Host "Quick Install (if you have Chocolatey):" -ForegroundColor Yellow
    Write-Host "   choco install python" -ForegroundColor White
    Write-Host ""
    Write-Host "Or download from Microsoft Store:" -ForegroundColor Yellow
    Write-Host "   Search 'Python' in Microsoft Store" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "[SUCCESS] Python is ready!" -ForegroundColor Green
    Write-Host ""
}

# 检查pip
if ($pythonFound) {
    Write-Host "Checking pip..." -ForegroundColor Yellow
    try {
        $pipVersion = pip --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "[OK] pip found: $pipVersion" -ForegroundColor Green
        } else {
            Write-Host "[WARNING] pip not found. Run: python -m ensurepip --upgrade" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "[WARNING] pip check failed" -ForegroundColor Yellow
    }
    Write-Host ""
}

# 检查虚拟环境
Write-Host "Checking virtual environment..." -ForegroundColor Yellow
if (Test-Path "venv") {
    Write-Host "[OK] Virtual environment exists" -ForegroundColor Green
    if (Test-Path "venv\Scripts\python.exe") {
        Write-Host "[OK] Virtual environment Python found" -ForegroundColor Green
    }
} else {
    Write-Host "[INFO] Virtual environment not found (will be created on first run)" -ForegroundColor Cyan
}
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Read-Host "Press Enter to exit"

