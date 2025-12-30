package com.admanagement.service;

import java.util.List;

/**
 * 权限服务接口
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
public interface SysPermissionService {
    
    /**
     * 根据管理员ID查询所有权限标识列表
     * 
     * @param adminId 管理员ID
     * @return 权限标识列表
     */
    List<String> getPermissionCodesByAdminId(Long adminId);
    
    /**
     * 根据管理员ID查询按钮权限标识列表
     * 
     * @param adminId 管理员ID
     * @return 按钮权限标识列表
     */
    List<String> getButtonPermissionCodesByAdminId(Long adminId);
    
    /**
     * 检查管理员是否有指定模块的权限
     * 
     * @param adminId 管理员ID
     * @param moduleCode 模块标识
     * @return 是否有权限
     */
    boolean hasModulePermission(Long adminId, String moduleCode);
}
