@echo off
REM AD Management System - 前端启动脚本 (Windows)
REM Version: 1.0.0

echo ===========================================
echo    AD Management System - 前端启动脚本
echo ===========================================

REM 设置编码为UTF-8
chcp 65001 > nul

REM 检查Node.js环境
echo [INFO] 检查Node.js环境...
node --version > nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] 未检测到Node.js环境，请先安装Node.js 18+
    pause
    exit /b 1
)

REM 检查npm环境
echo [INFO] 检查npm环境...
npm --version > nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] 未检测到npm环境
    pause
    exit /b 1
)

REM 设置项目路径
set "PROJECT_DIR=%~dp0.."
cd /d "%PROJECT_DIR%"

echo [INFO] 当前工作目录: %cd%
echo [INFO] 前端项目路径: %PROJECT_DIR%\frontend

REM 检查前端项目是否存在
if not exist "frontend" (
    echo [ERROR] 前端项目目录不存在: %PROJECT_DIR%\frontend
    pause
    exit /b 1
)

cd frontend

REM 检查package.json是否存在
if not exist "package.json" (
    echo [ERROR] package.json文件不存在
    pause
    exit /b 1
)

echo.
echo [INFO] 检查并安装依赖...
echo.

REM 检查node_modules是否存在
if not exist "node_modules" (
    echo [INFO] 安装项目依赖，这可能需要一些时间...
    call npm install
    if %errorlevel% neq 0 (
        echo [ERROR] 依赖安装失败
        pause
        exit /b 1
    )
) else (
    echo [INFO] 依赖已存在，跳过安装步骤
)

echo.
echo [INFO] 开始启动前端开发服务器...
echo.

REM 启动Vue开发服务器
start "AD Management System Frontend" cmd /k "npm run dev"

echo.
echo [SUCCESS] 前端开发服务器启动中...
echo [INFO] 前端服务地址: http://localhost:3000
echo [INFO] 后端API代理地址: http://localhost:8080/api
echo.
echo [INFO] 按任意键关闭此窗口...
pause > nul

