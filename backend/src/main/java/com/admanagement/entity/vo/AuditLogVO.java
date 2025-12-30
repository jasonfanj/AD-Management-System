package com.admanagement.entity.vo;

import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 审计日志VO
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Data
public class AuditLogVO implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * 审计ID
     */
    private Long id;
    
    /**
     * 操作人账号
     */
    private String operatorUsername;
    
    /**
     * 操作人姓名
     */
    private String operatorName;
    
    /**
     * 操作模块
     */
    private String operationModule;
    
    /**
     * 操作模块文本
     */
    private String operationModuleText;
    
    /**
     * 操作类型
     */
    private String operationType;
    
    /**
     * 操作类型文本
     */
    private String operationTypeText;
    
    /**
     * 操作内容
     */
    private String operationContent;
    
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
     * 操作结果文本
     */
    private String operationResultText;
    
    /**
     * 错误信息
     */
    private String errorMessage;
    
    /**
     * 请求URL
     */
    private String requestUrl;
    
    /**
     * 请求方法
     */
    private String requestMethod;
    
    /**
     * 执行时间（毫秒）
     */
    private Long executionTime;
}

