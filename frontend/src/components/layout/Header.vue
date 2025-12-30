<template>
  <div class="header-container">
    <div class="header-left">
      <div class="logo">
        <span class="logo-text">AD管理系统</span>
      </div>
    </div>
    
    <div class="header-center">
      <div class="current-module" v-if="currentModule">
        <el-icon><Document /></el-icon>
        <span>{{ currentModule.moduleName }}</span>
      </div>
    </div>
    
    <div class="header-right">
      <ModuleSwitch />
      
      <el-dropdown @command="handleCommand" class="user-dropdown">
        <span class="user-info">
          <el-avatar :size="32" :src="adminInfo?.avatar">
            {{ adminInfo?.realName?.charAt(0) || adminInfo?.username?.charAt(0) }}
          </el-avatar>
          <span class="username">{{ adminInfo?.realName || adminInfo?.username }}</span>
          <el-icon><ArrowDown /></el-icon>
        </span>
        <template #dropdown>
          <el-dropdown-menu>
            <el-dropdown-item command="profile">个人信息</el-dropdown-item>
            <el-dropdown-item command="logout" divided>退出登录</el-dropdown-item>
          </el-dropdown-menu>
        </template>
      </el-dropdown>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Document, ArrowDown } from '@element-plus/icons-vue'
import { useAdminStore } from '@/store/adminStore'
import ModuleSwitch from './ModuleSwitch.vue'

const router = useRouter()
const adminStore = useAdminStore()

const currentModule = computed(() => adminStore.currentModule)
const adminInfo = computed(() => adminStore.adminInfo)

const handleCommand = (command) => {
  switch (command) {
    case 'profile':
      // 跳转到个人信息页面
      router.push('/profile')
      break
    case 'logout':
      handleLogout()
      break
  }
}

const handleLogout = async () => {
  try {
    await ElMessageBox.confirm('确定要退出登录吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    
    await adminStore.logout()
    ElMessage.success('退出登录成功')
    router.push('/login')
  } catch (error) {
    // 用户取消
  }
}
</script>

<style scoped lang="scss">
.header-container {
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px;
  background-color: #fff;
  box-shadow: 0 1px 4px rgba(0, 21, 41, 0.08);
  position: relative;
  z-index: 1000;
}

.header-left {
  .logo {
    .logo-text {
      font-size: 20px;
      font-weight: 600;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }
  }
}

.header-center {
  flex: 1;
  display: flex;
  justify-content: center;
  
  .current-module {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 8px 16px;
    background-color: #f5f7fa;
    border-radius: 4px;
    font-size: 14px;
    color: #333;
    
    .el-icon {
      color: #409EFF;
    }
  }
}

.header-right {
  display: flex;
  align-items: center;
  gap: 20px;
  
  .user-dropdown {
    cursor: pointer;
    
    .user-info {
      display: flex;
      align-items: center;
      gap: 8px;
      
      .username {
        font-size: 14px;
        color: #333;
      }
      
      .el-icon {
        color: #999;
        font-size: 12px;
      }
    }
  }
}
</style>

