# 模块权限校验核心逻辑说明文档

## 📋 功能概述

本模块实现了基于注解的模块权限校验功能，包括权限查询、模块权限校验和模块切换功能。

## 🏗️ 代码结构

```
com.admanagement
├── annotation/
│   └── ModulePermission.java          # 模块权限注解
├── aspect/
│   └── ModulePermissionAspect.java    # 权限校验切面
├── controller/
│   ├── SysPermissionController.java   # 权限查询接口
│   ├── SysModuleController.java       # 模块管理接口
│   └── ad/
│       └── ADManagerController.java   # AD管理控制器（使用示例）
├── service/
│   ├── SysPermissionService.java      # 权限服务接口
│   ├── SysModuleService.java          # 模块服务接口
│   └── impl/
│       ├── SysPermissionServiceImpl.java
│       └── SysModuleServiceImpl.java
├── repository/
│   ├── SysPermissionMapper.java       # 权限Mapper
│   └── SysModuleMapper.java           # 模块Mapper
├── entity/
│   ├── SysPermission.java             # 权限实体
│   ├── SysModule.java                 # 模块实体
│   ├── dto/
│   │   └── ModuleSwitchDTO.java       # 模块切换DTO
│   └── vo/
│       └── ModuleInfoVO.java          # 模块信息VO
└── exception/
    └── PermissionException.java       # 权限异常
```

## 🔑 核心功能

### 1. @ModulePermission 注解

#### 注解定义
```java
@Target({ElementType.METHOD, ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
public @interface ModulePermission {
    String value();              // 模块标识（必填）
    String description() default "";  // 权限说明（可选）
}
```

#### 使用方式
- **类级别**：整个Controller都需要该模块权限
- **方法级别**：特定方法需要该模块权限（优先级高于类级别）

### 2. 权限校验切面（ModulePermissionAspect）

#### 功能
- 拦截带有`@ModulePermission`注解的方法
- 获取当前管理员权限
- 校验是否包含该模块标识
- 无权限则抛出`PermissionException`异常

#### 校验流程
1. 获取`@ModulePermission`注解
2. 获取当前管理员ID（从`AdminContext`）
3. 调用`SysPermissionService.hasModulePermission()`校验权限
4. 无权限则抛出异常，由全局异常处理器处理

### 3. 权限查询接口

#### 接口1：查询所有权限标识
- **URL**: `GET /api/permission/codes` 或 `GET /api/permission/codes/{adminId}`
- **功能**: 根据管理员ID查询该用户的所有权限（含模块权限、按钮权限），返回权限标识列表
- **示例**:
```bash
GET /api/permission/codes
Authorization: Bearer {token}

Response:
{
  "code": 200,
  "message": "操作成功",
  "data": [
    "ad:manage:user",
    "ad:manage:group",
    "ad:manage:ou",
    "ad:sync",
    ...
  ]
}
```

#### 接口2：查询有权限的模块列表
- **URL**: `GET /api/module/list` 或 `GET /api/module/list/{adminId}`
- **功能**: 根据管理员ID查询该用户有权限访问的模块列表（关联sys_module表，只返回启用状态的模块）
- **示例**:
```bash
GET /api/module/list
Authorization: Bearer {token}

Response:
{
  "code": 200,
  "message": "操作成功",
  "data": [
    {
      "id": 1,
      "moduleName": "AD管理",
      "moduleCode": "ad_manager",
      "modulePath": "/ad-manager",
      "icon": "Document",
      "description": "Active Directory域管理核心模块",
      "children": []
    },
    ...
  ]
}
```

### 4. 模块切换接口

- **URL**: `POST /api/module/switch`
- **功能**: 接收目标模块标识参数 → 校验当前管理员是否有该模块权限 → 校验通过后返回该模块的基础信息（模块名称、路径、子模块列表）
- **请求体**:
```json
{
  "moduleCode": "ad_manager"
}
```
- **响应**:
```json
{
  "code": 200,
  "message": "模块切换成功",
  "data": {
    "id": 1,
    "moduleName": "AD管理",
    "moduleCode": "ad_manager",
    "modulePath": "/ad-manager",
    "icon": "Document",
    "description": "Active Directory域管理核心模块",
    "children": []
  }
}
```

