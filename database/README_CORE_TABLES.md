# 核心基础表设计说明文档

## 📋 概述

本文档详细说明了AD管理系统核心基础表（用户与权限模块）的设计，包括表结构、字段说明、关联关系和索引设计。

## 📊 表结构说明

### 1. 管理员用户表 (sys_admin)

**表说明**: 存储系统管理员账号信息

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|------|------|
| id | bigint | PK, AUTO_INCREMENT | 主键ID |
| username | varchar(50) | UNIQUE, NOT NULL | 管理员账号（唯一） |
| password | varchar(255) | NOT NULL | 密码（BCrypt加密存储） |
| real_name | varchar(50) | NULL | 真实姓名 |
| phone | varchar(20) | UNIQUE, NULL | 手机号 |
| email | varchar(100) | UNIQUE, NULL | 邮箱 |
| avatar | varchar(255) | NULL | 头像URL |
| status | tinyint | NOT NULL, DEFAULT 1 | 状态：0-禁用，1-启用 |
| last_login_time | datetime | NULL | 最后登录时间 |
| last_login_ip | varchar(50) | NULL | 最后登录IP |
| login_fail_count | int | DEFAULT 0 | 登录失败次数 |
| lock_time | datetime | NULL | 账户锁定时间 |
| create_time | datetime | NOT NULL, DEFAULT NOW() | 创建时间 |
| update_time | datetime | NOT NULL, DEFAULT NOW() ON UPDATE | 更新时间 |
| create_by | bigint | NULL | 创建人ID |
| update_by | bigint | NULL | 更新人ID |
| remark | varchar(500) | NULL | 备注 |

**索引说明**:
- PRIMARY KEY (id): 主键索引
- UNIQUE KEY uk_username (username): 用户名唯一索引
- UNIQUE KEY uk_email (email): 邮箱唯一索引
- UNIQUE KEY uk_phone (phone): 手机号唯一索引
- KEY idx_status (status): 状态索引，用于快速筛选启用/禁用用户
- KEY idx_create_time (create_time): 创建时间索引，用于时间范围查询
- KEY idx_last_login_time (last_login_time): 最后登录时间索引

---

### 2. 模块表 (sys_module)

**表说明**: 存储系统核心模块信息（AD管理、自助服务、审计管理）

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|------|------|
| id | bigint | PK, AUTO_INCREMENT | 主键ID |
| module_name | varchar(50) | NOT NULL | 模块名称 |
| module_code | varchar(50) | UNIQUE, NOT NULL | 模块标识（唯一，如：ad_manager） |
| parent_id | bigint | NOT NULL, DEFAULT 0 | 父模块ID（0表示顶级模块） |
| module_path | varchar(200) | NULL | 模块路径（前端路由路径） |
| icon | varchar(50) | NULL | 模块图标（Element Plus图标名称） |
| sort_order | int | NOT NULL, DEFAULT 0 | 排序号（数字越小越靠前） |
| status | tinyint | NOT NULL, DEFAULT 1 | 状态：0-禁用，1-启用 |
| description | varchar(200) | NULL | 模块描述 |
| create_time | datetime | NOT NULL, DEFAULT NOW() | 创建时间 |
| update_time | datetime | NOT NULL, DEFAULT NOW() ON UPDATE | 更新时间 |

**索引说明**:
- PRIMARY KEY (id): 主键索引
- UNIQUE KEY uk_module_code (module_code): 模块编码唯一索引
- KEY idx_parent_id (parent_id): 父模块ID索引，用于树形结构查询
- KEY idx_status (status): 状态索引
- KEY idx_sort_order (sort_order): 排序号索引，用于排序查询

---

### 3. 权限表 (sys_permission)

**表说明**: 存储系统权限信息，支持树形结构

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|------|------|
| id | bigint | PK, AUTO_INCREMENT | 主键ID |
| permission_name | varchar(100) | NOT NULL | 权限名称 |
| permission_code | varchar(100) | UNIQUE, NOT NULL | 权限标识（唯一，如：ad:manage:user） |
| module_id | bigint | NULL, FK | 所属模块ID（关联sys_module.id） |
| permission_type | tinyint | NOT NULL | 权限类型：1-模块，2-按钮/菜单，3-接口/API |
| parent_id | bigint | NOT NULL, DEFAULT 0 | 父权限ID（0表示顶级权限） |
| api_path | varchar(500) | NULL | API路径（权限类型为接口时使用） |
| http_method | varchar(10) | NULL | HTTP方法（GET, POST, PUT, DELETE等） |
| sort_order | int | NOT NULL, DEFAULT 0 | 排序号 |
| status | tinyint | NOT NULL, DEFAULT 1 | 状态：0-禁用，1-启用 |
| description | varchar(200) | NULL | 权限描述 |
| create_time | datetime | NOT NULL, DEFAULT NOW() | 创建时间 |
| update_time | datetime | NOT NULL, DEFAULT NOW() ON UPDATE | 更新时间 |

