package com.admanagement.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 管理员用户实体类
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Data
@TableName("sys_admin")
public class SysAdmin {
    
    /**
     * 主键ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;
    
    /**
     * 管理员账号（唯一）
     */
    private String username;
    
    /**
     * 密码（BCrypt加密存储）
     */
    private String password;
    
    /**
     * 真实姓名
     */
    private String realName;
    
    /**
     * 手机号
     */
    private String phone;
    
    /**
     * 邮箱
     */
    private String email;
    
    /**
     * 头像URL
     */
    private String avatar;
    
    /**
     * 状态：0-禁用，1-启用
     */
    private Integer status;
    
    /**
     * 最后登录时间
     */
    private LocalDateTime lastLoginTime;
    
    /**
     * 最后登录IP
     */
    private String lastLoginIp;
    
    /**
     * 登录失败次数
     */
    private Integer loginFailCount;
    
    /**
     * 账户锁定时间
     */
    private LocalDateTime lockTime;
    
    /**
     * 创建时间
     */
    private LocalDateTime createTime;
    
    /**
     * 更新时间
     */
    private LocalDateTime updateTime;
    
    /**
     * 创建人ID
     */
    private Long createBy;
    
    /**
     * 更新人ID
     */
    private Long updateBy;
    
    /**
     * 备注
     */
    private String remark;
}

