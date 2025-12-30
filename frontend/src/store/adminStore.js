/**
 * 管理员状态管理（Pinia Store）
 */
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { login as loginApi, logout as logoutApi } from '@/api/admin'
import { getPermissionCodes, getButtonPermissionCodes } from '@/api/permission'

export const useAdminStore = defineStore('admin', () => {
  // ========== 状态定义 ==========
  
  // Token
  const token = ref(localStorage.getItem('token') || '')
  
  // 管理员基本信息
  const adminInfo = ref(
    localStorage.getItem('adminInfo') 
      ? JSON.parse(localStorage.getItem('adminInfo')) 
      : null
  )
  
  // 角色列表
  const roles = ref(
    localStorage.getItem('roles') 
      ? JSON.parse(localStorage.getItem('roles')) 
      : []
  )
  
  // 权限列表（可选，后续扩展使用）
  const permissions = ref(
    localStorage.getItem('permissions') 
      ? JSON.parse(localStorage.getItem('permissions')) 
      : []
  )
  
  // 是否已获取用户权限（用于路由守卫）
  const hasGetUserInfo = ref(false)
  
  // 当前模块信息
  const currentModule = ref(
    localStorage.getItem('currentModule') 
      ? JSON.parse(localStorage.getItem('currentModule')) 
      : null
  )
  
  // 模块列表
  const modules = ref(
    localStorage.getItem('modules') 
      ? JSON.parse(localStorage.getItem('modules')) 
      : []
  )
  
  // ========== 计算属性 ==========
  
  // 是否已登录
  const isLoggedIn = computed(() => !!token.value)
  
  // 管理员ID
  const adminId = computed(() => adminInfo.value?.id || null)
  
  // 管理员账号
  const username = computed(() => adminInfo.value?.username || '')
  
  // 角色编码列表
  const roleCodes = computed(() => roles.value.map(role => role.roleCode) || [])
  
  // ========== 方法定义 ==========
  
  /**
   * 登录
   * @param {Object} loginData 登录信息
   * @param {string} loginData.username 账号
   * @param {string} loginData.password 密码
   * @returns {Promise}
   */
  const login = async (loginData) => {
    try {
      const response = await loginApi(loginData)
      const { token: newToken, adminInfo: newAdminInfo, roles: newRoles } = response.data
      
      // 更新状态
      token.value = newToken
      adminInfo.value = newAdminInfo
      roles.value = newRoles
      hasGetUserInfo.value = true
      
      // 持久化到localStorage
      localStorage.setItem('token', newToken)
      localStorage.setItem('adminInfo', JSON.stringify(newAdminInfo))
      localStorage.setItem('roles', JSON.stringify(newRoles))
      
      // 加载权限列表
      await loadPermissions()
      
      return response
    } catch (error) {
      console.error('登录失败:', error)
      throw error
    }
  }
  
  /**
   * 登出
   */
  const logout = async () => {
    try {
      // 调用后端登出接口
      if (token.value) {
        await logoutApi()
      }
    } catch (error) {
      console.error('登出失败:', error)
    } finally {
      // 清除状态和localStorage
      token.value = ''
      adminInfo.value = null
      roles.value = []
      permissions.value = []
      hasGetUserInfo.value = false
      
      localStorage.removeItem('token')
      localStorage.removeItem('adminInfo')
      localStorage.removeItem('roles')
      localStorage.removeItem('permissions')
      localStorage.removeItem('currentModule')
      localStorage.removeItem('modules')
      localStorage.removeItem('currentModule')
      localStorage.removeItem('modules')
    }
  }
  
  /**
   * 更新管理员信息
   * @param {Object} info 管理员信息
   */
  const setAdminInfo = (info) => {
    adminInfo.value = info
    localStorage.setItem('adminInfo', JSON.stringify(info))
  }
  
  /**
   * 更新Token
   * @param {string} newToken 新的Token
   */
  const setToken = (newToken) => {
    token.value = newToken
    localStorage.setItem('token', newToken)
  }
  
  /**
   * 更新角色列表
   * @param {Array} newRoles 新的角色列表
   */
  const setRoles = (newRoles) => {
    roles.value = newRoles
    localStorage.setItem('roles', JSON.stringify(newRoles))
  }
  
  /**
   * 更新权限列表
   * @param {Array} newPermissions 新的权限列表
   */
  const setPermissions = (newPermissions) => {
    permissions.value = newPermissions
    localStorage.setItem('permissions', JSON.stringify(newPermissions))
  }
  
  /**
   * 清空所有信息（用于重置状态）
   */
  const clearAll = () => {
    token.value = ''
    adminInfo.value = null
    roles.value = []
    permissions.value = []
    hasGetUserInfo.value = false
    
    localStorage.removeItem('token')
    localStorage.removeItem('adminInfo')
    localStorage.removeItem('roles')
    localStorage.removeItem('permissions')
  }
  
  /**
   * 设置已获取用户信息标识
   * @param {boolean} value
   */
  const setHasGetUserInfo = (value) => {
    hasGetUserInfo.value = value
  }
  
  /**
   * 检查是否有指定角色
   * @param {string} roleCode 角色编码
   * @returns {boolean}
   */
  const hasRole = (roleCode) => {
    return roleCodes.value.includes(roleCode)
  }
  
  /**
   * 检查是否有指定权限
   * @param {string} permission 权限编码
   * @returns {boolean}
   */
  const hasPermission = (permission) => {
    return permissions.value.includes(permission)
  }
  
  /**
   * 设置当前模块
   * @param {Object} module 模块信息
   */
  const setCurrentModule = (module) => {
    currentModule.value = module
    if (module) {
      localStorage.setItem('currentModule', JSON.stringify(module))
    } else {
      localStorage.removeItem('currentModule')
    }
  }
  
  /**
   * 设置模块列表
   * @param {Array} moduleList 模块列表
   */
  const setModules = (moduleList) => {
    modules.value = moduleList
    if (moduleList && moduleList.length > 0) {
      localStorage.setItem('modules', JSON.stringify(moduleList))
    } else {
      localStorage.removeItem('modules')
    }
  }
  
  return {
    // 状态
    token,
    adminInfo,
    roles,
    permissions,
    hasGetUserInfo,
    currentModule,
    modules,
    
    // 计算属性
    isLoggedIn,
    adminId,
    username,
    roleCodes,
    
    // 方法
    login,
    logout,
    setAdminInfo,
    setToken,
    setRoles,
    setPermissions,
    clearAll,
    setHasGetUserInfo,
    hasRole,
    hasPermission,
    setCurrentModule,
    setModules,
    loadPermissions
  }
})
