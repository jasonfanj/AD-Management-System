/**
 * 路由配置
 */
import { createRouter, createWebHistory } from 'vue-router'
import { useAdminStore } from '@/store/adminStore'

// 导入页面组件
const Login = () => import('@/views/pages/Login.vue')
const NotFound = () => import('@/views/pages/NotFound.vue')

// 动态路由组件
const Dashboard = () => import('@/views/pages/Dashboard.vue')
const AdUserList = () => import('@/views/pages/modules/AdUserList.vue')
const AdOuList = () => import('@/views/pages/modules/AdOuList.vue')
const SelfInfo = () => import('@/views/pages/modules/SelfInfo.vue')
const PasswordReset = () => import('@/views/pages/modules/PasswordReset.vue')
const AuditList = () => import('@/views/pages/modules/AuditList.vue')

// 布局组件
const Layout = () => import('@/components/layout/Layout.vue')

/**
 * 静态路由（无需权限验证）
 */
export const constantRoutes = [
  {
    path: '/login',
    name: 'Login',
    component: Login,
    meta: {
      title: '登录',
      hidden: true // 不在菜单中显示
    }
  },
  {
    path: '/404',
    name: 'NotFound',
    component: NotFound,
    meta: {
      title: '404',
      hidden: true
    }
  },
  {
    path: '/',
    component: Layout,
    name: 'Layout',
    redirect: '/dashboard',
    meta: {
      title: '首页',
      requiresAuth: true // 需要登录
    },
    children: [
      {
        path: 'dashboard',
        name: 'Dashboard',
        component: Dashboard,
        meta: {
          title: '工作台',
          icon: 'Odometer'
        }
      }
    ]
  }
]

/**
 * 动态路由（需要根据角色权限动态加载）
 */
export const asyncRoutes = [
  // AD管理模块
  {
    path: '/ad-manage',
    component: Layout,
    name: 'ADManagerLayout',
    meta: {
      title: 'AD管理',
      icon: 'Document',
      moduleCode: 'ad_manager',
      requiresAuth: true,
      roles: ['super_admin', 'ad_admin'] // 需要的角色
    },
    children: [
      {
        path: 'user',
        name: 'ADUsers',
        component: AdUserList,
        meta: {
          title: 'AD用户管理',
          icon: 'User'
        }
      },
      {
        path: 'ou',
        name: 'ADOUs',
        component: AdOuList,
        meta: {
          title: 'OU管理',
          icon: 'Folder'
        }
      }
    ]
  },
  // 自助服务模块
  {
    path: '/ad-self',
    component: Layout,
    name: 'SelfServiceLayout',
    meta: {
      title: '自助服务',
      icon: 'Service',
      moduleCode: 'self_service',
      requiresAuth: true,
      roles: ['super_admin', 'ad_admin'] // 需要的角色
    },
    children: [
      {
        path: 'info',
        name: 'SelfInfo',
        component: SelfInfo,
        meta: {
          title: '个人信息',
          icon: 'User'
        }
      },
      {
        path: 'password',
        name: 'PasswordReset',
        component: PasswordReset,
        meta: {
          title: '密码重置',
          icon: 'Lock'
        }
      }
    ]
  },
  // 审计管理模块
  {
    path: '/ad-audit',
    component: Layout,
    name: 'AuditLayout',
    meta: {
      title: '审计管理',
      icon: 'Document',
      moduleCode: 'audit',
      requiresAuth: true,
      roles: ['super_admin', 'ad_admin', 'audit_viewer'] // 需要的角色
    },
    children: [
      {
        path: 'log',
        name: 'AuditLog',
        component: AuditList,
        meta: {
          title: '审计日志',
          icon: 'Document'
        }
      }
    ]
  },
  // 404页面必须放在最后
  {
    path: '/:pathMatch(.*)*',
    redirect: '/404',
    hidden: true
  }
]

// 创建路由实例
const router = createRouter({
  history: createWebHistory(),
  routes: constantRoutes,
  scrollBehavior: () => ({ top: 0 })
})

/**
 * 路由守卫
 */
router.beforeEach(async (to, from, next) => {
  const adminStore = useAdminStore()
  const token = adminStore.token
  
  // 设置页面标题
  document.title = to.meta.title ? `${to.meta.title} - AD管理系统` : 'AD管理系统'
  
  // 如果是登录页，有token则跳转到首页
  if (to.path === '/login') {
    if (token) {
      next({ path: '/' })
    } else {
      next()
    }
    return
  }
  
  // 如果没有token，跳转到登录页
  if (!token) {
    next({ path: '/login', query: { redirect: to.fullPath } })
    return
  }
  
  // 有token，判断是否已获取用户权限信息
  if (adminStore.hasGetUserInfo) {
    // 已获取用户信息，检查权限
    if (hasPermission(to, adminStore)) {
      next()
    } else {
      next({ path: '/404' })
    }
  } else {
    // 未获取用户信息，根据角色加载动态路由
    try {
      const roles = adminStore.roles.map(role => role.roleCode)
      
      // 根据角色过滤动态路由
      const accessibleRoutes = filterAsyncRoutes(asyncRoutes, roles)
      
      // 添加动态路由
      accessibleRoutes.forEach(route => {
        router.addRoute(route)
      })
      
      // 加载权限列表
      if (adminStore.permissions.length === 0) {
        await adminStore.loadPermissions()
      }
      
      // 标记已获取用户信息
      adminStore.setHasGetUserInfo(true)
      
      // 重新跳转到目标路由
      next({ ...to, replace: true })
    } catch (error) {
      console.error('加载路由失败:', error)
      adminStore.logout()
      next({ path: '/login' })
    }
  }
})

/**
 * 检查路由权限
 * @param {Object} route 路由对象
 * @param {Object} adminStore 管理员store
 * @returns {boolean}
 */
function hasPermission(route, adminStore) {
  const roles = route.meta?.roles
  
  // 如果没有设置roles，说明不需要权限验证
  if (!roles || roles.length === 0) {
    return true
  }
  
  // 检查用户是否有权限
  const userRoles = adminStore.roleCodes
  return roles.some(role => userRoles.includes(role))
}

/**
 * 根据角色过滤动态路由
 * @param {Array} routes 路由列表
 * @param {Array} roles 角色列表
 * @returns {Array}
 */
function filterAsyncRoutes(routes, roles) {
  const res = []
  
  routes.forEach(route => {
    const tmp = { ...route }
    
    // 检查路由权限
    if (hasRoutePermission(tmp, roles)) {
      // 如果有子路由，递归过滤
      if (tmp.children) {
        tmp.children = filterAsyncRoutes(tmp.children, roles)
      }
      res.push(tmp)
    }
  })
  
  return res
}

/**
 * 检查路由是否有权限
 * @param {Object} route 路由对象
 * @param {Array} roles 角色列表
 * @returns {boolean}
 */
function hasRoutePermission(route, roles) {
  const routeRoles = route.meta?.roles
  
  // 如果没有设置roles，说明不需要权限验证
  if (!routeRoles || routeRoles.length === 0) {
    return true
  }
  
  // 检查用户是否有权限
  return routeRoles.some(role => roles.includes(role))
}

export default router
