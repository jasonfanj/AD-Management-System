# AD管理模块核心功能说明文档

## 📋 功能概述

本模块实现了AD管理模块（对应ADManager Plus）的核心基础功能，包括AD用户管理、OU管理等。

## 🏗️ 代码结构

### 后端代码结构

```
com.admanagement
├── entity/
│   ├── AdUser.java              # AD用户实体
│   ├── AdGroup.java             # AD组实体
│   ├── AdOu.java                # OU实体
│   ├── dto/
│   │   └── AdUserQueryDTO.java  # AD用户查询DTO
│   └── vo/
│       ├── AdUserVO.java        # AD用户VO
│       └── AdOuVO.java          # OU VO
├── repository/
│   └── AdUserMapper.java        # AD用户Mapper
├── service/
│   ├── AdUserService.java       # AD用户服务接口
│   ├── AdOuService.java         # OU服务接口
│   └── impl/
│       ├── AdUserServiceImpl.java
│       └── AdOuServiceImpl.java
└── controller/
    └── ad/
        ├── AdUserController.java # AD用户控制器
        └── AdOuController.java   # OU控制器
```

### 前端代码结构

```
src/
├── api/
│   └── ad.js                    # AD管理API接口
├── views/
│   └── pages/
│       └── modules/
│           ├── AdUserList.vue   # AD用户列表页
│           └── AdOuList.vue     # OU管理页
└── router/
    └── index.js                 # 路由配置（已更新）
```

## 🔑 核心功能

### 1. AD用户管理

#### 后端接口

**查询AD用户列表**
- **URL**: `GET /api/ad-manage/users/list`
- **权限**: `@ModulePermission(value = "ad_manager")`
- **请求参数**:
  - `keyword` - 搜索关键词（可选）
  - `accountStatus` - 账户状态（可选）
  - `department` - 部门（可选）
  - `pageNum` - 页码（默认1）
  - `pageSize` - 每页数量（默认10）
- **响应**: 分页结果（`PageResult<AdUserVO>`）

**批量导入预览**
- **URL**: `POST /api/ad-manage/users/preview-import`
- **权限**: `@ModulePermission(value = "ad_manager")`
- **请求体**: `List<AdUserVO>`
- **响应**: `List<AdUserVO>`

#### 前端页面

**AdUserList.vue**
- 搜索框（支持账号、姓名、邮箱搜索）
- 账户状态筛选
- 表格展示（Element Plus ElTable）
- 分页组件
- 操作列（编辑、删除，暂未实现）

### 2. OU管理

#### 后端接口

**查询OU列表**
- **URL**: `GET /api/ad-manage/ous/list`
- **权限**: `@ModulePermission(value = "ad_manager")`
- **响应**: OU列表（树形结构）

**根据DN查询OU信息**
- **URL**: `GET /api/ad-manage/ous/{dn}`
- **权限**: `@ModulePermission(value = "ad_manager")`
- **响应**: OU信息

#### 前端页面

**AdOuList.vue**
- OU树形表格展示
- 显示OU名称、描述、路径、用户数量、组数量
- 操作列（查看、编辑，暂未实现）

## 📝 使用说明

### 后端使用

#### 1. 实体类

**AdUser（AD用户实体）**
```java
@Entity
@TableName("ad_user")
public class AdUser {
    private Long id;
    private String samAccountName;  // SAM账户名
    private String displayName;     // 显示名称
    private String email;           // 邮箱
    // ... 其他字段
}
```

**AdOu（OU实体）**
```java
@Data
public class AdOu {
    private String dn;              // OU的DN
    private String name;            // OU名称
    private String description;     // 描述
    private List<AdOu> children;    // 子OU列表
}
```

#### 2. 控制器

所有控制器都添加了`@ModulePermission(value = "ad_manager")`注解进行权限校验：

```java
@RestController
@RequestMapping("/ad-manage/users")
@ModulePermission(value = "ad_manager", description = "AD管理模块")
public class AdUserController {
    // ...
}
```

#### 3. 服务层

**AdUserService（AD用户服务）**
- `getAdUserList()` - 分页查询AD用户列表
- `previewBatchImport()` - 批量导入预览（模拟数据）

