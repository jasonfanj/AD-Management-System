package com.admanagement.entity.vo;

import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 个人信息VO
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Data
public class SelfInfoVO implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * 管理员ID
     */
    private Long id;
    
    /**
     * 账号
     */
    private String username;
    
    /**
     * 真实姓名
     */
    private String realName;
    
    /**
     * 手机号
     */
    private String phone;
    
    /**
     * 邮箱
     */
    private String email;
    
    /**
     * 状态：0-禁用，1-启用
     */
    private Integer status;
    
    /**
     * 状态文本
     */
    private String statusText;
    
    /**
     * 创建时间
     */
    private LocalDateTime createTime;
    
    /**
     * 最后登录时间
     */
    private LocalDateTime lastLoginTime;
}

