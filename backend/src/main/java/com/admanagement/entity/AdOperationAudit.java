package com.admanagement.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * AD操作审计实体类
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Data
@TableName("ad_operation_audit")
public class AdOperationAudit {
    
    /**
     * 审计ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;
    
    /**
     * 操作人ID（关联sys_admin.id）
     */
    private Long operatorId;
    
    /**
     * 操作人账号
     */
    private String operatorUsername;
    
    /**
     * 操作人姓名
     */
    private String operatorName;
    
    /**
     * 操作模块（如：ad_manager, self_service, audit）
     */
    private String operationModule;
    
    /**
     * 操作类型（如：CREATE, UPDATE, DELETE, QUERY, LOGIN, LOGOUT）
     */
    private String operationType;
    
    /**
     * 操作内容（简要描述）
     */
    private String operationContent;
    
    /**
     * 操作详情（JSON格式，存储详细操作信息）
     */
    private String operationDetail;
    
    /**
     * 操作IP地址
     */
    private String operationIp;
    
    /**
     * 操作时间
     */
    private LocalDateTime operationTime;
    
    /**
     * 操作结果：0-失败，1-成功
     */
    private Integer operationResult;
    
    /**
     * 错误信息（操作失败时记录）
     */
    private String errorMessage;
    
    /**
     * 请求URL
     */
    private String requestUrl;
    
    /**
     * 请求方法（GET, POST, PUT, DELETE）
     */
    private String requestMethod;
    
    /**
     * 执行时间（毫秒）
     */
    private Long executionTime;
    
    /**
     * 创建时间
     */
    private LocalDateTime createTime;
}

