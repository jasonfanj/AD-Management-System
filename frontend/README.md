# 前端登录页面及路由权限拦截说明文档

## 📋 功能概述

本模块实现了基于Vue3 + Element Plus的系统登录页面和路由权限拦截功能。

## 🏗️ 代码结构

```
src/
├── api/                      # API接口
│   └── admin.js             # 管理员相关接口
├── components/               # 组件
│   └── layout/              # 布局组件
│       └── Layout.vue       # 主布局（占位）
├── router/                   # 路由配置
│   └── index.js             # 路由配置和路由守卫
├── store/                    # Pinia状态管理
│   ├── adminStore.js        # 管理员状态管理
│   └── index.js             # Store入口
├── utils/                    # 工具类
│   └── request.js           # Axios请求封装
├── views/                    # 页面组件
│   └── pages/               # 页面
│       ├── Login.vue        # 登录页面
│       ├── NotFound.vue     # 404页面
│       ├── Dashboard.vue    # 工作台（占位）
│       └── modules/         # 功能模块页面
│           ├── ADManager.vue    # AD管理（占位）
│           ├── SelfService.vue  # 自助服务（占位）
│           └── Audit.vue        # 审计管理（占位）
├── App.vue                   # 根组件
└── main.js                   # 入口文件
```

## 🔑 核心功能

### 1. 登录页面（Login.vue）

#### 功能特性
- ✅ 居中表单布局，美观简洁
- ✅ 账号和密码输入框（带图标）
- ✅ 记住密码复选框
- ✅ 表单校验（账号非空、密码非空）
- ✅ 调用后端登录接口
- ✅ 登录成功后存储token、管理员信息、角色信息到localStorage和Pinia
- ✅ 适配PC端（1920*1080分辨率）

#### 样式特点
- 渐变背景（紫色系）
- 毛玻璃效果（backdrop-filter）
- 输入框悬停和聚焦动画
- 按钮渐变背景和悬停效果
- 响应式设计（适配移动端）

### 2. 路由配置（router/index.js）

#### 静态路由
- `/login` - 登录页
- `/404` - 404错误页
- `/` - 首页（工作台）

#### 动态路由（三大核心模块）
- **AD管理模块** (`/ad-manager`)
  - AD用户管理
  - AD组管理
  - OU管理
  
- **自助服务模块** (`/self-service`)
  - 密码重置
  - 账户解锁
  
- **审计管理模块** (`/audit`)
  - 操作日志
  - AD变更日志
  - 登录日志

#### 路由守卫逻辑
1. **beforeEach拦截**：拦截所有路由跳转
2. **Token检查**：
   - 无token → 跳转登录页（保留redirect参数）
   - 有token → 继续下一步
3. **用户权限检查**：
   - 未获取用户权限 → 根据角色加载动态路由 → 标记已获取
   - 已获取用户权限 → 检查路由权限 → 有权限继续，无权限跳转404
4. **权限过滤**：根据用户角色过滤可访问的动态路由

### 3. Pinia状态管理（store/adminStore.js）

#### 存储内容
- `token` - JWT Token
- `adminInfo` - 管理员基本信息
- `roles` - 角色列表
- `permissions` - 权限列表（预留）
- `hasGetUserInfo` - 是否已获取用户权限标识

#### 提供的方法
- `login(loginData)` - 登录
- `logout()` - 登出
- `setAdminInfo(info)` - 更新管理员信息
- `setToken(token)` - 更新Token
- `setRoles(roles)` - 更新角色列表
- `setPermissions(permissions)` - 更新权限列表
- `clearAll()` - 清空所有信息
- `hasRole(roleCode)` - 检查是否有指定角色
- `hasPermission(permission)` - 检查是否有指定权限

#### 计算属性
- `isLoggedIn` - 是否已登录
- `adminId` - 管理员ID
- `username` - 管理员账号
- `roleCodes` - 角色编码列表

## 🔌 与后端接口对接

### 1. 登录接口

**请求**：
```javascript
POST /api/admin/login
Content-Type: application/json

{
  "username": "admin",
  "password": "Admin@123456"
}
```

**响应**：
```json
{
  "code": 200,
  "message": "登录成功",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiJ9...",
    "adminInfo": {
      "id": 1,
      "username": "admin",
      "realName": "超级管理员",
      "phone": "13800138000",
      "email": "admin@admanagement.com",
      "avatar": null
    },
    "roles": [
      {
        "id": 1,
        "roleCode": "super_admin",
        "roleName": "超级管理员"
      }
    ]
  },
  "timestamp": 1703846400000
}
```

### 2. 登出接口

**请求**：
```javascript
POST /api/admin/logout
Authorization: Bearer {token}
```

**响应**：
```json
{
  "code": 200,
  "message": "登出成功",
  "data": null,
  "timestamp": 1703846400000
}
```

### 3. 请求拦截器

在 `utils/request.js` 中配置了请求拦截器，自动在请求头中添加Token：

```javascript
config.headers['Authorization'] = `Bearer ${token}`
```

### 4. 响应拦截器

响应拦截器会自动处理：
- 401未授权 → 清除token并跳转登录页
- 403无权限 → 显示错误提示
- 其他错误 → 显示错误信息

## 📝 使用说明

### 1. 环境变量配置

创建 `.env.development` 文件（开发环境）：
```env
VITE_API_BASE_URL=http://localhost:8080/api
VITE_APP_TITLE=AD管理系统
```

创建 `.env.production` 文件（生产环境）：
```env
VITE_API_BASE_URL=/api
VITE_APP_TITLE=AD管理系统
```

### 2. 安装依赖

```bash
npm install
```

### 3. 启动开发服务器

```bash
npm run dev
```

### 4. 构建生产版本

```bash
npm run build
```

## 🔐 权限控制说明

### 角色定义

根据后端数据库设计，系统包含以下角色：
- `super_admin` - 超级管理员（所有权限）
- `ad_admin` - AD管理模块管理员
- `audit_viewer` - 审计模块查看员

### 路由权限配置

在路由的 `meta.roles` 中配置所需角色：

```javascript
{
  path: '/ad-manager',
  meta: {
    roles: ['super_admin', 'ad_admin'] // 需要这些角色才能访问
  }
}
```

### 权限检查流程

1. 用户登录后，获取角色列表
2. 路由守卫根据用户角色过滤动态路由
3. 只有用户拥有的角色包含在路由要求的角色中，才能访问该路由
4. 无权限访问时，跳转到404页面

## ⚠️ 注意事项

1. **Token存储**：Token存储在localStorage中，需要注意XSS攻击防护
2. **记住密码**：当前实现仅记住用户名，不建议存储明文密码
3. **路由权限**：动态路由在首次登录时加载，后续刷新页面不会重新加载
4. **API基础URL**：根据环境变量配置，开发环境指向 `http://localhost:8080/api`
5. **响应格式**：后端接口需返回统一的响应格式（`Result<T>`）

## 🚀 后续扩展

1. **Layout布局**：实现完整的侧边栏、顶部导航、面包屑等布局组件
2. **权限按钮**：实现基于权限的按钮显示/隐藏
3. **Token刷新**：实现Token自动刷新机制
4. **多标签页**：实现多标签页功能
5. **主题切换**：实现明暗主题切换

---

**版本**: 1.0.0  
**最后更新**: 2024-12-30

