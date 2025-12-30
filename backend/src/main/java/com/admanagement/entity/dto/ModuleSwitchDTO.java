package com.admanagement.entity.dto;

import lombok.Data;

import jakarta.validation.constraints.NotBlank;

/**
 * 模块切换DTO
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Data
public class ModuleSwitchDTO {
    
    /**
     * 目标模块标识
     */
    @NotBlank(message = "模块标识不能为空")
    private String moduleCode;
}

