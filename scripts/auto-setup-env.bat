@echo off
REM AD Management System - Auto Setup Environment Script (Windows)
REM Version: 2.0.0
REM This script attempts to automatically install missing environments using package manager

setlocal enabledelayedexpansion
chcp 936 > nul 2>&1

echo ===========================================
echo    AD Management System - 自动环境配置
echo ===========================================
echo.

set "PROJECT_DIR=%~dp0.."
cd /d "%PROJECT_DIR%"

REM 检测Chocolatey是否安装
echo [检查] 检测Chocolatey包管理器...
choco --version >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Chocolatey已安装
    set "HAS_CHOCO=1"
) else (
    echo [X] Chocolatey未安装
    echo [提示] 正在尝试安装Chocolatey...
    echo [注意] 此操作需要管理员权限
    echo.
    
    REM 询问是否安装Chocolatey
    set /p INSTALL_CHOCO="是否安装Chocolatey? (Y/N): "
    if /i "!INSTALL_CHOCO!"=="Y" (
        echo [安装] 正在安装Chocolatey...
        powershell -NoProfile -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
        if %errorlevel% equ 0 (
            echo [OK] Chocolatey安装成功
            set "HAS_CHOCO=1"
            REM 刷新环境变量
            call refreshenv
        ) else (
            echo [X] Chocolatey安装失败，请手动安装
            set "HAS_CHOCO=0"
        )
    ) else (
        set "HAS_CHOCO=0"
    )
)

echo.

if not defined HAS_CHOCO (
    set "HAS_CHOCO=0"
)

REM 检测并安装Java
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo [安装] Java未安装，正在尝试安装...
    if %HAS_CHOCO% equ 1 (
        echo [安装] 使用Chocolatey安装OpenJDK 17...
        choco install openjdk17 -y
        if %errorlevel% equ 0 (
            echo [OK] Java安装成功
            call refreshenv
        ) else (
            echo [X] Java自动安装失败，请手动安装
            echo     下载地址: https://adoptium.net/
        )
    ) else (
        echo [提示] 请手动安装Java JDK 17+
        echo     下载地址: https://adoptium.net/
    )
) else (
    echo [OK] Java已安装
)

echo.

REM 检测并安装Maven
mvn -version >nul 2>&1
if %errorlevel% neq 0 (
    echo [安装] Maven未安装，正在尝试安装...
    if %HAS_CHOCO% equ 1 (
        echo [安装] 使用Chocolatey安装Maven...
        choco install maven -y
        if %errorlevel% equ 0 (
            echo [OK] Maven安装成功
            call refreshenv
        ) else (
            echo [X] Maven自动安装失败，请手动安装
            echo     下载地址: https://maven.apache.org/download.cgi
        )
    ) else (
        echo [提示] 请手动安装Maven
        echo     下载地址: https://maven.apache.org/download.cgi
    )
) else (
    echo [OK] Maven已安装
)

echo.

REM 检测并安装Node.js
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [安装] Node.js未安装，正在尝试安装...
    if %HAS_CHOCO% equ 1 (
        echo [安装] 使用Chocolatey安装Node.js LTS...
        choco install nodejs-lts -y
        if %errorlevel% equ 0 (
            echo [OK] Node.js安装成功
            call refreshenv
        ) else (
            echo [X] Node.js自动安装失败，请手动安装
            echo     下载地址: https://nodejs.org/
        )
    ) else (
        echo [提示] 请手动安装Node.js 18+
        echo     下载地址: https://nodejs.org/
    )
) else (
    echo [OK] Node.js已安装
)

echo.
echo ===========================================
echo           环境配置完成
echo ===========================================
echo.
echo [提示] 如果使用了自动安装，可能需要重新打开命令行窗口以使环境变量生效
echo [提示] 或者运行 'refreshenv' 命令刷新环境变量
echo.
pause

