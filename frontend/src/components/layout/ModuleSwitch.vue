<template>
  <el-select
    v-model="selectedModuleCode"
    placeholder="切换模块"
    @change="handleModuleSwitch"
    style="width: 180px"
    clearable
  >
    <el-option
      v-for="module in availableModules"
      :key="module.moduleCode"
      :label="module.moduleName"
      :value="module.moduleCode"
    >
      <div style="display: flex; align-items: center; gap: 8px">
        <el-icon v-if="module.icon">
          <component :is="module.icon" />
        </el-icon>
        <span>{{ module.moduleName }}</span>
      </div>
    </el-option>
  </el-select>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { useAdminStore } from '@/store/adminStore'
import { switchModule } from '@/api/module'

const router = useRouter()
const adminStore = useAdminStore()

const selectedModuleCode = ref(adminStore.currentModule?.moduleCode || '')

// 可用的模块列表
const availableModules = computed(() => adminStore.modules)

// 模块切换处理
const handleModuleSwitch = async (moduleCode) => {
  if (!moduleCode) {
    return
  }
  
  // 如果选择的是当前模块，不做处理
  if (moduleCode === adminStore.currentModule?.moduleCode) {
    return
  }
  
  try {
    // 调用后端模块切换接口
    const response = await switchModule({ moduleCode })
    
    if (response.code === 200) {
      const moduleInfo = response.data
      
      // 更新当前模块
      adminStore.setCurrentModule(moduleInfo)
      selectedModuleCode.value = moduleCode
      
      ElMessage.success(`已切换到${moduleInfo.moduleName}模块`)
      
      // 跳转到该模块的首页
      if (moduleInfo.modulePath) {
        router.push(moduleInfo.modulePath)
      } else {
        // 如果模块没有指定路径，尝试根据模块标识构建路径
        const moduleRoute = router.getRoutes().find(route => {
          return route.meta?.moduleCode === moduleCode && route.children && route.children.length > 0
        })
        
        if (moduleRoute && moduleRoute.children && moduleRoute.children.length > 0) {
          router.push(moduleRoute.children[0].path)
        } else {
          router.push('/')
        }
      }
    }
  } catch (error) {
    console.error('模块切换失败:', error)
    ElMessage.error(error.message || '模块切换失败，请检查权限')
    // 切换失败，恢复原值
    selectedModuleCode.value = adminStore.currentModule?.moduleCode || ''
  }
}

// 监听当前模块变化，更新选中值
onMounted(() => {
  if (adminStore.currentModule) {
    selectedModuleCode.value = adminStore.currentModule.moduleCode
  }
})
</script>

<style scoped lang="scss">
:deep(.el-select) {
  .el-input__inner {
    font-size: 14px;
  }
}
</style>

