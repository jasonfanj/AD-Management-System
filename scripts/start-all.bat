@echo off
REM AD Management System - 一键启动脚本 (Windows)
REM Version: 1.0.0

echo ===========================================
echo    AD Management System - 一键启动脚本
echo ===========================================

REM 设置编码为UTF-8
chcp 65001 > nul

REM 检查数据库连接（可选）
echo [INFO] 提示: 请确保MySQL数据库服务已启动
echo [INFO] 提示: 请确保Redis服务已启动（如使用）
echo.

REM 启动后端服务
echo [INFO] 启动后端服务...
start "Backend Service" cmd /c "%~dp0start-backend.bat"

REM 等待后端服务启动
timeout /t 15 /nobreak > nul

REM 启动前端服务
echo [INFO] 启动前端服务...
start "Frontend Service" cmd /c "%~dp0start-frontend.bat"

echo.
echo ===========================================
echo         服务启动完成!
echo ===========================================
echo.
echo [INFO] 后端服务: http://localhost:8080/api
echo [INFO] 前端服务: http://localhost:3000
echo [INFO] API文档: http://localhost:8080/api/swagger-ui.html
echo.
echo [INFO] 请在浏览器中访问前端服务地址
echo [INFO] 按任意键关闭所有服务窗口...
pause > nul

REM 停止所有相关进程（可选）
REM taskkill /f /im java.exe > nul 2>&1
REM taskkill /f /im node.exe > nul 2>&1