**索引说明**:
- PRIMARY KEY (id): 主键索引
- UNIQUE KEY uk_permission_code (permission_code): 权限编码唯一索引
- KEY idx_module_id (module_id): 模块ID索引（外键索引）
- KEY idx_parent_id (parent_id): 父权限ID索引，用于树形结构查询
- KEY idx_permission_type (permission_type): 权限类型索引
- KEY idx_status (status): 状态索引
- KEY idx_sort_order (sort_order): 排序号索引

**外键约束**:
- FOREIGN KEY (module_id) REFERENCES sys_module(id) ON DELETE SET NULL ON UPDATE CASCADE

---

### 4. 角色表 (sys_role)

**表说明**: 存储系统角色信息

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|------|------|
| id | bigint | PK, AUTO_INCREMENT | 主键ID |
| role_name | varchar(50) | NOT NULL | 角色名称（如：超级管理员） |
| role_code | varchar(50) | UNIQUE, NOT NULL | 角色编码（唯一，如：super_admin） |
| description | varchar(200) | NULL | 角色描述 |
| status | tinyint | NOT NULL, DEFAULT 1 | 状态：0-禁用，1-启用 |
| sort_order | int | NOT NULL, DEFAULT 0 | 排序号 |
| create_time | datetime | NOT NULL, DEFAULT NOW() | 创建时间 |
| update_time | datetime | NOT NULL, DEFAULT NOW() ON UPDATE | 更新时间 |
| create_by | bigint | NULL | 创建人ID |
| update_by | bigint | NULL | 更新人ID |

**索引说明**:
- PRIMARY KEY (id): 主键索引
- UNIQUE KEY uk_role_code (role_code): 角色编码唯一索引
- KEY idx_status (status): 状态索引
- KEY idx_sort_order (sort_order): 排序号索引

---

### 5. 角色-权限关联表 (sys_role_permission)

**表说明**: 角色和权限的多对多关联表

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|------|------|
| id | bigint | PK, AUTO_INCREMENT | 主键ID |
| role_id | bigint | NOT NULL, FK | 角色ID（关联sys_role.id） |
| permission_id | bigint | NOT NULL, FK | 权限ID（关联sys_permission.id） |
| create_time | datetime | NOT NULL, DEFAULT NOW() | 创建时间 |

**索引说明**:
- PRIMARY KEY (id): 主键索引
- UNIQUE KEY uk_role_permission (role_id, permission_id): 角色-权限唯一索引，防止重复分配
- KEY idx_role_id (role_id): 角色ID索引（外键索引）
- KEY idx_permission_id (permission_id): 权限ID索引（外键索引）

**外键约束**:
- FOREIGN KEY (role_id) REFERENCES sys_role(id) ON DELETE CASCADE ON UPDATE CASCADE
- FOREIGN KEY (permission_id) REFERENCES sys_permission(id) ON DELETE CASCADE ON UPDATE CASCADE

---

### 6. 管理员-角色关联表 (sys_admin_role)

**表说明**: 管理员和角色的多对多关联表

| 字段名 | 类型 | 约束 | 说明 |
|--------|------|------|------|
| id | bigint | PK, AUTO_INCREMENT | 主键ID |
| admin_id | bigint | NOT NULL, FK | 管理员ID（关联sys_admin.id） |
| role_id | bigint | NOT NULL, FK | 角色ID（关联sys_role.id） |
| create_time | datetime | NOT NULL, DEFAULT NOW() | 创建时间 |

**索引说明**:
- PRIMARY KEY (id): 主键索引
- UNIQUE KEY uk_admin_role (admin_id, role_id): 管理员-角色唯一索引，防止重复分配
- KEY idx_admin_id (admin_id): 管理员ID索引（外键索引）
- KEY idx_role_id (role_id): 角色ID索引（外键索引）

**外键约束**:
- FOREIGN KEY (admin_id) REFERENCES sys_admin(id) ON DELETE CASCADE ON UPDATE CASCADE
- FOREIGN KEY (role_id) REFERENCES sys_role(id) ON DELETE CASCADE ON UPDATE CASCADE

---

## 🔗 表关联关系图

```
┌─────────────┐         ┌──────────────────┐         ┌─────────────┐
│ sys_admin   │────────>│ sys_admin_role   │<────────│ sys_role    │
│ (管理员)     │ 1      │ (管理员-角色)      │      N  │ (角色)       │
└─────────────┘         └──────────────────┘         └─────────────┘
                                                              │
                                                              │ N
                                                              │
                                                              ▼
                                                       ┌──────────────────┐
                                                       │sys_role_permission│
                                                       │ (角色-权限)       │
                                                       └──────────────────┘
                                                              │
                                                              │ N
                                                              │
                                                              ▼
                                                       ┌─────────────┐
                                                       │sys_permission│
                                                       │ (权限)       │
                                                       └─────────────┘
                                                              │
                                                              │ N
                                                              │
                                                              ▼
                                                       ┌─────────────┐
                                                       │ sys_module  │
                                                       │ (模块)       │
                                                       └─────────────┘
```

## 📐 关联关系说明

