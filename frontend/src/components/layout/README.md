# 前端模块导航栏及模块切换功能说明文档

## 📋 功能概述

本模块实现了基于Vue3 + Element Plus的模块导航栏和模块切换功能，包括侧边导航栏、顶部导航栏、模块切换下拉框等功能。

## 🏗️ 组件结构

```
components/layout/
├── Layout.vue           # 主布局组件
├── Header.vue           # 顶部导航栏组件
├── Sidebar.vue          # 侧边导航栏组件
└── ModuleSwitch.vue     # 模块切换组件
```

## 🔑 核心功能

### 1. Layout.vue（主布局）

#### 功能
- 包含顶部导航栏和侧边导航栏
- 主内容区域（router-view）
- 页面加载时自动加载模块列表

#### 布局结构
```
┌─────────────────────────────────┐
│         Header（顶部栏）          │
├──────────┬──────────────────────┤
│          │                      │
│ Sidebar  │    Main Content      │
│（侧边栏） │    （主内容区）        │
│          │                      │
└──────────┴──────────────────────┘
```

### 2. Header.vue（顶部导航栏）

#### 功能
- 显示系统Logo
- 显示当前模块名称
- 模块切换下拉框
- 用户信息下拉菜单（个人信息、退出登录）

#### 组件位置
- 左侧：Logo
- 中间：当前模块显示
- 右侧：模块切换 + 用户信息

### 3. Sidebar.vue（侧边导航栏）

#### 功能
- 使用Element Plus ElMenu组件
- 动态生成菜单项（基于当前模块的路由）
- 菜单高亮（当前激活路由）
- 支持多级菜单

#### 数据来源
- 基于当前模块（adminStore.currentModule）
- 从路由中筛选属于当前模块的路由
- 构建菜单树结构

### 4. ModuleSwitch.vue（模块切换组件）

#### 功能
- 下拉框显示所有有权限的模块
- 选择模块后调用后端接口校验权限
- 校验通过后跳转到模块首页
- 更新当前模块和导航栏

#### 交互流程
1. 用户选择目标模块
2. 调用`/api/module/switch`接口
3. 后端校验权限
4. 校验通过后更新当前模块
5. 跳转到模块首页
6. 更新侧边导航栏

## 🔌 与后端接口对接

### 1. 查询模块列表接口

**接口地址**: `GET /api/module/list`

**请求**:
```javascript
// 在 Layout.vue 中调用
import { getModules } from '@/api/module'

const response = await getModules()
// response.data 为模块列表
```

**响应格式**:
```json
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
    }
  ]
}
```

### 2. 模块切换接口

**接口地址**: `POST /api/module/switch`

**请求**:
```javascript
// 在 ModuleSwitch.vue 中调用
import { switchModule } from '@/api/module'

const response = await switchModule({ moduleCode: 'ad_manager' })
// response.data 为模块信息
```

**响应格式**:
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

## 📝 Pinia Store 更新

### 新增状态
- `currentModule` - 当前模块信息
- `modules` - 模块列表

### 新增方法
- `setCurrentModule(module)` - 设置当前模块
- `setModules(moduleList)` - 设置模块列表

### 数据持久化
- `currentModule` 和 `modules` 都会存储到 localStorage
- 页面刷新后自动恢复

## 🔄 路由与导航联动

### 1. 菜单高亮

- 使用`el-menu`的`default-active`属性
- 绑定当前路由路径（`route.path`）
- 菜单项使用`router`模式，自动跳转

### 2. 路由跳转

- 点击菜单项自动跳转到对应路由
- 使用Vue Router的`router`模式

### 3. 刷新保持状态

- 当前模块信息存储在localStorage
- 页面刷新后从localStorage恢复
- 根据当前模块筛选路由，保持菜单高亮

### 4. 模块切换流程

```
用户选择模块
  ↓
调用后端接口（/api/module/switch）
  ↓
校验权限
  ↓
更新当前模块（adminStore.setCurrentModule）
  ↓
更新localStorage
  ↓
跳转到模块首页
  ↓
侧边栏自动更新（基于当前模块筛选路由）
  ↓
菜单高亮当前路由
```

## ⚙️ 配置说明

### 路由配置要求

1. **模块路由必须包含moduleCode**:
```javascript
{
  path: '/ad-manager',
  component: Layout,
  meta: {
    moduleCode: 'ad_manager',  // 必须配置
    title: 'AD管理'
  }
}
```

2. **模块路径配置**:
```javascript
// 在模块切换时，优先使用modulePath跳转
// 如果没有modulePath，则根据moduleCode查找路由
```

### Store配置

在`adminStore.js`中已添加：
- `currentModule` - 当前模块状态
- `modules` - 模块列表状态
- `setCurrentModule()` - 设置当前模块方法
- `setModules()` - 设置模块列表方法

## 🎨 样式说明

### 侧边栏样式
- 背景色：`#304156`（深蓝灰色）
- 文字颜色：`#bfcbd9`（浅灰色）
- 激活文字颜色：`#409EFF`（蓝色）
- 菜单项高度：50px

### 顶部栏样式
- 背景色：白色
- 高度：60px
- 阴影：底部阴影效果

### 响应式设计
- 侧边栏固定宽度：200px
- 主内容区自适应宽度
- 支持菜单折叠（预留功能）

## ⚠️ 注意事项

1. **模块加载时机**:
   - Layout组件挂载时自动加载模块列表
   - 如果已有模块列表，不会重复加载

2. **当前模块初始化**:
   - 如果localStorage中没有当前模块，自动设置为第一个模块
   - 自动跳转到第一个模块的首页

3. **路由匹配规则**:
   - 优先使用`modulePath`匹配
   - 其次使用`moduleCode`匹配
   - 确保路由meta中包含`moduleCode`

4. **菜单生成逻辑**:
   - 基于当前模块筛选路由
   - 构建父子菜单结构
   - 支持多级菜单嵌套

5. **模块切换权限**:
   - 前端显示所有有权限的模块
   - 切换时后端会再次校验权限
   - 无权限会显示错误提示

## 🚀 使用示例

### 1. 在路由中配置模块标识

```javascript
// router/index.js
{
  path: '/ad-manager',
  component: Layout,
  meta: {
    moduleCode: 'ad_manager',  // 必须配置
    title: 'AD管理',
    icon: 'Document'
  },
  children: [
    {
      path: 'users',
      component: ADUsers,
      meta: {
        title: 'AD用户管理',
        icon: 'User'
      }
    }
  ]
}
```

### 2. 在组件中使用当前模块

```vue
<template>
  <div>
    <h1>{{ currentModule.moduleName }}</h1>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useAdminStore } from '@/store/adminStore'

const adminStore = useAdminStore()
const currentModule = computed(() => adminStore.currentModule)
</script>
```

---

**版本**: 1.0.0  
**最后更新**: 2024-12-30

