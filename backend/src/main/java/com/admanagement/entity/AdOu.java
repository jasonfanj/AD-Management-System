package com.admanagement.entity;

import lombok.Data;

/**
 * OU（组织单元）实体类
 * 注意：OU通常存储在AD中，这里作为数据传输对象使用
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Data
public class AdOu {
    
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
     * 父OU的DN
     */
    private String parentDn;
    
    /**
     * OU路径（从根到当前OU的路径）
     */
    private String path;
    
    /**
     * 子OU列表
     */
    private java.util.List<AdOu> children;
    
    /**
     * 用户数量
     */
    private Integer userCount;
    
    /**
     * 组数量
     */
    private Integer groupCount;
}

