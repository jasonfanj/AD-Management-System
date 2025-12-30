package com.admanagement.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * AD组实体类
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Data
@TableName("ad_group")
public class AdGroup {
    
    /**
     * 主键ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;
    
    /**
     * 域控制器ID
     */
    private Long domainControllerId;
    
    /**
     * DN（Distinguished Name）
     */
    private String dn;
    
    /**
     * SAM账户名
     */
    private String samAccountName;
    
    /**
     * 显示名称
     */
    private String displayName;
    
    /**
     * 描述
     */
    private String description;
    
    /**
     * 组类型
     */
    private Integer groupType;
    
    /**
     * 成员数量
     */
    private Integer memberCount;
    
    /**
     * 同步时间
     */
    private LocalDateTime syncTime;
    
    /**
     * 创建时间
     */
    private LocalDateTime createTime;
    
    /**
     * 更新时间
     */
    private LocalDateTime updateTime;
}

