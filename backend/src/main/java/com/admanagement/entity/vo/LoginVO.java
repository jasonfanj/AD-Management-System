package com.admanagement.entity.vo;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * 登录响应VO
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Data
public class LoginVO implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * JWT Token
     */
    private String token;
    
    /**
     * 管理员基本信息
     */
    private AdminInfo adminInfo;
    
    /**
     * 角色列表
     */
    private List<RoleInfo> roles;
    
    /**
     * 管理员基本信息
     */
    @Data
    public static class AdminInfo implements Serializable {
        private static final long serialVersionUID = 1L;
        
        /**
         * 管理员ID
         */
        private Long id;
        
        /**
         * 账号
         */
        private String username;
        
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
         * 头像
         */
        private String avatar;
    }
    
    /**
     * 角色信息
     */
    @Data
    public static class RoleInfo implements Serializable {
        private static final long serialVersionUID = 1L;
        
        /**
         * 角色ID
         */
        private Long id;
        
        /**
         * 角色编码
         */
        private String roleCode;
        
        /**
         * 角色名称
         */
        private String roleName;
    }
}

