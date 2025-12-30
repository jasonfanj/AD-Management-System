#!/bin/bash

# AD Management System - 数据库初始化脚本 (Linux/Mac)
# Version: 1.0.0

set -e  # 遇到错误立即退出

echo "==========================================="
echo " AD Management System - 数据库初始化脚本"
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

# 检查MySQL环境
check_mysql() {
    log_info "检查MySQL环境..."
    if ! command -v mysql &> /dev/null; then
        log_error "未检测到MySQL客户端，请先安装MySQL或添加mysql到PATH环境变量"
        exit 1
    fi

    mysql_version=$(mysql --version)
    log_info "MySQL版本: $mysql_version"
}

# 主函数
main() {
    # 获取脚本所在目录的父目录
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

    log_info "当前工作目录: $(pwd)"
    log_info "项目根目录: $PROJECT_DIR"
    log_info "数据库脚本路径: $PROJECT_DIR/database/init.sql"

    # 检查MySQL
    check_mysql

    # 检查数据库初始化脚本是否存在
    if [ ! -f "$PROJECT_DIR/database/init.sql" ]; then
        log_error "数据库初始化脚本不存在: $PROJECT_DIR/database/init.sql"
        exit 1
    fi

    echo
    log_warn "此操作将创建/重置数据库 'ad_management_system'"
    log_warn "现有数据将被清除，请确保已备份重要数据"
    echo

    read -p "是否继续? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "操作已取消"
        exit 0
    fi

    echo
    log_info "开始初始化数据库..."
    echo

    # 数据库连接信息
    MYSQL_HOST=${MYSQL_HOST:-localhost}
    MYSQL_PORT=${MYSQL_PORT:-3306}
    MYSQL_USER=${MYSQL_USER:-root}
    MYSQL_PASS=${MYSQL_PASS:-123456}
    DATABASE_NAME=${DATABASE_NAME:-ad_management_system}

    log_info "数据库连接信息:"
    log_info "  主机: $MYSQL_HOST:$MYSQL_PORT"
    log_info "  用户: $MYSQL_USER"
    log_info "  数据库: $DATABASE_NAME"

    # 执行数据库初始化脚本
    mysql -h"$MYSQL_HOST" -P"$MYSQL_PORT" -u"$MYSQL_USER" -p"$MYSQL_PASS" < "$PROJECT_DIR/database/init.sql"

    echo
    log_info "数据库初始化完成!"
    echo
    log_info "默认管理员账户:"
    log_info "  用户名: admin"
    log_info "  密码: admin123"
    echo
    log_warn "请及时修改默认密码"
    echo
}

# 执行主函数
main "$@"

