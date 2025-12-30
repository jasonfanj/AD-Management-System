package com.admanagement.entity.vo;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * 模块信息VO
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Data
public class ModuleInfoVO implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * 模块ID
     */
    private Long id;
    
    /**
     * 模块名称
     */
    private String moduleName;
    
    /**
     * 模块标识
     */
    private String moduleCode;
    
    /**
     * 模块路径
     */
    private String modulePath;
    
    /**
     * 模块图标
     */
    private String icon;
    
    /**
     * 模块描述
     */
    private String description;
    
    /**
     * 子模块列表
     */
    private List<ModuleInfoVO> children;
}

