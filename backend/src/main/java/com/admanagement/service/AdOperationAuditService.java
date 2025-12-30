package com.admanagement.service;

import com.admanagement.common.PageResult;
import com.admanagement.entity.AdOperationAudit;
import com.admanagement.entity.dto.AuditLogQueryDTO;
import com.admanagement.entity.vo.AuditLogVO;

/**
 * AD操作审计服务接口
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
public interface AdOperationAuditService {
    
    /**
     * 插入审计日志
     * 
     * @param auditLog 审计日志实体
     */
    void insertAuditLog(AdOperationAudit auditLog);
    
    /**
     * 分页查询审计日志列表
     * 
     * @param queryDTO 查询条件
     * @return 分页结果
     */
    PageResult<AuditLogVO> getAuditLogList(AuditLogQueryDTO queryDTO);
    
    /**
     * 模拟插入AD操作审计数据（用于测试）
     */
    void insertMockAuditData();
}