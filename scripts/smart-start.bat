@echo off
REM AD Management System - Smart Start Script (Windows)
REM Version: 2.0.0
REM Auto detect environment, auto install dependencies, auto start services

setlocal enabledelayedexpansion
chcp 936 > nul 2>&1

echo ===========================================
echo    AD Management System - 智能一键启动
echo ===========================================
echo.

set "PROJECT_DIR=%~dp0.."
cd /d "%PROJECT_DIR%"

REM 第一步：环境检测
echo [步骤 1/4] 检测运行环境...
call "%~dp0check-env.bat"
if %errorlevel% neq 0 (
    echo.
    echo [提示] 检测到环境缺失，正在尝试自动安装...
    call "%~dp0auto-setup-env.bat"
    
    REM 再次检测环境
    echo.
    echo [步骤 1/4] 重新检测运行环境...
    call "%~dp0check-env.bat"
    if %errorlevel% neq 0 (
        echo.
        echo [错误] 环境配置失败，请手动安装缺失的组件后重试
        pause
        exit /b 1
    )
)

echo.
echo [步骤 2/4] 检查并安装前端依赖...

cd frontend
if not exist "node_modules" (
    echo [安装] 正在安装前端依赖，请稍候...
    call npm install
    if %errorlevel% neq 0 (
        echo [错误] 前端依赖安装失败
        cd ..
        pause
        exit /b 1
    )
    echo [OK] 前端依赖安装完成
) else (
    echo [OK] 前端依赖已存在
)
cd ..

echo.
echo [步骤 3/4] 启动后端服务...
start "AD Management System - Backend" cmd /k "cd /d %PROJECT_DIR% && call scripts\start-backend.bat"

REM 等待后端启动
echo [等待] 等待后端服务启动（15秒）...
timeout /t 15 /nobreak > nul

echo.
echo [步骤 4/4] 启动前端服务...
start "AD Management System - Frontend" cmd /k "cd /d %PROJECT_DIR% && call scripts\start-frontend.bat"

echo.
echo ===========================================
echo         所有服务启动完成！
echo ===========================================
echo.
echo [信息] 后端服务: http://localhost:8080/api
echo [信息] 前端服务: http://localhost:3000
echo [信息] API文档: http://localhost:8080/api/swagger-ui.html
echo.
echo [提示] 服务已在独立窗口中运行
echo [提示] 请在浏览器中访问前端服务地址
echo [提示] 关闭服务窗口即可停止服务
echo.
echo [提示] 按任意键关闭此窗口（服务将继续运行）...
pause > nul

