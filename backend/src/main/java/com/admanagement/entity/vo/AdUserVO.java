package com.admanagement.entity.vo;

import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * AD用户VO
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Data
public class AdUserVO implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * 主键ID
     */
    private Long id;
    
    /**
     * SAM账户名
     */
    private String samAccountName;
    
    /**
     * 用户主体名称
     */
    private String userPrincipalName;
    
    /**
     * 显示名称
     */
    private String displayName;
    
    /**
     * 邮箱
     */
    private String email;
    
    /**
     * 部门
     */
    private String department;
    
    /**
     * 职位
     */
    private String title;
    
    /**
     * 电话
     */
    private String telephoneNumber;
    
    /**
     * 手机
     */
    private String mobile;
    
    /**
     * 账户状态：0-禁用，1-启用
     */
    private Integer accountStatus;
    
    /**
     * 账户状态文本
     */
    private String accountStatusText;
    
    /**
     * 最后登录时间
     */
    private LocalDateTime lastLogon;
    
    /**
     * 密码过期时间
     */
    private LocalDateTime passwordExpires;
}

