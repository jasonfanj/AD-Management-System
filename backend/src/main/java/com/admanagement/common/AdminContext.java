package com.admanagement.common;

import lombok.Data;
import java.util.List;

/**
 * 管理员上下文（ThreadLocal存储当前请求的管理员信息）
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
public class AdminContext {
    
    private static final ThreadLocal<AdminInfo> ADMIN_INFO = new ThreadLocal<>();
    
    /**
     * 设置当前管理员信息
     */
    public static void setAdminInfo(AdminInfo adminInfo) {
        ADMIN_INFO.set(adminInfo);
    }
    
    /**
     * 设置当前管理员信息（简化方法）
     */
    public static void setAdminInfo(Long adminId, String username) {
        AdminInfo adminInfo = new AdminInfo();
        adminInfo.setAdminId(adminId);
        adminInfo.setUsername(username);
        ADMIN_INFO.set(adminInfo);
    }
    
    /**
     * 获取当前管理员信息
     */
    public static AdminInfo getAdminInfo() {
        return ADMIN_INFO.get();
    }
    
    /**
     * 获取当前管理员ID
     */
    public static Long getAdminId() {
        AdminInfo adminInfo = ADMIN_INFO.get();
        return adminInfo != null ? adminInfo.getAdminId() : null;
    }
    
    /**
     * 获取当前管理员ID（兼容方法）
     */
    public static Long getCurrentAdminId() {
        return getAdminId();
    }
    
    /**
     * 获取当前管理员账号
     */
    public static String getUsername() {
        AdminInfo adminInfo = ADMIN_INFO.get();
        return adminInfo != null ? adminInfo.getUsername() : null;
    }
    
    /**
     * 获取当前管理员账号（兼容方法）
     */
    public static String getCurrentAdminUsername() {
        return getUsername();
    }
    
    /**
     * 清除当前管理员信息
     */
    public static void clear() {
        ADMIN_INFO.remove();
    }
    
    /**
     * 管理员信息
     */
    @Data
    public static class AdminInfo {
        /**
         * 管理员ID
         */
        private Long adminId;
        
        /**
         * 管理员账号
         */
        private String username;
        
        /**
         * 角色ID列表
         */
        private List<Long> roleIds;
        
        /**
         * 角色编码列表
         */
        private List<String> roleCodes;
    }
}
