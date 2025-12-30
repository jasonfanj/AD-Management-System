# Fix Python PATH Script
# 修复 Python PATH 环境变量

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Python PATH Fix Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Find Python installation
$pythonPath = "C:\Users\CEM\AppData\Local\Programs\Python\Python314"
$pythonExe = Join-Path $pythonPath "python.exe"
$scriptsPath = Join-Path $pythonPath "Scripts"

if (Test-Path $pythonExe) {
    Write-Host "[FOUND] Python at: $pythonPath" -ForegroundColor Green
    Write-Host ""
    
    # Check if already in PATH
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($currentPath -like "*$pythonPath*") {
        Write-Host "[INFO] Python is already in PATH" -ForegroundColor Yellow
    } else {
        Write-Host "Adding Python to PATH..." -ForegroundColor Yellow
        
        # Add to current session
        $env:Path += ";$pythonPath;$scriptsPath"
        Write-Host "[OK] Added to current session" -ForegroundColor Green
        
        # Add to user PATH permanently
        try {
            $newPath = $currentPath + ";$pythonPath;$scriptsPath"
            [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
            Write-Host "[OK] Added to user PATH permanently" -ForegroundColor Green
            Write-Host ""
            Write-Host "Note: You may need to restart PowerShell for changes to take effect" -ForegroundColor Yellow
        } catch {
            Write-Host "[WARNING] Could not add to permanent PATH. You may need admin rights." -ForegroundColor Yellow
            Write-Host "You can add it manually:" -ForegroundColor Yellow
            Write-Host "  Path: $pythonPath" -ForegroundColor White
            Write-Host "  Scripts: $scriptsPath" -ForegroundColor White
        }
    }
    
    Write-Host ""
    Write-Host "Testing Python..." -ForegroundColor Yellow
    & $pythonExe --version
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[SUCCESS] Python is working!" -ForegroundColor Green
    }
} else {
    Write-Host "[ERROR] Python not found at expected location" -ForegroundColor Red
    Write-Host "Please run .\check-env.ps1 to find Python installation" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan

