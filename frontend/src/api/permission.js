/**
 * 权限相关API接口
 */
import request from '@/utils/request'

/**
 * 查询当前用户的所有权限标识列表
 * @returns {Promise}
 */
export function getPermissionCodes() {
  return request({
    url: '/permission/codes',
    method: 'get'
  })
}

/**
 * 查询当前用户的按钮权限标识列表
 * @returns {Promise}
 */
export function getButtonPermissionCodes() {
  return request({
    url: '/permission/button-codes',
    method: 'get'
  })
}

