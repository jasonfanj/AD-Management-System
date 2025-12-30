@echo off
REM AD Management System - 数据库初始化脚本 (Windows)
REM Version: 1.0.0

echo ===========================================
echo   AD Management System - 数据库初始化脚本
echo ===========================================

REM 设置编码为UTF-8
chcp 65001 > nul

REM 检查MySQL环境
echo [INFO] 检查MySQL环境...
mysql --version > nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] 未检测到MySQL客户端，请先安装MySQL或添加mysql到PATH环境变量
    pause
    exit /b 1
)

REM 设置项目路径
set "PROJECT_DIR=%~dp0.."
cd /d "%PROJECT_DIR%"

echo [INFO] 当前工作目录: %cd%
echo [INFO] 数据库脚本路径: %PROJECT_DIR%\database\init.sql

REM 检查数据库初始化脚本是否存在
if not exist "database\init.sql" (
    echo [ERROR] 数据库初始化脚本不存在: %PROJECT_DIR%\database\init.sql
    pause
    exit /b 1
)

echo.
echo [WARN] 此操作将创建/重置数据库 'ad_management_system'
echo [WARN] 现有数据将被清除，请确保已备份重要数据
echo.
set /p CONFIRM="是否继续? (y/N): "
if /i not "%CONFIRM%"=="y" (
    echo [INFO] 操作已取消
    pause
    exit /b 0
)

echo.
echo [INFO] 开始初始化数据库...
echo.

REM 获取数据库连接信息
set MYSQL_HOST=localhost
set MYSQL_PORT=3306
set MYSQL_USER=root
set MYSQL_PASS=123456
set DATABASE_NAME=ad_management_system

echo [INFO] 数据库连接信息:
echo [INFO] 主机: %MYSQL_HOST%:%MYSQL_PORT%
echo [INFO] 用户: %MYSQL_USER%
echo [INFO] 数据库: %DATABASE_NAME%

REM 执行数据库初始化脚本
mysql -h%MYSQL_HOST% -P%MYSQL_PORT% -u%MYSQL_USER% -p%MYSQL_PASS% < database\init.sql

if %errorlevel% neq 0 (
    echo [ERROR] 数据库初始化失败
    echo [INFO] 请检查数据库连接信息和脚本语法
    pause
    exit /b 1
)

echo.
echo [SUCCESS] 数据库初始化完成!
echo.
echo [INFO] 默认管理员账户:
echo [INFO] 用户名: admin
echo [INFO] 密码: admin123
echo.
echo [INFO] 请及时修改默认密码
echo.
pause

