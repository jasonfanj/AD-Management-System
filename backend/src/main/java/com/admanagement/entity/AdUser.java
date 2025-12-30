package com.admanagement.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * AD用户实体类
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Data
@TableName("ad_user")
public class AdUser {
    
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
     * 用户主体名称（User Principal Name）
     */
    private String userPrincipalName;
    
    /**
     * 显示名称
     */
    private String displayName;
    
    /**
     * 邮箱
     */
    private String email;
    
    /**
     * 部门
     */
    private String department;
    
    /**
     * 职位
     */
    private String title;
    
    /**
     * 上级（Manager DN）
     */
    private String manager;
    
    /**
     * 电话
     */
    private String telephoneNumber;
    
    /**
     * 手机
     */
    private String mobile;
    
    /**
     * 账户状态：0-禁用，1-启用
     */
    private Integer accountStatus;
    
    /**
     * 最后登录时间
     */
    private LocalDateTime lastLogon;
    
    /**
     * 密码最后设置时间
     */
    private LocalDateTime passwordLastSet;
    
    /**
     * 密码过期时间
     */
    private LocalDateTime passwordExpires;
    
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

