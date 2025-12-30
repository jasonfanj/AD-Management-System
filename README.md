# AD Management System (AD管理系统)

[![Java](https://img.shields.io/badge/Java-17+-orange.svg)](https://www.oracle.com/java/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.2.0-brightgreen.svg)](https://spring.io/projects/spring-boot)
[![Vue](https://img.shields.io/badge/Vue-3.3.8-brightgreen.svg)](https://vuejs.org/)
[![Element Plus](https://img.shields.io/badge/Element%20Plus-2.4.4-blue.svg)](https://element-plus.org/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0+-blue.svg)](https://www.mysql.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

AD管理系统 - 替代ADManager Plus、ADSelfService Plus、ADAudit Plus的开源解决方案

## 🚀 项目简介

AD管理系统是一个企业级的Active Directory管理平台，提供全面的AD域管理、自助服务和审计功能。本系统采用现代化的技术栈，具有高扩展性、高安全性和良好的用户体验。

### 核心功能模块

- **AD管理 (AD Manager)**: AD域用户、组、OU的全面管理
- **自助服务 (Self-Service)**: 密码重置、账户解锁等自助功能
- **审计管理 (Audit)**: 详细的操作日志和变更审计
- **权限管理 (RBAC)**: 基于角色的访问控制
- **系统管理**: 用户、角色、权限、配置管理

## 🏗️ 架构设计

### 后端架构 (Spring Boot)

采用经典的分层架构设计，确保代码的可维护性和可扩展性：

```
backend/
├── controller/          # 控制层 - API接口定义
│   ├── system/         # 系统管理接口
│   ├── ad/             # AD管理接口
│   ├── selfservice/    # 自助服务接口
│   └── audit/          # 审计接口
├── service/            # 服务层 - 业务逻辑处理
│   ├── impl/           # 服务实现类
│   └── interfaces/     # 服务接口定义
├── repository/         # 数据访问层 - 数据库操作
├── entity/             # 实体层 - 数据模型
│   ├── dto/            # 数据传输对象
│   ├── vo/             # 视图对象
│   └── po/             # 持久化对象
├── config/             # 配置类
├── utils/              # 工具类
├── exception/          # 异常处理
└── aspect/             # AOP切面 (审计、日志等)
```

### 前端架构 (Vue3 + Element Plus)

采用模块化设计，按功能划分目录结构：

```
frontend/
├── src/
│   ├── components/     # 公共组件
│   │   ├── common/    # 通用组件
│   │   ├── business/  # 业务组件
│   │   └── layout/    # 布局组件
│   ├── views/         # 页面组件
│   │   ├── pages/     # 页面文件
│   │   ├── modules/   # 功能模块
│   │   └── layouts/   # 页面布局
│   ├── router/        # 路由配置
│   │   ├── index.ts   # 主路由
│   │   └── modules/   # 模块路由
│   ├── store/         # 状态管理 (Pinia)
│   │   ├── modules/   # 状态模块
│   │   └── types/     # 类型定义
│   ├── api/           # API接口层
│   │   ├── modules/   # API模块
│   │   └── types/     # API类型
│   ├── utils/         # 工具函数
│   ├── types/         # TypeScript类型
│   ├── styles/        # 样式文件
│   ├── assets/        # 静态资源
│   ├── locales/       # 国际化
│   └── composables/   # Vue组合式API
├── public/            # 公共静态文件
└── types/             # 全局类型定义
```

## 🔧 技术栈

### 后端技术栈
- **框架**: Spring Boot 3.2.0
- **ORM**: MyBatis Plus 3.5.3
- **数据库**: MySQL 8.0+
- **缓存**: Redis
- **安全**: Spring Security + JWT
- **AD集成**: Spring LDAP + UnboundID LDAP SDK
- **文档**: Swagger/OpenAPI 3.0
- **任务调度**: Quartz
- **邮件**: JavaMail

### 前端技术栈
- **框架**: Vue 3.3.8 (Composition API)
- **UI库**: Element Plus 2.4.4
- **状态管理**: Pinia 2.1.7
- **路由**: Vue Router 4.2.5
- **构建工具**: Vite 4.5.0
- **语言**: TypeScript 5.2.2
- **样式**: Sass/SCSS
- **HTTP客户端**: Axios
- **工具库**: Day.js, CryptoJS, Lodash

### 开发工具
- **JDK**: 17+
- **Node.js**: 18+
- **Maven**: 3.8+
- **MySQL**: 8.0+
- **Redis**: 6.0+ (可选)

## 📁 项目结构说明

### 目录结构详解

```
AD Management System/
├── backend/                    # 后端项目
│   ├── src/main/java/com/admanagement/
│   │   ├── controller/         # REST API控制器
│   │   │   ├── system/         # 系统管理API
│   │   │   ├── ad/            # AD管理API
│   │   │   ├── selfservice/   # 自助服务API
│   │   │   └── audit/         # 审计API
│   │   ├── service/           # 业务服务层
│   │   │   ├── impl/          # 服务实现
│   │   │   └── interfaces/    # 服务接口
│   │   ├── repository/        # 数据访问层
│   │   ├── entity/            # 实体类
│   │   │   ├── dto/           # 数据传输对象
│   │   │   ├── vo/            # 视图对象
│   │   │   └── po/            # 持久化对象
│   │   ├── config/            # 配置类
│   │   ├── utils/             # 工具类
│   │   ├── exception/         # 自定义异常
│   │   └── aspect/            # AOP切面
│   ├── src/main/resources/    # 资源文件
│   ├── src/test/              # 测试代码
│   └── pom.xml                # Maven配置
├── frontend/                   # 前端项目
│   ├── src/
│   │   ├── components/        # Vue组件
│   │   ├── views/             # 页面组件
│   │   ├── router/            # 路由配置
│   │   ├── store/             # 状态管理
│   │   ├── api/               # API调用
│   │   ├── utils/             # 工具函数
│   │   ├── types/             # 类型定义
│   │   ├── styles/            # 样式文件
│   │   └── assets/            # 静态资源
│   ├── public/                # 公共文件
│   ├── package.json           # npm配置
│   ├── vite.config.js         # Vite配置
│   └── tsconfig.json          # TypeScript配置
├── database/                   # 数据库脚本
│   └── init.sql               # 初始化脚本
├── scripts/                    # 启动脚本
│   ├── smart-start.bat/sh     # 智能一键启动（推荐）⭐
│   ├── check-env.bat/sh       # 环境检测工具
│   ├── auto-setup-env.bat     # 自动环境配置（Windows）
│   ├── start-all.bat/sh       # 一键启动脚本
│   ├── start-backend.bat/sh   # 后端启动脚本
│   ├── start-frontend.bat/sh  # 前端启动脚本
│   └── init-database.bat/sh   # 数据库初始化
└── docs/                      # 项目文档
```

## 🚀 快速开始

### 环境准备

#### 方式一：自动检测和安装（推荐）⭐

**Windows用户：**
```batch
# 使用智能启动脚本，自动检测并提示安装缺失的环境
scripts\smart-start.bat

# 或使用环境检测工具
scripts\check-env.bat

# 自动安装缺失的环境（需要Chocolatey）
scripts\auto-setup-env.bat
```

**Linux/Mac用户：**
```bash
# 检测环境
chmod +x scripts/check-env.sh
./scripts/check-env.sh
```

#### 方式二：手动安装

1. **安装JDK 17+**
   ```bash
   # Windows: 下载安装 https://adoptium.net/
   # 或使用 Chocolatey: choco install openjdk17
   
   # Linux (Ubuntu/Debian)
   sudo apt install openjdk-17-jdk
   
   # Mac
   brew install openjdk@17
   
   # 检查Java版本
   java -version
   ```

2. **安装Node.js 18+**
   ```bash
   # Windows: 下载安装 https://nodejs.org/
   # 或使用 Chocolatey: choco install nodejs-lts
   
   # Linux (Ubuntu/Debian)
   curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
   sudo apt install -y nodejs
   
   # Mac
   brew install node
   
   # 检查Node.js版本
   node --version
   npm --version
   ```

3. **安装Maven 3.8+**
   ```bash
   # Windows: 下载安装 https://maven.apache.org/download.cgi
   # 或使用 Chocolatey: choco install maven
   
   # Linux (Ubuntu/Debian)
   sudo apt install maven
   
   # Mac
   brew install maven
   
   # 检查Maven版本
   mvn -version
   ```

4. **安装MySQL 8.0+**
   ```bash
   # Windows: 下载安装 https://dev.mysql.com/downloads/mysql/
   # 或使用 Chocolatey: choco install mysql
   
   # Linux (Ubuntu/Debian)
   sudo apt install mysql-server
   sudo systemctl start mysql
   
   # Mac
   brew install mysql
   brew services start mysql
   ```

5. **安装Redis（可选，用于缓存）**
   ```bash
   # Windows: 下载安装 https://github.com/microsoftarchive/redis/releases
   # 或使用 Chocolatey: choco install redis-64
   
   # Linux (Ubuntu/Debian)
   sudo apt install redis-server
   sudo systemctl start redis
   
   # Mac
   brew install redis
   brew services start redis
   ```

### 数据库初始化

**Windows:**
```batch
# 在项目根目录执行
scripts\init-database.bat
```

**Linux/Mac:**
```bash
# 在项目根目录执行
chmod +x scripts/init-database.sh
./scripts/init-database.sh
```

### 启动应用

#### 方式一：智能一键启动 ⭐ (推荐)

自动检测运行环境，自动安装缺失组件，自动安装依赖，一键启动所有服务。

**Windows:**
```batch
# 智能一键启动（推荐，自动检测并配置环境）
scripts\smart-start.bat
```

**功能特性:**
- ✅ 自动检测 Java、Maven、Node.js 环境
- ✅ 自动提示缺失的环境组件
- ✅ 支持使用 Chocolatey 自动安装缺失组件
- ✅ 自动安装前端 npm 依赖
- ✅ 自动启动后端和前端服务

**Linux/Mac:**
```bash
# 智能一键启动（需要手动安装依赖）
chmod +x scripts/check-env.sh
chmod +x scripts/smart-start.sh
./scripts/smart-start.sh
```

#### 方式二：环境检测工具

在启动前，可以先检测运行环境是否已配置完成：

**Windows:**
```batch
# 检测运行环境
scripts\check-env.bat

# 自动配置运行环境（使用Chocolatey）
scripts\auto-setup-env.bat
```

**Linux/Mac:**
```bash
chmod +x scripts/check-env.sh
./scripts/check-env.sh
```

#### 方式三：传统一键启动

**Windows:**
```batch
# 一键启动（需要手动确保环境已配置）
scripts\start-all.bat
```

**Linux/Mac:**
```bash
chmod +x scripts/start-all.sh
./scripts/start-all.sh
```

#### 方式四：分别启动 (推荐用于开发调试)

**Windows:**
```batch
# 启动后端 (新终端)
scripts\start-backend.bat

# 启动前端 (新终端)
scripts\start-frontend.bat
```

**Linux/Mac:**
```bash
# 启动后端 (新终端)
chmod +x scripts/start-backend.sh
./scripts/start-backend.sh

# 启动前端 (新终端)
chmod +x scripts/start-frontend.sh
./scripts/start-frontend.sh
```

### 访问应用

- **前端界面**: http://localhost:3000
- **后端API**: http://localhost:8080/api
- **API文档**: http://localhost:8080/api/swagger-ui.html
- **系统监控**: http://localhost:8080/api/actuator/health

### 默认账户

- **管理员账户**: admin / admin123
- **普通用户**: user / user123

## 🔒 安全特性

### 认证与授权
- JWT Token认证
- 基于角色的访问控制 (RBAC)
- 多因子认证支持 (可扩展)
- 会话管理与超时控制

### 数据安全
- 密码加密存储 (BCrypt)
- SQL注入防护
- XSS防护
- CSRF防护
- 敏感数据脱敏

### 审计功能
- 操作日志记录
- AD变更审计
- 登录日志追踪
- 敏感操作审批

## 📊 扩展性设计

### 模块化架构
- **插件化设计**: 支持功能模块的热插拔
- **微服务就绪**: 可轻松拆分为微服务架构
- **多租户支持**: 可扩展为SaaS模式

### AD集成扩展
- 支持多域控制器
- 支持多种LDAP服务器
- 支持自定义AD属性映射
- 支持AD Schema扩展

### 第三方集成
- 邮件服务集成 (已支持)
- 短信服务集成 (可扩展)
- 企业微信/钉钉集成 (可扩展)
- SIEM系统集成 (可扩展)

### 性能优化
- 缓存策略 (Redis)
- 数据库读写分离 (可扩展)
- 负载均衡 (可扩展)
- CDN加速 (可扩展)

## 🔄 开发指南

### 后端开发

1. **添加新模块**
   ```java
   // 1. 创建实体类
   // src/main/java/com/admanagement/entity/pojo/NewEntity.java

   // 2. 创建DTO
   // src/main/java/com/admanagement/entity/dto/NewEntityDTO.java

   // 3. 创建Repository
   // src/main/java/com/admanagement/repository/NewEntityRepository.java

   // 4. 创建Service
   // src/main/java/com/admanagement/service/interfaces/INewEntityService.java
   // src/main/java/com/admanagement/service/impl/NewEntityServiceImpl.java

   // 5. 创建Controller
   // src/main/java/com/admanagement/controller/newmodule/NewEntityController.java
   ```

2. **数据库迁移**
   ```sql
   -- 在database/migrations/下添加新迁移脚本
   -- 遵循命名规范: V{版本号}__{描述}.sql
   ```

### 前端开发

1. **添加新页面**
   ```typescript
   // 1. 创建页面组件
   // src/views/pages/NewPage.vue

   // 2. 添加路由
   // src/router/modules/newModule.ts

   // 3. 添加API接口
   // src/api/modules/newModule.ts

   // 4. 添加状态管理 (如需要)
   // src/store/modules/newModule.ts
   ```

2. **组件开发**
   ```vue
   <!-- 遵循组件命名规范 -->
   <template>
     <div class="new-component">
       <!-- 组件内容 -->
     </div>
   </template>

   <script setup lang="ts">
   // 组合式API
   </script>

   <style scoped lang="scss">
   // 组件样式
   </style>
   ```

## 📈 部署指南

### 开发环境

#### Windows 快速部署

1. **数据库初始化**
   ```batch
   # 初始化数据库（首次运行）
   scripts\init-database.bat
   ```

2. **智能一键启动**（推荐）
   ```batch
   # 自动检测环境、安装依赖、启动服务
   scripts\smart-start.bat
   ```

3. **手动启动**（如需分别启动）
   ```batch
   # 方式1: 一键启动
   scripts\start-all.bat

   # 方式2: 分别启动
   scripts\start-backend.bat
   scripts\start-frontend.bat
   ```

#### Linux/Mac 快速部署

1. **数据库初始化**
   ```bash
   # 初始化数据库（首次运行）
   chmod +x scripts/init-database.sh
   ./scripts/init-database.sh
   ```

2. **环境检测**
   ```bash
   # 检测运行环境
   chmod +x scripts/check-env.sh
   ./scripts/check-env.sh
   ```

3. **启动服务**
   ```bash
   # 方式1: 一键启动
   chmod +x scripts/start-all.sh
   ./scripts/start-all.sh

   # 方式2: 分别启动
   chmod +x scripts/start-backend.sh
   chmod +x scripts/start-frontend.sh
   ./scripts/start-backend.sh
   ./scripts/start-frontend.sh
   ```

#### 环境要求检查清单

启动前请确保以下环境已正确安装：

- ✅ **Java JDK 17+**
  - Windows: [下载地址](https://adoptium.net/) 或使用 `choco install openjdk17`
  - Linux: `sudo apt install openjdk-17-jdk` (Ubuntu/Debian)
  - Mac: `brew install openjdk@17`

- ✅ **Maven 3.8+**
  - Windows: [下载地址](https://maven.apache.org/download.cgi) 或使用 `choco install maven`
  - Linux: `sudo apt install maven` (Ubuntu/Debian)
  - Mac: `brew install maven`

- ✅ **Node.js 18+** 和 **npm**
  - Windows: [下载地址](https://nodejs.org/) 或使用 `choco install nodejs-lts`
  - Linux: `curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - && sudo apt install -y nodejs`
  - Mac: `brew install node`

- ✅ **MySQL 8.0+**（数据库服务需要单独启动）
- ⚠️ **Redis**（可选，如使用缓存功能）

#### 启动脚本说明

项目提供了多个启动脚本，方便不同场景使用：

| 脚本名称 | 功能说明 | 使用场景 |
|---------|---------|---------|
| `smart-start.bat/sh` | 智能一键启动 | ⭐ 推荐，首次使用 |
| `check-env.bat/sh` | 环境检测工具 | 检查运行环境 |
| `auto-setup-env.bat` | 自动环境配置 | Windows自动安装环境（需Chocolatey） |
| `start-all.bat/sh` | 一键启动 | 环境已配置时使用 |
| `start-backend.bat/sh` | 启动后端 | 单独启动后端服务 |
| `start-frontend.bat/sh` | 启动前端 | 单独启动前端服务 |
| `init-database.bat/sh` | 数据库初始化 | 首次部署时初始化数据库 |

### 生产环境部署

#### 1. 后端部署

**方式一：JAR包部署**（推荐）

```bash
# 1. 进入后端目录
cd backend

# 2. 构建生产JAR包
mvn clean package -DskipTests -Pprod

# 3. 运行JAR包
java -jar target/ad-management-system-1.0.0.jar --spring.profiles.active=prod

# 或使用后台运行
nohup java -jar target/ad-management-system-1.0.0.jar --spring.profiles.active=prod > logs/app.log 2>&1 &
```

**方式二：Docker部署**

```dockerfile
# backend/Dockerfile
FROM openjdk:17-jdk-alpine

WORKDIR /app

# 复制JAR包
COPY target/ad-management-system-1.0.0.jar app.jar

# 暴露端口
EXPOSE 8080

# 启动应用
ENTRYPOINT ["java", "-jar", "app.jar", "--spring.profiles.active=prod"]
```

```bash
# 构建镜像
docker build -t ad-management-backend:latest ./backend

# 运行容器
docker run -d \
  --name ad-management-backend \
  -p 8080:8080 \
  -e SPRING_PROFILES_ACTIVE=prod \
  -e SPRING_DATASOURCE_URL=jdbc:mysql://mysql-host:3306/admanagement \
  -e SPRING_DATASOURCE_USERNAME=root \
  -e SPRING_DATASOURCE_PASSWORD=yourpassword \
  ad-management-backend:latest
```

**方式三：使用systemd服务（Linux）**

创建服务文件 `/etc/systemd/system/ad-management.service`:

```ini
[Unit]
Description=AD Management System Backend
After=network.target mysql.service

[Service]
Type=simple
User=admanagement
WorkingDirectory=/opt/ad-management/backend
ExecStart=/usr/bin/java -jar /opt/ad-management/backend/target/ad-management-system-1.0.0.jar --spring.profiles.active=prod
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

```bash
# 启用并启动服务
sudo systemctl enable ad-management
sudo systemctl start ad-management
sudo systemctl status ad-management
```

#### 2. 前端部署

**方式一：静态文件部署**

```bash
# 1. 进入前端目录
cd frontend

# 2. 安装依赖（首次）
npm install

# 3. 构建生产版本
npm run build:prod

# 4. 部署dist目录到Web服务器
# 将 dist 目录内容复制到 Web 服务器根目录
```

**Nginx配置示例:**

```nginx
server {
    listen 80;
    server_name your-domain.com;
    root /var/www/ad-management/dist;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location /api {
        proxy_pass http://localhost:8080/api;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

**Apache配置示例:**

```apache
<VirtualHost *:80>
    ServerName your-domain.com
    DocumentRoot /var/www/ad-management/dist

    <Directory /var/www/ad-management/dist>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
        RewriteEngine On
        RewriteBase /
        RewriteRule ^index\.html$ - [L]
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteCond %{REQUEST_FILENAME} !-d
        RewriteRule . /index.html [L]
    </Directory>

    ProxyPreserveHost On
    ProxyPass /api http://localhost:8080/api
    ProxyPassReverse /api http://localhost:8080/api
</VirtualHost>
```

**方式二：Docker部署**

```dockerfile
# frontend/Dockerfile
FROM node:18-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build:prod

FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

#### 3. 数据库配置

生产环境数据库配置建议：

1. **使用独立的MySQL服务器**
2. **配置连接池参数**
3. **启用SSL连接**（如需要）
4. **定期备份数据库**

```yaml
# application-prod.yml
spring:
  datasource:
    url: jdbc:mysql://mysql-server:3306/admanagement?useSSL=true&serverTimezone=Asia/Shanghai
    username: ${DB_USERNAME}
    password: ${DB_PASSWORD}
    hikari:
      maximum-pool-size: 20
      minimum-idle: 5
      connection-timeout: 30000
```

#### 4. 完整部署流程

**生产环境部署步骤：**

```bash
# 1. 克隆项目
git clone <repository-url>
cd AD-Management-System

# 2. 配置生产环境配置文件
cp backend/src/main/resources/application.yml backend/src/main/resources/application-prod.yml
# 编辑 application-prod.yml，配置数据库、Redis等

# 3. 初始化数据库
mysql -u root -p < database/init.sql

# 4. 构建后端
cd backend
mvn clean package -DskipTests -Pprod
cd ..

# 5. 构建前端
cd frontend
npm install
npm run build:prod
cd ..

# 6. 部署后端（选择一种方式）
# 方式1: 直接运行JAR
java -jar backend/target/ad-management-system-1.0.0.jar --spring.profiles.active=prod

# 方式2: 使用Docker
docker-compose up -d

# 方式3: 使用systemd（Linux）
sudo systemctl start ad-management

# 7. 部署前端（选择一种方式）
# 方式1: 使用Nginx/Apache
# 将 frontend/dist 目录内容复制到Web服务器

# 方式2: 使用Docker
docker build -t ad-management-frontend ./frontend
docker run -d -p 80:80 ad-management-frontend
```

#### 5. Docker Compose 一键部署（推荐）

创建 `docker-compose.yml`:

```yaml
version: '3.8'

services:
  mysql:
    image: mysql:8.0
    container_name: ad-management-mysql
    environment:
      MYSQL_ROOT_PASSWORD: yourpassword
      MYSQL_DATABASE: admanagement
    ports:
      - "3306:3306"
    volumes:
      - mysql-data:/var/lib/mysql
      - ./database/init.sql:/docker-entrypoint-initdb.d/init.sql
    networks:
      - ad-management-network

  redis:
    image: redis:7-alpine
    container_name: ad-management-redis
    ports:
      - "6379:6379"
    networks:
      - ad-management-network

  backend:
    build: ./backend
    container_name: ad-management-backend
    depends_on:
      - mysql
      - redis
    environment:
      SPRING_PROFILES_ACTIVE: prod
      SPRING_DATASOURCE_URL: jdbc:mysql://mysql:3306/admanagement
      SPRING_DATASOURCE_USERNAME: root
      SPRING_DATASOURCE_PASSWORD: yourpassword
      SPRING_REDIS_HOST: redis
    ports:
      - "8080:8080"
    networks:
      - ad-management-network

  frontend:
    build: ./frontend
    container_name: ad-management-frontend
    depends_on:
      - backend
    ports:
      - "80:80"
    networks:
      - ad-management-network

volumes:
  mysql-data:

networks:
  ad-management-network:
    driver: bridge
```

```bash
# 一键启动所有服务
docker-compose up -d

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f

# 停止服务
docker-compose down
```

#### 6. 部署检查清单

- [ ] 数据库已初始化并配置完成
- [ ] 后端配置文件已更新（`application-prod.yml`）
- [ ] 前端API地址已配置为生产环境地址
- [ ] 防火墙端口已开放（80, 8080, 3306等）
- [ ] SSL证书已配置（如使用HTTPS）
- [ ] 日志目录权限已配置
- [ ] 定期备份计划已设置
- [ ] 监控和告警已配置
- [ ] 安全策略已审查（密码策略、权限控制等）

## 🤝 贡献指南

1. Fork项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建Pull Request

## 📝 许可证

本项目采用MIT许可证 - 查看 [LICENSE](LICENSE) 文件了解详情

## 📞 支持与联系

- **项目主页**: [GitHub Repository]
- **问题反馈**: [Issues]
- **文档**: [Wiki]
- **邮箱**: support@admanagement.com

## 🙏 致谢

感谢所有为这个项目做出贡献的开发者！

---

**AD Management System** - 让AD管理变得简单而强大！ 🚀

