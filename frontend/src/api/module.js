/**
 * 模块相关API接口
 */
import request from '@/utils/request'

/**
 * 查询当前用户有权限访问的模块列表
 * @returns {Promise}
 */
export function getModules() {
  return request({
    url: '/module/list',
    method: 'get'
  })
}

/**
 * 模块切换接口
 * @param {Object} data 模块切换信息
 * @param {string} data.moduleCode 模块标识
 * @returns {Promise}
 */
export function switchModule(data) {
  return request({
    url: '/module/switch',
    method: 'post',
    data
  })
}

