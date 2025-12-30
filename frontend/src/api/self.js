/**
 * 自助服务相关API接口
 */
import request from '@/utils/request'

/**
 * 查询个人信息
 * @returns {Promise}
 */
export function getSelfInfo() {
  return request({
    url: '/ad-self/info',
    method: 'get'
  })
}

/**
 * 更新个人信息
 * @param {Object} data 个人信息
 * @returns {Promise}
 */
export function updateSelfInfo(data) {
  return request({
    url: '/ad-self/info',
    method: 'put',
    data
  })
}

/**
 * 密码重置预览（校验密码格式）
 * @param {Object} data 密码重置信息
 * @returns {Promise}
 */
export function previewPasswordReset(data) {
  return request({
    url: '/ad-self/password/preview',
    method: 'post',
    data
  })
}

/**
 * 执行密码重置
 * @param {Object} data 密码重置信息
 * @returns {Promise}
 */
export function resetPassword(data) {
  return request({
    url: '/ad-self/password/reset',
    method: 'post',
    data
  })
}

