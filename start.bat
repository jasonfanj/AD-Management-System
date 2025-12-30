@echo off
chcp 65001 >nul
echo ========================================
echo 域控通-Web AD管理系统
echo ========================================
echo.

REM 检查Python是否安装
python --version >nul 2>&1
if errorlevel 1 (
    echo [错误] 未检测到Python，请先安装Python 3.8+
    echo 下载地址: https://www.python.org/downloads/
    pause
    exit /b 1
)

echo [1/3] 检查Python环境...
python --version

REM 检查虚拟环境
if not exist "venv" (
    echo [2/3] 创建虚拟环境...
    python -m venv venv
)

REM 激活虚拟环境
echo [3/3] 激活虚拟环境并安装依赖...
call venv\Scripts\activate.bat

REM 安装依赖
if not exist "venv\Lib\site-packages\flask" (
    echo 正在安装依赖包...
    pip install -r requirements.txt
)

echo.
echo ========================================
echo 启动后端服务...
echo ========================================
echo.
echo 提示: 后端启动后，请直接打开 frontend/index.html 文件使用
echo 默认账户: admin / admin123
echo.
echo 按 Ctrl+C 停止服务
echo ========================================
echo.

python app.py

pause

