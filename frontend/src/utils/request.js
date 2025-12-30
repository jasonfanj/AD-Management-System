/**
 * Axios请求封装
 */
import axios from 'axios'
import { ElMessage } from 'element-plus'
import router from '@/router'
import { useAdminStore } from '@/store/adminStore'

// 创建axios实例
const service = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || '/api',
  timeout: 30000, // 请求超时时间
  headers: {
    'Content-Type': 'application/json;charset=UTF-8'
  }
})

// 请求拦截器
service.interceptors.request.use(
  config => {
    // 从Pinia store获取token
    const adminStore = useAdminStore()
    const token = adminStore.token
    
    // 如果token存在，将其添加到请求头
    if (token) {
      config.headers['Authorization'] = `Bearer ${token}`
    }
    
    return config
  },
  error => {
    console.error('请求错误:', error)
    return Promise.reject(error)
  }
)

// 响应拦截器
service.interceptors.response.use(
  response => {
    const res = response.data
    
    // 如果后端返回的code不是200，也当作错误处理
    if (res.code && res.code !== 200) {
      handleErrorResponse(res.code, res.message)
      return Promise.reject(new Error(res.message || '操作失败'))
    }
    
    // 如果响应状态码为200，直接返回数据
    return res
  },
  error => {
    console.error('响应错误:', error)
    
    // 处理HTTP错误状态码
    if (error.response) {
      const { status, data } = error.response
      handleHttpError(status, data?.message || error.message)
    } else {
      // 网络错误或其他错误
      ElMessage.error('网络错误，请检查网络连接')
    }
    
    return Promise.reject(error)
  }
)

/**
 * 处理业务错误响应（code不为200的情况）
 */
function handleErrorResponse(code, message) {
  switch (code) {
    case 401:
      // 未登录或登录已过期
      ElMessage.warning(message || '未登录或登录已过期，请重新登录')
      handleLogout()
      break
    case 403:
      // 无权限
      ElMessage.error(message || '无权限访问')
      break
    case 400:
      // 参数错误
      ElMessage.warning(message || '参数错误')
      break
    case 500:
      // 服务器错误
      ElMessage.error(message || '服务器错误，请联系管理员')
      break
    default:
      ElMessage.error(message || '操作失败')
  }
}

/**
 * 处理HTTP错误响应
 */
function handleHttpError(status, message) {
  switch (status) {
    case 401:
      // 未授权
      ElMessage.warning(message || '未登录或登录已过期，请重新登录')
      handleLogout()
      break
    case 403:
      // 禁止访问
      ElMessage.error(message || '无权限访问')
      break
    case 404:
      // 资源不存在
      ElMessage.error(message || '请求的资源不存在')
      break
    case 500:
      // 服务器内部错误
      ElMessage.error(message || '服务器错误，请联系管理员')
      break
    case 502:
    case 503:
    case 504:
      // 网关错误、服务不可用、网关超时
      ElMessage.error('服务暂时不可用，请稍后重试')
      break
    default:
      ElMessage.error(message || '请求失败')
  }
}

/**
 * 处理登出操作
 */
function handleLogout() {
  if (typeof window !== 'undefined') {
    // 动态导入store，避免循环依赖
    import('@/store/adminStore').then(({ useAdminStore }) => {
      const adminStore = useAdminStore()
      adminStore.logout().then(() => {
        router.push('/login')
      }).catch(() => {
        router.push('/login')
      })
    }).catch(() => {
      // 如果导入失败，直接跳转
      window.location.href = '/login'
    })
  }
}

export default service
