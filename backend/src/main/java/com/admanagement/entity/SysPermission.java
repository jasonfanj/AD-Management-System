package com.admanagement.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 权限实体类
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Data
@TableName("sys_permission")
public class SysPermission {
    
    /**
     * 主键ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;
    
    /**
     * 权限名称
     */
    private String permissionName;
    
    /**
     * 权限标识
     */
    private String permissionCode;
    
    /**
     * 所属模块ID
     */
    private Long moduleId;
    
    /**
     * 权限类型：1-模块，2-按钮/菜单，3-接口/API
     */
    private Integer permissionType;
    
    /**
     * 父权限ID
     */
    private Long parentId;
    
    /**
     * API路径
     */
    private String apiPath;
    
    /**
     * HTTP方法
     */
    private String httpMethod;
    
    /**
     * 排序号
     */
    private Integer sortOrder;
    
    /**
     * 状态：0-禁用，1-启用
     */
    private Integer status;
    
    /**
     * 权限描述
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