**AdOuService（OU服务）**
- `getOuList()` - 查询OU列表（模拟数据，后续替换为真实AD对接）
- `getOuByDn()` - 根据DN查询OU信息（模拟数据）

### 前端使用

#### 1. 路由配置

路由已配置在`router/index.js`的`asyncRoutes`中：

```javascript
{
  path: '/ad-manager',
  component: Layout,
  name: 'ADManagerLayout',
  meta: {
    title: 'AD管理',
    icon: 'Document',
    moduleCode: 'ad_manager',
    roles: ['super_admin', 'ad_admin']
  },
  children: [
    {
      path: 'users',
      name: 'ADUsers',
      component: AdUserList,
      meta: {
        title: 'AD用户管理',
        icon: 'User'
      }
    },
    {
      path: 'ous',
      name: 'ADOUs',
      component: AdOuList,
      meta: {
        title: 'OU管理',
        icon: 'Folder'
      }
    }
  ]
}
```

#### 2. API调用

```javascript
import { getAdUserList, getOuList } from '@/api/ad'

// 查询AD用户列表
const response = await getAdUserList({
  keyword: 'admin',
  pageNum: 1,
  pageSize: 10
})

// 查询OU列表
const response = await getOuList()
```

#### 3. 页面访问

- AD用户管理: `http://localhost:3000/ad-manage/user`
- OU管理: `http://localhost:3000/ad-manage/ou`

## 🔌 接口对接说明

### 1. AD用户列表查询接口

**请求示例**:
```bash
GET /api/ad-manage/users/list?keyword=admin&pageNum=1&pageSize=10
Authorization: Bearer {token}
```

**响应示例**:
```json
{
  "code": 200,
  "message": "操作成功",
  "data": {
    "pageNum": 1,
    "pageSize": 10,
    "total": 100,
    "totalPages": 10,
    "list": [
      {
        "id": 1,
        "samAccountName": "admin",
        "displayName": "管理员",
        "email": "admin@example.com",
        "department": "IT",
        "accountStatus": 1,
        "accountStatusText": "启用",
        "lastLogon": "2024-12-30T10:00:00",
        "passwordExpires": "2025-03-30T10:00:00"
      }
    ]
  }
}
```

### 2. OU列表查询接口

**请求示例**:
```bash
GET /api/ad-manage/ous/list
Authorization: Bearer {token}
```

**响应示例**:
```json
{
  "code": 200,
  "message": "操作成功",
  "data": [
    {
      "dn": "OU=Users,DC=example,DC=com",
      "name": "Users",
      "description": "用户组织单元",
      "path": "DC=example,DC=com > Users",
      "userCount": 100,
      "groupCount": 20,
      "children": [
        {
          "dn": "OU=IT,OU=Users,DC=example,DC=com",
          "name": "IT",
          "description": "IT部门",
          "path": "DC=example,DC=com > Users > IT",
          "userCount": 30,
          "groupCount": 5
        }
      ]
    }
  ]
}
```

## ⚠️ 注意事项

1. **权限校验**:
   - 所有接口都添加了`@ModulePermission(value = "ad_manager")`注解
   - 需要管理员拥有`ad_manager`模块的权限才能访问

2. **模拟数据**:
   - OU服务目前返回模拟数据
   - AD用户数据从数据库查询（需要先同步AD数据到数据库）
   - 后续需要替换为真实AD域控对接

3. **分页查询**:
   - 使用MySQL的LIMIT和OFFSET实现分页
   - 页码从1开始

4. **路由路径**:
   - 前端路由使用`/ad-manage`
   - 后端接口使用`/api/ad-manage`
   - 模块标识（moduleCode）使用`ad_manager`

5. **数据库表**:
   - 需要先执行数据库初始化脚本创建`ad_user`、`ad_group`等表
   - 如果没有数据，查询结果为空列表

## 🚀 后续扩展

1. **真实AD对接**:
   - 替换OU服务的模拟数据为真实AD查询
   - 实现AD用户同步功能
   - 实现AD用户增删改操作

2. **批量导入**:
   - 实现Excel文件上传
   - 实现批量导入功能

3. **更多功能**:
   - AD组管理
   - AD用户详情页
   - AD用户编辑功能
   - AD用户删除功能

---

**版本**: 1.0.0  
**最后更新**: 2024-12-30
