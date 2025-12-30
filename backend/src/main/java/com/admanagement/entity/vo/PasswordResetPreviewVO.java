package com.admanagement.entity.vo;

import lombok.Data;

import java.io.Serializable;

/**
 * 密码重置预览VO
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Data
public class PasswordResetPreviewVO implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * 是否通过校验
     */
    private Boolean valid;
    
    /**
     * 校验结果消息
     */
    private String message;
    
    /**
     * 密码复杂度提示
     */
    private String complexityHint;
}

