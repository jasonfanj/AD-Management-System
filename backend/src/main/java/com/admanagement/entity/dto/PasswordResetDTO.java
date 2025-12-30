package com.admanagement.entity.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

/**
 * 密码重置DTO
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Data
public class PasswordResetDTO {
    
    /**
     * 原密码
     */
    @NotBlank(message = "原密码不能为空")
    private String oldPassword;
    
    /**
     * 新密码
     */
    @NotBlank(message = "新密码不能为空")
    @Size(min = 8, max = 128, message = "密码长度必须在8-128位之间")
    private String newPassword;
    
    /**
     * 确认密码
     */
    @NotBlank(message = "确认密码不能为空")
    private String confirmPassword;
}

