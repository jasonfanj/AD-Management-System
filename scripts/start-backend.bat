@echo off
REM AD Management System - 后端启动脚本 (Windows)
REM Version: 1.0.0

echo ===========================================
echo    AD Management System - 后端启动脚本
echo ===========================================

REM 设置编码为UTF-8
chcp 65001 > nul

REM 检查Java环境
echo [INFO] 检查Java环境...
java -version > nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] 未检测到Java环境，请先安装JDK 17+
    pause
    exit /b 1
)

REM 检查Maven环境
echo [INFO] 检查Maven环境...
mvn -version > nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] 未检测到Maven环境，请先安装Maven
    pause
    exit /b 1
)

REM 设置项目路径
set "PROJECT_DIR=%~dp0.."
cd /d "%PROJECT_DIR%"

echo [INFO] 当前工作目录: %cd%
echo [INFO] 后端项目路径: %PROJECT_DIR%\backend

REM 检查后端项目是否存在
if not exist "backend" (
    echo [ERROR] 后端项目目录不存在: %PROJECT_DIR%\backend
    pause
    exit /b 1
)

cd backend

REM 检查pom.xml是否存在
if not exist "pom.xml" (
    echo [ERROR] pom.xml文件不存在
    pause
    exit /b 1
)

echo.
echo [INFO] 开始编译后端项目...
echo.

REM 清理并编译项目
call mvn clean compile -DskipTests
if %errorlevel% neq 0 (
    echo [ERROR] 后端项目编译失败
    pause
    exit /b 1
)

echo.
echo [INFO] 开始启动后端服务...
echo.

REM 启动Spring Boot应用
start "AD Management System Backend" cmd /k "mvn spring-boot:run -Dspring-boot.run.profiles=dev"

echo.
echo [SUCCESS] 后端服务启动中...
echo [INFO] 服务启动需要一些时间，请稍等...
echo [INFO] 后端服务地址: http://localhost:8080/api
echo [INFO] API文档地址: http://localhost:8080/api/swagger-ui.html
echo.
echo [INFO] 按任意键关闭此窗口...
pause > nul

