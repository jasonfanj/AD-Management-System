/**
 * 权限指令
 * 用于控制元素（如按钮）的显示/隐藏
 * 
 * 使用方式：
 * <el-button v-permission="'ad:manage:user:add'">新增用户</el-button>
 * <el-button v-permission="['ad:manage:user:edit', 'ad:manage:user:delete']">编辑</el-button>
 */

import { useAdminStore } from '@/store/adminStore'

/**
 * 检查是否有权限
 * @param {string|string[]} permission 权限标识（字符串或数组）
 * @param {Array} permissions 权限列表
 * @returns {boolean}
 */
function hasPermission(permission, permissions) {
  if (!permission) {
    return true
  }
  
  // 如果是数组，只要有一个权限存在即可
  if (Array.isArray(permission)) {
    return permission.some(p => permissions.includes(p))
  }
  
  // 如果是字符串，直接判断
  return permissions.includes(permission)
}

/**
 * 权限指令
 */
export default {
  mounted(el, binding) {
    const adminStore = useAdminStore()
    const permissions = adminStore.permissions || []
    const permission = binding.value
    
    // 检查权限
    if (!hasPermission(permission, permissions)) {
      // 如果没有权限，隐藏元素
      el.style.display = 'none'
      // 或者移除元素
      // el.parentNode?.removeChild(el)
    }
  },
  
  updated(el, binding) {
    const adminStore = useAdminStore()
    const permissions = adminStore.permissions || []
    const permission = binding.value
    
    // 检查权限
    if (!hasPermission(permission, permissions)) {
      el.style.display = 'none'
    } else {
      // 恢复显示（如果需要）
      el.style.display = ''
    }
  }
}

