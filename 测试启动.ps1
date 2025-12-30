# 测试服务启动
Write-Host "Testing service startup..." -ForegroundColor Cyan
Write-Host ""

$pythonExe = "venv\Scripts\python.exe"

if (-not (Test-Path $pythonExe)) {
    Write-Host "[ERROR] Virtual environment Python not found" -ForegroundColor Red
    Write-Host "Please run .\install.bat first" -ForegroundColor Yellow
    exit 1
}

Write-Host "1. Testing imports..." -ForegroundColor Yellow
& $pythonExe -c "import app; print('   [OK] App imports successfully')"
if ($LASTEXITCODE -ne 0) {
    Write-Host "   [ERROR] Import failed" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "2. Testing database initialization..." -ForegroundColor Yellow
& $pythonExe -c "from app import app, db; app.app_context().push(); db.create_all(); print('   [OK] Database initialized')"
if ($LASTEXITCODE -ne 0) {
    Write-Host "   [ERROR] Database initialization failed" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "3. Starting service..." -ForegroundColor Yellow
Write-Host "   Service will start in background. Check http://localhost:5000/api/system/health" -ForegroundColor Cyan
Write-Host ""

# 启动服务
Start-Process -FilePath $pythonExe -ArgumentList "app.py" -NoNewWindow

Write-Host "Service started! Waiting 5 seconds..." -ForegroundColor Green
Start-Sleep -Seconds 5

Write-Host ""
Write-Host "4. Testing service endpoint..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:5000/api/system/health" -UseBasicParsing -TimeoutSec 3
    Write-Host "   [OK] Service is running! Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "   Response: $($response.Content)" -ForegroundColor Cyan
} catch {
    Write-Host "   [WARNING] Service may still be starting or there's an error" -ForegroundColor Yellow
    Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "If service is running, you can:" -ForegroundColor Yellow
Write-Host "1. Open frontend/index.html in browser" -ForegroundColor White
Write-Host "2. Login with: admin / admin123" -ForegroundColor White
Write-Host "3. Access API at: http://localhost:5000/api" -ForegroundColor White
Write-Host ""
Write-Host "To stop the service, find the Python process and terminate it" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan

