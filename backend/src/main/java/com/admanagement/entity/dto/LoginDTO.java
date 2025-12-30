package com.admanagement.entity.dto;

import lombok.Data;

import jakarta.validation.constraints.NotBlank;

/**
 * 登录请求DTO
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Data
public class LoginDTO {
    
    /**
     * 管理员账号
     */
    @NotBlank(message = "账号不能为空")
    private String username;
    
    /**
     * 密码（明文）
     */
    @NotBlank(message = "密码不能为空")
    private String password;
}

