package com.admanagement.entity.vo;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * OU（组织单元）VO
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Data
public class AdOuVO implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * OU的DN
     */
    private String dn;
    
    /**
     * OU名称
     */
    private String name;
    
    /**
     * OU描述
     */
    private String description;
    
    /**
     * OU路径
     */
    private String path;
    
    /**
     * 子OU列表
     */
    private List<AdOuVO> children;
    
    /**
     * 用户数量
     */
    private Integer userCount;
    
    /**
     * 组数量
     */
    private Integer groupCount;
}

