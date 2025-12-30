@echo off
REM AD Management System - Environment Check Script (Windows)
REM Version: 2.0.0

setlocal enabledelayedexpansion
chcp 936 > nul 2>&1

echo ===========================================
echo    AD Management System - 环境检测工具
echo ===========================================
echo.

set "ERROR_FLAG=0"
set "JAVA_VERSION="
set "MAVEN_VERSION="
set "NODE_VERSION="
set "NPM_VERSION="

REM 检测Java环境
echo [检查] 检测Java环境...
java -version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=3" %%g in ('java -version 2^>^&1 ^| findstr /i "version"') do (
        set "JAVA_VERSION=%%g"
        goto :java_found
    )
    :java_found
    echo [OK] Java已安装: !JAVA_VERSION!
    
    REM 检查Java版本是否符合要求（需要17+）
    for /f "tokens=1 delims=." %%a in ("!JAVA_VERSION!") do set "JAVA_MAJOR=%%a"
    for /f "tokens=1 delims=." %%a in ("!JAVA_MAJOR!") do set "JAVA_MAJOR=%%a"
    if "!JAVA_MAJOR!"=="1" (
        for /f "tokens=2 delims=." %%b in ("!JAVA_VERSION!") do set "JAVA_MAJOR=%%b"
    )
    if !JAVA_MAJOR! lss 17 (
        echo [X] Java版本过低，需要JDK 17或更高版本
        set "ERROR_FLAG=1"
    ) else (
        echo [OK] Java版本符合要求（17+）
    )
) else (
    echo [X] 未检测到Java环境
    set "ERROR_FLAG=1"
    set "NEED_JAVA=1"
)

echo.

REM 检测Maven环境
echo [检查] 检测Maven环境...
mvn -version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=3" %%g in ('mvn -version 2^>^&1 ^| findstr /i "Apache Maven"') do (
        set "MAVEN_VERSION=%%g"
        goto :maven_found
    )
    :maven_found
    echo [OK] Maven已安装: !MAVEN_VERSION!
) else (
    echo [X] 未检测到Maven环境
    set "ERROR_FLAG=1"
    set "NEED_MAVEN=1"
)

echo.

REM 检测Node.js环境
echo [检查] 检测Node.js环境...
node --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f %%g in ('node --version') do set "NODE_VERSION=%%g"
    echo [OK] Node.js已安装: !NODE_VERSION!
    
    REM 检查Node.js版本（需要18+）
    for /f "tokens=1 delims=v" %%a in ("!NODE_VERSION!") do set "NODE_VER=%%a"
    for /f "tokens=1 delims=." %%a in ("!NODE_VERSION!") do set "NODE_MAJOR=%%a"
    for /f "tokens=1 delims=v" %%a in ("!NODE_MAJOR!") do set "NODE_MAJOR=%%a"
    if !NODE_MAJOR! lss 18 (
        echo [X] Node.js版本过低，需要18或更高版本
        set "ERROR_FLAG=1"
    ) else (
        echo [OK] Node.js版本符合要求（18+）
    )
) else (
    echo [X] 未检测到Node.js环境
    set "ERROR_FLAG=1"
    set "NEED_NODE=1"
)

echo.

REM 检测npm环境
echo [检查] 检测npm环境...
npm --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f %%g in ('npm --version') do set "NPM_VERSION=%%g"
    echo [OK] npm已安装: !NPM_VERSION!
) else (
    echo [X] 未检测到npm环境
    set "ERROR_FLAG=1"
    set "NEED_NPM=1"
)

echo.
echo ===========================================
echo           环境检测完成
echo ===========================================
echo.

if %ERROR_FLAG% equ 1 (
    echo [警告] 检测到缺失的运行环境，请安装以下组件:
    echo.
    if defined NEED_JAVA (
        echo [必需] Java JDK 17或更高版本
        echo        下载地址: https://www.oracle.com/java/technologies/downloads/#java17
        echo        或使用OpenJDK: https://adoptium.net/
        echo.
    )
    if defined NEED_MAVEN (
        echo [必需] Apache Maven 3.8或更高版本
        echo        下载地址: https://maven.apache.org/download.cgi
        echo        或使用Chocolatey安装: choco install maven
        echo.
    )
    if defined NEED_NODE (
        echo [必需] Node.js 18或更高版本
        echo        下载地址: https://nodejs.org/
        echo        或使用Chocolatey安装: choco install nodejs-lts
        echo.
    )
    echo [提示] 安装完成后，请重新运行此脚本检测环境
    echo.
    pause
    exit /b 1
) else (
    echo [OK] 所有运行环境已就绪！
    echo.
    exit /b 0
)

