package com.admanagement.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 模块实体类
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Data
@TableName("sys_module")
public class SysModule {
    
    /**
     * 主键ID
     */
    @TableId(type = IdType.AUTO)
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
     * 父模块ID
     */
    private Long parentId;
    
    /**
     * 模块路径
     */
    private String modulePath;
    
    /**
     * 模块图标
     */
    private String icon;
    
    /**
     * 排序号
     */
    private Integer sortOrder;
    
    /**
     * 状态：0-禁用，1-启用
     */
    private Integer status;
    
    /**
     * 模块描述
     */
    private String description;
    
    /**
     * 创建时间
     */
    private LocalDateTime createTime;
    
    /**
     * 更新时间
     */
    private LocalDateTime updateTime;
}