### 1. 管理员 ↔ 角色 (多对多)

- **关系**: `sys_admin` ←→ `sys_admin_role` ←→ `sys_role`
- **说明**: 一个管理员可以拥有多个角色，一个角色可以分配给多个管理员
- **示例**: 
  - 管理员 "admin" 可以同时拥有 "超级管理员" 和 "AD管理员" 两个角色
  - 角色 "审计查看员" 可以分配给多个管理员

### 2. 角色 ↔ 权限 (多对多)

- **关系**: `sys_role` ←→ `sys_role_permission` ←→ `sys_permission`
- **说明**: 一个角色可以拥有多个权限，一个权限可以分配给多个角色
- **示例**:
  - 角色 "AD管理员" 拥有 "ad:manage:user"、"ad:manage:group" 等多个权限
  - 权限 "audit:operation:view" 可以分配给多个角色

### 3. 权限 ↔ 模块 (多对一)

- **关系**: `sys_permission.module_id` → `sys_module.id`
- **说明**: 多个权限属于一个模块，一个模块可以有多个权限
- **示例**:
  - 权限 "ad:manage:user"、"ad:manage:group" 都属于 "AD管理" 模块
  - "AD管理" 模块下有多个权限

### 4. 权限自关联 (树形结构)

- **关系**: `sys_permission.parent_id` → `sys_permission.id`
- **说明**: 权限支持树形结构，可以有子权限
- **示例**:
  - 父权限: "AD用户管理" (id=1, parent_id=0)
  - 子权限: "查看AD用户" (id=2, parent_id=1), "编辑AD用户" (id=3, parent_id=1)

### 5. 模块自关联 (树形结构)

- **关系**: `sys_module.parent_id` → `sys_module.id`
- **说明**: 模块支持树形结构，可以有子模块
- **示例**:
  - 父模块: "AD管理" (id=1, parent_id=0)
  - 子模块: "AD用户管理" (id=2, parent_id=1), "AD组管理" (id=3, parent_id=1)

## 🔍 索引优化说明

### 唯一索引
- 防止重复数据：`username`、`email`、`phone`、`module_code`、`permission_code`、`role_code`
- 关联表唯一约束：`uk_admin_role`、`uk_role_permission` 防止重复分配

### 外键索引
- 所有外键字段都建立了索引，提升关联查询效率
- 使用CASCADE级联删除，确保数据一致性

### 查询优化索引
- **状态字段索引**: 用于快速筛选启用/禁用的数据
- **时间字段索引**: 用于时间范围查询和排序
- **排序字段索引**: 用于排序查询
- **父ID索引**: 用于树形结构查询（查询子节点）

## 🚀 查询示例

### 查询管理员的所有权限（通过角色）

```sql
SELECT DISTINCT 
    p.permission_code, 
    p.permission_name,
    m.module_name
FROM sys_admin a
JOIN sys_admin_role ar ON a.id = ar.admin_id
JOIN sys_role_permission rp ON ar.role_id = rp.role_id
JOIN sys_permission p ON rp.permission_id = p.id
LEFT JOIN sys_module m ON p.module_id = m.id
WHERE a.username = 'admin'
ORDER BY m.sort_order, p.sort_order;
```

### 查询角色的所有权限

```sql
SELECT 
    p.permission_code,
    p.permission_name,
    p.permission_type,
    m.module_name
FROM sys_role r
JOIN sys_role_permission rp ON r.id = rp.role_id
JOIN sys_permission p ON rp.permission_id = p.id
LEFT JOIN sys_module m ON p.module_id = m.id
WHERE r.role_code = 'super_admin'
ORDER BY m.sort_order, p.sort_order;
```

### 查询管理员的所有角色

```sql
SELECT 
    r.role_name,
    r.role_code,
    r.description
FROM sys_admin a
JOIN sys_admin_role ar ON a.id = ar.admin_id
JOIN sys_role r ON ar.role_id = r.id
WHERE a.username = 'admin'
ORDER BY r.sort_order;
```

### 查询模块的所有权限

```sql
SELECT 
    p.permission_code,
    p.permission_name,
    p.permission_type
FROM sys_module m
JOIN sys_permission p ON m.id = p.module_id
WHERE m.module_code = 'ad_manager'
ORDER BY p.sort_order;
```

## 📝 数据完整性约束

1. **外键约束**: 确保关联数据的完整性
2. **级联删除**: 
   - 删除角色时，自动删除该角色的权限关联和管理员关联
   - 删除管理员时，自动删除该管理员的角色关联
   - 删除权限时，自动删除该权限的角色关联
3. **唯一约束**: 防止重复数据
4. **非空约束**: 确保关键字段不为空

## 🔒 安全建议

1. **密码存储**: 使用BCrypt等强加密算法，不要明文存储
2. **权限验证**: 在API层面验证权限，不要仅依赖前端
3. **审计日志**: 记录所有权限变更操作
4. **定期审查**: 定期审查管理员权限，及时回收不需要的权限

---

**文档版本**: 1.0.0  
**最后更新**: 2024-12-30

