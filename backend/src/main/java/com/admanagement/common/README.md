# 管理员认证核心接口说明文档

## 📋 功能概述

本模块实现了管理员认证核心功能，包括登录、登出和Token校验。

## 🔑 核心接口

### 1. 登录接口

**接口地址**: `POST /api/admin/login`

**请求参数**:
```json
{
  "username": "admin",
  "password": "Admin@123456"
}
```

**响应结果**:
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

**处理流程**:
1. 校验账号是否存在
2. 校验账号是否启用
3. 使用BCrypt加密比对密码
4. 查询角色信息
5. 生成JWT Token（包含管理员ID、账号、角色信息，过期时间2小时）
6. 更新登录信息（最后登录时间、重置失败次数）

### 2. 登出接口

**接口地址**: `POST /api/admin/logout`

**请求头**:
```
Authorization: Bearer {token}
```

**响应结果**:
```json
{
  "code": 200,
  "message": "登出成功",
  "data": null,
  "timestamp": 1703846400000
}
```

**处理流程**:
1. 从请求头获取Token
2. 验证Token有效性
3. 获取Token剩余过期时间
4. 将Token加入Redis黑名单（过期时间与Token一致）

## 🛡️ Token校验拦截器

### 拦截规则

- **拦截路径**: 所有请求（`/**`）
- **放行路径**:
  - `/admin/login` - 登录接口
  - 静态资源（`.html`, `.css`, `.js`, 图片等）
  - Swagger文档路径
  - 健康检查路径（`/actuator/**`）
  - 错误页面（`/error`）

### 校验流程

1. 从请求头`Authorization`获取Token（格式：`Bearer {token}`）
2. 检查Token是否为空
3. 检查Token是否在黑名单中（Redis）
4. 校验Token是否有效（是否过期）
5. 解析Token中的管理员信息存入上下文（`AdminContext`）
6. 请求完成后清除上下文信息

### 上下文信息

拦截器会将管理员信息存入`AdminContext`，后续代码可以通过以下方式获取：

```java
// 获取管理员ID
Long adminId = AdminContext.getAdminId();

// 获取管理员账号
String username = AdminContext.getUsername();

// 获取完整管理员信息
AdminContext.AdminInfo adminInfo = AdminContext.getAdminInfo();
```

## 🔧 配置说明

### JWT配置（application.yml）

```yaml
jwt:
  secret: ad-management-system-secret-key-2024-very-long-secret-key-for-security
  expiration: 7200  # 2小时，单位秒
  issuer: AD Management System
```

### Redis配置（application.yml）

```yaml
spring:
  redis:
    host: localhost
    port: 6379
    password:
    database: 0
    timeout: 2000ms
```

## 📝 代码结构

```
com.admanagement
├── controller
│   └── SysAdminController          # 管理员控制器
├── service
│   ├── SysAdminService             # 管理员服务接口
│   └── impl
│       └── SysAdminServiceImpl     # 管理员服务实现
├── repository
│   ├── SysAdminMapper              # 管理员Mapper接口
│   └── SysRoleMapper               # 角色Mapper接口
├── entity
│   ├── SysAdmin                    # 管理员实体
│   ├── SysRole                     # 角色实体
│   ├── dto
│   │   └── LoginDTO                # 登录请求DTO
│   └── vo
│       └── LoginVO                 # 登录响应VO
├── utils
│   ├── JwtUtil                     # JWT工具类
│   └── RedisUtil                   # Redis工具类
├── config
│   ├── RedisConfig                 # Redis配置
│   ├── SecurityConfig              # 安全配置（BCrypt）
│   └── InterceptorConfig           # 拦截器配置
├── interceptor
│   └── TokenInterceptor            # Token校验拦截器
├── common
│   ├── Result                      # 统一响应结果
│   └── AdminContext                # 管理员上下文
└── exception
    └── GlobalExceptionHandler      # 全局异常处理器
```

## 🚀 使用示例

### 登录

```bash
curl -X POST http://localhost:8080/api/admin/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "admin",
    "password": "Admin@123456"
  }'
```

### 访问受保护接口

```bash
curl -X GET http://localhost:8080/api/admin/info \
  -H "Authorization: Bearer {token}"
```

### 登出

```bash
curl -X POST http://localhost:8080/api/admin/logout \
  -H "Authorization: Bearer {token}"
```

## ⚠️ 注意事项

1. **密码加密**: 密码使用BCrypt加密存储，前端传递明文密码，后端进行加密比对
2. **Token安全**: Token存储在客户端（建议使用HttpOnly Cookie），服务端通过Redis黑名单管理失效Token
3. **过期时间**: Token默认过期时间为2小时，可在`application.yml`中配置
4. **上下文清理**: 拦截器在请求完成后会自动清除上下文信息，防止内存泄漏
5. **异常处理**: 所有异常都会被全局异常处理器捕获，返回统一的错误格式

---

**版本**: 1.0.0  
**最后更新**: 2024-12-30

