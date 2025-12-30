/**
 * 审计管理相关API接口
 */
import request from '@/utils/request'

/**
 * 分页查询审计日志列表
 * @param {Object} params 查询参数
 * @returns {Promise}
 */
export function getAuditLogList(params) {
  return request({
    url: '/ad-audit/logs/list',
    method: 'get',
    params
  })
}

/**
 * 插入模拟审计数据（用于测试）
 * @returns {Promise}
 */
export function insertMockData() {
  return request({
    url: '/ad-audit/logs/mock-data',
    method: 'post'
  })
}

