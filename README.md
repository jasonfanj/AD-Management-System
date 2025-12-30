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
│   ├── start-backend.bat/sh   # 后端启动脚本
│   ├── start-frontend.bat/sh  # 前端启动脚本
│   ├── start-all.bat          # 一键启动脚本
│   └── init-database.bat/sh   # 数据库初始化
└── docs/                      # 项目文档
```

## 🚀 快速开始

### 环境准备

1. **安装JDK 17+**
   ```bash
   # 检查Java版本
   java -version
   ```

2. **安装Node.js 18+**
   ```bash
   # 检查Node.js版本
   node --version
   npm --version
   ```

3. **安装MySQL 8.0+**
   ```bash
   # 启动MySQL服务
   sudo systemctl start mysql  # Linux
   # 或在Windows中启动MySQL服务
   ```

4. **安装Maven 3.8+** (可选，通常包含在IDE中)

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

#### 方式一：分别启动 (推荐用于开发)

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

#### 方式二：一键启动

**Windows:**
```batch
scripts\start-all.bat
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
```bash
# 1. 启动数据库
# 2. 执行数据库初始化
./scripts/init-database.sh

# 3. 启动后端
./scripts/start-backend.sh

# 4. 启动前端
./scripts/start-frontend.sh
```

### 生产环境

1. **后端部署**
   ```bash
   # 1. 构建JAR包
   cd backend
   mvn clean package -DskipTests

   # 2. 运行JAR包
   java -jar target/ad-management-system-1.0.0.jar --spring.profiles.active=prod
   ```

2. **前端部署**
   ```bash
   # 1. 构建生产版本
   cd frontend
   npm run build:prod

   # 2. 部署dist目录到Web服务器
   # Apache/Nginx配置示例
   ```

3. **Docker部署** (可选)
   ```dockerfile
   # Dockerfile示例
   FROM openjdk:17-jdk-alpine
   COPY target/*.jar app.jar
   ENTRYPOINT ["java","-jar","/app.jar"]
   ```

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

