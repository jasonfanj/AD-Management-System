#!/bin/bash

echo "========================================"
echo "域控通-Web AD管理系统"
echo "========================================"
echo ""

# 检查Python是否安装
if ! command -v python3 &> /dev/null; then
    echo "[错误] 未检测到Python3，请先安装Python 3.8+"
    exit 1
fi

echo "[1/3] 检查Python环境..."
python3 --version

# 检查虚拟环境
if [ ! -d "venv" ]; then
    echo "[2/3] 创建虚拟环境..."
    python3 -m venv venv
fi

# 激活虚拟环境
echo "[3/3] 激活虚拟环境并安装依赖..."
source venv/bin/activate

# 安装依赖
if [ ! -d "venv/lib/python3*/site-packages/flask" ]; then
    echo "正在安装依赖包..."
    pip install -r requirements.txt
fi

echo ""
echo "========================================"
echo "启动后端服务..."
echo "========================================"
echo ""
echo "提示: 后端启动后，请直接打开 frontend/index.html 文件使用"
echo "默认账户: admin / admin123"
echo ""
echo "按 Ctrl+C 停止服务"
echo "========================================"
echo ""

python app.py

