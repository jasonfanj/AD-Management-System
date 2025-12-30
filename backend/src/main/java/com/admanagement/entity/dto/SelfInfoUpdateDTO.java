package com.admanagement.entity.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

/**
 * 个人信息更新DTO
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Data
public class SelfInfoUpdateDTO {
    
    /**
     * 真实姓名
     */
    private String realName;
    
    /**
     * 手机号
     */
    @Pattern(regexp = "^1[3-9]\\d{9}$", message = "手机号格式不正确")
    private String phone;
    
    /**
     * 邮箱
     */
    @Email(message = "邮箱格式不正确")
    private String email;
}

