/**
 * 管理员相关API接口
 */
import request from '@/utils/request'

/**
 * 登录接口
 * @param {Object} data 登录信息
 * @param {string} data.username 账号
 * @param {string} data.password 密码
 * @returns {Promise}
 */
export function login(data) {
  return request({
    url: '/admin/login',
    method: 'post',
    data
  })
}

/**
 * 登出接口
 * @returns {Promise}
 */
export function logout() {
  return request({
    url: '/admin/logout',
    method: 'post'
  })
}

/**
 * 获取当前管理员信息
 * @returns {Promise}
 */
export function getAdminInfo() {
  return request({
    url: '/admin/info',
    method: 'get'
  })
}

