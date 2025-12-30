# Environment Check Script
# 环境检查脚本

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "System Environment Check" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check Python
Write-Host "Checking Python..." -ForegroundColor Yellow
$pythonFound = $false
$pythonCmd = $null

# Method 1: Check python command
try {
    $pythonVersion = python --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] Python found: $pythonVersion" -ForegroundColor Green
        $pythonFound = $true
        $pythonCmd = "python"
    }
} catch {
    # Continue checking
}

# Method 2: Check python3 command
if (-not $pythonFound) {
    try {
        $pythonVersion = python3 --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "[OK] Python3 found: $pythonVersion" -ForegroundColor Green
            $pythonFound = $true
            $pythonCmd = "python3"
        }
    } catch {
        # Continue checking
    }
}

# Method 3: Check common installation paths
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

# If Python not found
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

# Check pip
if ($pythonFound) {
    Write-Host "Checking pip..." -ForegroundColor Yellow
    try {
        $pipVersion = & $pythonCmd -m pip --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "[OK] pip found: $pipVersion" -ForegroundColor Green
        } else {
            Write-Host "[WARNING] pip not found. Run: $pythonCmd -m ensurepip --upgrade" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "[WARNING] pip check failed" -ForegroundColor Yellow
    }
    Write-Host ""
}

# Check virtual environment
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

