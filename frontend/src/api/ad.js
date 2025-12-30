/**
 * AD管理相关API接口
 */
import request from '@/utils/request'

/**
 * 分页查询AD用户列表
 * @param {Object} params 查询参数
 * @returns {Promise}
 */
export function getAdUserList(params) {
  return request({
    url: '/ad-manage/users/list',
    method: 'get',
    params
  })
}

/**
 * 批量导入预览
 * @param {Array} users 用户数据
 * @returns {Promise}
 */
export function previewBatchImport(users) {
  return request({
    url: '/ad-manage/users/preview-import',
    method: 'post',
    data: users
  })
}

/**
 * 查询OU列表
 * @returns {Promise}
 */
export function getOuList() {
  return request({
    url: '/ad-manage/ous/list',
    method: 'get'
  })
}

/**
 * 根据DN查询OU信息
 * @param {string} dn OU的DN
 * @returns {Promise}
 */
export function getOuByDn(dn) {
  return request({
    url: `/ad-manage/ous/${encodeURIComponent(dn)}`,
    method: 'get'
  })
}
