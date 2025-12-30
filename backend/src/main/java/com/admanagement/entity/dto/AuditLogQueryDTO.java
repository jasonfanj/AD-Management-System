package com.admanagement.entity.dto;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 审计日志查询DTO
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Data
public class AuditLogQueryDTO {
    
    /**
     * 操作人账号
     */
    private String operatorUsername;
    
    /**
     * 操作模块（如：ad_manager, self_service, audit）
     */
    private String operationModule;
    
    /**
     * 操作类型（如：CREATE, UPDATE, DELETE, QUERY）
     */
    private String operationType;
    
    /**
     * 操作结果：0-失败，1-成功
     */
    private Integer operationResult;
    
    /**
     * 开始时间
     */
    private LocalDateTime startTime;
    
    /**
     * 结束时间
     */
    private LocalDateTime endTime;
    
    /**
     * 当前页码（从1开始）
     */
    private Integer pageNum = 1;
    
    /**
     * 每页数量
     */
    private Integer pageSize = 10;
    
    /**
     * 获取偏移量（计算属性，不存储）
     */
    public Integer getOffset() {
        if (pageNum != null && pageSize != null) {
            return (pageNum - 1) * pageSize;
        }
        return 0;
    }
}

