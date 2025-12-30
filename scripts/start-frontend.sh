#!/bin/bash

# AD Management System - 前端启动脚本 (Linux/Mac)
# Version: 1.0.0

set -e  # 遇到错误立即退出

echo "==========================================="
echo "   AD Management System - 前端启动脚本"
echo "==========================================="

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查Node.js环境
check_nodejs() {
    log_info "检查Node.js环境..."
    if ! command -v node &> /dev/null; then
        log_error "未检测到Node.js环境，请先安装Node.js 18+"
        exit 1
    fi

    node_version=$(node --version | cut -d'v' -f2)
    log_info "Node.js版本: $node_version"

    # 检查Node.js版本是否大于等于18
    node_major_version=$(echo $node_version | cut -d. -f1)
    if [ "$node_major_version" -lt 18 ]; then
        log_error "需要Node.js 18或更高版本，当前版本: $node_version"
        exit 1
    fi
}

# 检查npm环境
check_npm() {
    log_info "检查npm环境..."
    if ! command -v npm &> /dev/null; then
        log_error "未检测到npm环境"
        exit 1
    fi

    npm_version=$(npm --version)
    log_info "npm版本: $npm_version"
}

# 主函数
main() {
    # 获取脚本所在目录的父目录
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

    log_info "当前工作目录: $(pwd)"
    log_info "项目根目录: $PROJECT_DIR"
    log_info "前端项目路径: $PROJECT_DIR/frontend"

    # 检查Node.js和npm
    check_nodejs
    check_npm

    # 检查前端项目是否存在
    if [ ! -d "$PROJECT_DIR/frontend" ]; then
        log_error "前端项目目录不存在: $PROJECT_DIR/frontend"
        exit 1
    fi

    cd "$PROJECT_DIR/frontend"

    # 检查package.json是否存在
    if [ ! -f "package.json" ]; then
        log_error "package.json文件不存在"
        exit 1
    fi

    echo
    log_info "检查并安装依赖..."
    echo

    # 检查node_modules是否存在
    if [ ! -d "node_modules" ]; then
        log_info "安装项目依赖，这可能需要一些时间..."
        if ! npm install; then
            log_error "依赖安装失败"
            exit 1
        fi
    else
        log_info "依赖已存在，跳过安装步骤"
    fi

    echo
    log_info "开始启动前端开发服务器..."
    echo

    # 设置环境变量
    export VITE_APP_TITLE="AD管理系统"
    export VITE_API_BASE_URL="http://localhost:8080"
    export VITE_PORT="3000"

    log_info "环境变量:"
    log_info "  VITE_APP_TITLE: $VITE_APP_TITLE"
    log_info "  VITE_API_BASE_URL: $VITE_API_BASE_URL"
    log_info "  VITE_PORT: $VITE_PORT"

    # 启动Vue开发服务器
    npm run dev &
    VUE_PID=$!

    echo
    log_info "前端开发服务器启动中... (PID: $VUE_PID)"
    log_info "前端服务地址: http://localhost:3000"
    log_info "后端API代理地址: http://localhost:8080/api"
    echo
    log_info "按 Ctrl+C 停止服务"

    # 等待服务启动
    sleep 5

    # 检查服务是否启动成功
    if kill -0 $VUE_PID 2>/dev/null; then
        log_info "前端开发服务器启动成功!"
        echo
        log_info "服务信息:"
        echo "  - PID: $VUE_PID"
        echo "  - URL: http://localhost:3000"
        echo "  - API Proxy: http://localhost:8080/api"
        echo

        # 等待用户中断
        wait $VUE_PID
    else
        log_error "前端开发服务器启动失败"
        exit 1
    fi
}

# 处理中断信号
trap 'echo -e "\n${YELLOW}正在停止前端开发服务器...${NC}"; exit 0' INT TERM

# 执行主函数
main "$@"

