package com.admanagement.repository;

import com.admanagement.entity.AdOperationAudit;
import com.admanagement.entity.dto.AuditLogQueryDTO;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * AD操作审计Mapper接口
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Mapper
public interface AdOperationAuditMapper extends BaseMapper<AdOperationAudit> {
    
    /**
     * 分页查询审计日志列表
     * 
     * @param queryDTO 查询条件
     * @return 审计日志列表
     */
    List<AdOperationAudit> selectAuditLogList(@Param("query") AuditLogQueryDTO queryDTO);
    
    /**
     * 统计审计日志数量
     * 
     * @param queryDTO 查询条件
     * @return 数量
     */
    Long countAuditLogList(@Param("query") AuditLogQueryDTO queryDTO);
}

