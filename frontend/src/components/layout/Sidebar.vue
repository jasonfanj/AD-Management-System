<template>
  <el-scrollbar class="sidebar-scrollbar">
    <el-menu
      :default-active="activeMenu"
      :collapse="isCollapse"
      :unique-opened="false"
      router
      class="sidebar-menu"
      background-color="#304156"
      text-color="#bfcbd9"
      active-text-color="#409EFF"
    >
      <template v-for="item in menuRoutes" :key="item.path">
        <!-- 有子菜单的情况 -->
        <el-sub-menu v-if="item.children && item.children.length > 0" :index="item.path">
          <template #title>
            <el-icon v-if="item.meta?.icon">
              <component :is="item.meta.icon" />
            </el-icon>
            <span>{{ item.meta?.title }}</span>
          </template>
          <el-menu-item
            v-for="child in item.children"
            :key="child.path"
            :index="resolveChildPath(item.path, child.path)"
          >
            <el-icon v-if="child.meta?.icon">
              <component :is="child.meta.icon" />
            </el-icon>
            <span>{{ child.meta?.title }}</span>
          </el-menu-item>
        </el-sub-menu>
        
        <!-- 无子菜单的情况 -->
        <el-menu-item v-else :index="item.path">
          <el-icon v-if="item.meta?.icon">
            <component :is="item.meta.icon" />
          </el-icon>
          <span>{{ item.meta?.title }}</span>
        </el-menu-item>
      </template>
    </el-menu>
  </el-scrollbar>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAdminStore } from '@/store/adminStore'

const route = useRoute()
const router = useRouter()
const adminStore = useAdminStore()

// 是否折叠
const isCollapse = computed(() => false)

// 解析子路径（处理路径拼接）
const resolveChildPath = (parentPath, childPath) => {
  // 如果childPath以/开头，说明是绝对路径
  if (childPath.startsWith('/')) {
    return childPath
  }
  // 否则拼接父路径和子路径
  return parentPath.endsWith('/') 
    ? parentPath + childPath 
    : parentPath + '/' + childPath
}

// 当前激活的菜单
const activeMenu = computed(() => {
  const { path } = route
  return path
})

// 获取菜单路由（基于当前模块和动态路由）
const menuRoutes = computed(() => {
  const routes = router.getRoutes()
  const currentModule = adminStore.currentModule
  
  if (!currentModule) {
    return []
  }
  
  // 查找当前模块对应的Layout路由
  const moduleLayoutRoute = routes.find(route => {
    // 匹配模块标识
    if (route.meta?.moduleCode === currentModule.moduleCode) {
      return route.children && route.children.length > 0
    }
    // 或者匹配模块路径
    if (currentModule.modulePath && route.path === currentModule.modulePath) {
      return route.children && route.children.length > 0
    }
    return false
  })
  
  if (!moduleLayoutRoute || !moduleLayoutRoute.children) {
    return []
  }
  
  // 返回Layout路由的子路由作为菜单项
  // 过滤掉不需要在菜单中显示的路由（hidden: true）
  return moduleLayoutRoute.children
    .filter(child => !child.meta?.hidden)
    .map(child => ({
      path: moduleLayoutRoute.path + '/' + child.path,
      meta: child.meta || {},
      children: child.children || []
    }))
})
</script>

<style scoped lang="scss">
.sidebar-scrollbar {
  height: calc(100vh - 60px);
  
  :deep(.el-scrollbar__wrap) {
    overflow-x: hidden;
  }
}

.sidebar-menu {
  border: none;
  height: 100%;
  
  :deep(.el-menu-item),
  :deep(.el-sub-menu__title) {
    height: 50px;
    line-height: 50px;
    
    &:hover {
      background-color: rgba(255, 255, 255, 0.1) !important;
    }
  }
  
  :deep(.el-menu-item.is-active) {
    background-color: #409EFF !important;
    color: #fff !important;
    
    &:before {
      content: '';
      position: absolute;
      left: 0;
      top: 0;
      bottom: 0;
      width: 3px;
      background-color: #409EFF;
    }
  }
  
  :deep(.el-icon) {
    margin-right: 8px;
    font-size: 18px;
  }
}
</style>