## 📝 使用示例

### 示例1：在Controller类上使用注解（整个类都需要该模块权限）

```java
@RestController
@RequestMapping("/ad-manager")
@ModulePermission(value = "ad_manager", description = "AD管理模块")
public class ADManagerController {
    
    @GetMapping("/users")
    public Result<String> getUsers() {
        // 所有方法都会自动进行权限校验
        return Result.success("获取AD用户列表成功");
    }
    
    @GetMapping("/groups")
    public Result<String> getGroups() {
        return Result.success("获取AD组列表成功");
    }
}
```

### 示例2：在方法上使用注解（仅特定方法需要权限校验）

```java
@RestController
@RequestMapping("/ad-manager")
public class ADManagerController {
    
    @GetMapping("/users")
    @ModulePermission(value = "ad_manager", description = "AD用户管理")
    public Result<String> getUsers() {
        // 只有这个方法会进行权限校验
        return Result.success("获取AD用户列表成功");
    }
    
    @GetMapping("/public-info")
    public Result<String> getPublicInfo() {
        // 这个方法不需要权限校验
        return Result.success("获取公共信息成功");
    }
}
```

### 示例3：方法级别注解覆盖类级别注解

```java
@RestController
@RequestMapping("/ad-manager")
@ModulePermission(value = "ad_manager", description = "AD管理模块")
public class ADManagerController {
    
    @GetMapping("/users")
    @ModulePermission(value = "ad_manager", description = "AD用户管理")
    public Result<String> getUsers() {
        // 使用方法级别的注解（ad_manager）
        return Result.success("获取AD用户列表成功");
    }
    
    @GetMapping("/groups")
    public Result<String> getGroups() {
        // 使用类级别的注解（ad_manager）
        return Result.success("获取AD组列表成功");
    }
}
```

## 🔍 权限校验流程

### 流程图

```
请求 → 切面拦截 → 获取@ModulePermission注解
  ↓
获取当前管理员ID → 查询管理员权限列表
  ↓
检查权限列表中是否包含该模块的权限
  ↓
有权限 → 继续执行方法
无权限 → 抛出PermissionException → 全局异常处理器 → 返回403错误
```

### 权限校验逻辑

1. **模块权限检查**：
   - 根据模块标识（如`ad_manager`）查询模块信息
   - 根据管理员ID和模块ID查询权限列表
   - 如果查询到权限，说明有该模块的访问权限

2. **权限来源**：
   - 管理员 → 角色（sys_admin_role）
   - 角色 → 权限（sys_role_permission）
   - 权限 → 模块（sys_permission.module_id → sys_module.id）

## ⚠️ 注意事项

1. **注解位置**：
   - 类级别：整个Controller都需要该模块权限
   - 方法级别：仅该方法需要权限校验（优先级更高）

2. **权限标识**：
   - 必须使用数据库中`sys_module.module_code`的值
   - 例如：`ad_manager`、`self_service`、`audit`

3. **异常处理**：
   - 权限校验失败会抛出`PermissionException`
   - 由`GlobalExceptionHandler`统一处理，返回403错误

4. **管理员上下文**：
   - 权限校验需要从`AdminContext`获取当前管理员ID
   - 确保Token拦截器已正确设置管理员上下文

5. **性能优化**：
   - 可以考虑缓存管理员的权限列表
   - 避免每次请求都查询数据库

## 🚀 扩展功能

### 1. 缓存权限列表

可以在Service层添加缓存，避免频繁查询数据库：

```java
@Cacheable(value = "adminPermissions", key = "#adminId")
public List<String> getPermissionCodesByAdminId(Long adminId) {
    return sysPermissionMapper.selectPermissionCodesByAdminId(adminId);
}
```

### 2. 按钮权限校验

可以扩展注解支持按钮权限校验：

```java
@ModulePermission(value = "ad_manager", button = "add")
```

### 3. 权限组合

可以支持多个模块权限的OR/AND逻辑：

```java
@ModulePermission(value = {"ad_manager", "self_service"}, logic = "OR")
```

---

**版本**: 1.0.0  
**最后更新**: 2024-12-30

