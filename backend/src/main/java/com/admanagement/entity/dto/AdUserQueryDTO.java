package com.admanagement.entity.dto;

import lombok.Data;

/**
 * AD用户查询DTO
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Data
public class AdUserQueryDTO {
    
    /**
     * 搜索关键词（搜索姓名、账号、邮箱等）
     */
    private String keyword;
    
    /**
     * 域控制器ID
     */
    private Long domainControllerId;
    
    /**
     * 账户状态：0-禁用，1-启用
     */
    private Integer accountStatus;
    
    /**
     * 部门
     */
    private String department;
    
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
