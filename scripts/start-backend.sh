#!/bin/bash

# AD Management System - 后端启动脚本 (Linux/Mac)
# Version: 1.0.0

set -e  # 遇到错误立即退出

echo "==========================================="
echo "   AD Management System - 后端启动脚本"
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

# 检查Java环境
check_java() {
    log_info "检查Java环境..."
    if ! command -v java &> /dev/null; then
        log_error "未检测到Java环境，请先安装JDK 17+"
        exit 1
    fi

    java_version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
    log_info "Java版本: $java_version"

    # 检查Java版本是否大于等于17
    java_major_version=$(echo $java_version | cut -d. -f1)
    if [ "$java_major_version" -lt 17 ]; then
        log_error "需要Java 17或更高版本，当前版本: $java_version"
        exit 1
    fi
}

# 检查Maven环境
check_maven() {
    log_info "检查Maven环境..."
    if ! command -v mvn &> /dev/null; then
        log_error "未检测到Maven环境，请先安装Maven"
        exit 1
    fi

    mvn_version=$(mvn -version 2>&1 | head -n 1 | cut -d' ' -f3)
    log_info "Maven版本: $mvn_version"
}

# 主函数
main() {
    # 获取脚本所在目录的父目录
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

    log_info "当前工作目录: $(pwd)"
    log_info "项目根目录: $PROJECT_DIR"
    log_info "后端项目路径: $PROJECT_DIR/backend"

    # 检查Java和Maven
    check_java
    check_maven

    # 检查后端项目是否存在
    if [ ! -d "$PROJECT_DIR/backend" ]; then
        log_error "后端项目目录不存在: $PROJECT_DIR/backend"
        exit 1
    fi

    cd "$PROJECT_DIR/backend"

    # 检查pom.xml是否存在
    if [ ! -f "pom.xml" ]; then
        log_error "pom.xml文件不存在"
        exit 1
    fi

    echo
    log_info "开始编译后端项目..."
    echo

    # 清理并编译项目
    if ! mvn clean compile -DskipTests; then
        log_error "后端项目编译失败"
        exit 1
    fi

    echo
    log_info "开始启动后端服务..."
    echo

    # 设置JVM参数
    export JAVA_OPTS="-Xmx1024m -Xms512m -XX:+UseG1GC -XX:MaxGCPauseMillis=200"

    # 启动Spring Boot应用
    log_info "JVM参数: $JAVA_OPTS"
    log_info "Spring Profile: dev"

    mvn spring-boot:run -Dspring-boot.run.profiles=dev -Dspring-boot.run.jvmArguments="$JAVA_OPTS" &
    SPRING_PID=$!

    echo
    log_info "后端服务启动中... (PID: $SPRING_PID)"
    log_info "服务启动需要一些时间，请稍等..."
    log_info "后端服务地址: http://localhost:8080/api"
    log_info "API文档地址: http://localhost:8080/api/swagger-ui.html"
    echo
    log_info "按 Ctrl+C 停止服务"

    # 等待服务启动
    sleep 10

    # 检查服务是否启动成功
    if kill -0 $SPRING_PID 2>/dev/null; then
        log_info "后端服务启动成功!"
        echo
        log_info "服务信息:"
        echo "  - PID: $SPRING_PID"
        echo "  - URL: http://localhost:8080/api"
        echo "  - Swagger: http://localhost:8080/api/swagger-ui.html"
        echo "  - Health: http://localhost:8080/api/actuator/health"
        echo

        # 等待用户中断
        wait $SPRING_PID
    else
        log_error "后端服务启动失败"
        exit 1
    fi
}

# 处理中断信号
trap 'echo -e "\n${YELLOW}正在停止后端服务...${NC}"; exit 0' INT TERM

# 执行主函数
main "$@"

