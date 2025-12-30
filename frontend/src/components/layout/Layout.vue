<template>
  <div class="layout-container">
    <!-- 顶部导航栏 -->
    <Header />
    
    <div class="layout-body">
      <!-- 侧边导航栏 -->
      <aside class="sidebar">
        <Sidebar />
      </aside>
      
      <!-- 主内容区 -->
      <main class="main-content">
        <router-view />
      </main>
    </div>
  </div>
</template>

<script setup>
import { onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { useAdminStore } from '@/store/adminStore'
import { getModules } from '@/api/module'
import Header from './Header.vue'
import Sidebar from './Sidebar.vue'

const router = useRouter()
const adminStore = useAdminStore()

// 加载模块列表
const loadModules = async () => {
  try {
    // 如果已经有模块列表，不再重复加载
    if (adminStore.modules && adminStore.modules.length > 0) {
      // 检查是否有当前模块，如果没有则设置第一个模块为当前模块
      if (!adminStore.currentModule && adminStore.modules.length > 0) {
        adminStore.setCurrentModule(adminStore.modules[0])
      }
      return
    }
    
    const response = await getModules()
    
    if (response.code === 200) {
      const modules = response.data || []
      adminStore.setModules(modules)
      
      // 如果没有当前模块，设置第一个模块为当前模块
      if (!adminStore.currentModule && modules.length > 0) {
        const firstModule = modules[0]
        adminStore.setCurrentModule(firstModule)
        
        // 跳转到第一个模块的首页
        // 注意：这里需要根据实际的路由配置来确定首页路径
        // 如果modulePath是/ad-manager，需要跳转到/ad-manage/user（根据路由配置）
        if (firstModule.moduleCode === 'ad_manager') {
          router.push('/ad-manage/user')
        } else if (firstModule.modulePath) {
          router.push(firstModule.modulePath)
        }
      }
    }
  } catch (error) {
    console.error('加载模块列表失败:', error)
    ElMessage.error('加载模块列表失败')
  }
}

onMounted(() => {
  loadModules()
})
</script>

<style scoped lang="scss">
.layout-container {
  width: 100%;
  height: 100vh;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.layout-body {
  flex: 1;
  display: flex;
  overflow: hidden;
}

.sidebar {
  width: 200px;
  background-color: #304156;
  overflow: hidden;
}

.main-content {
  flex: 1;
  overflow-y: auto;
  background-color: #f0f2f5;
  padding: 20px;
}
</style>