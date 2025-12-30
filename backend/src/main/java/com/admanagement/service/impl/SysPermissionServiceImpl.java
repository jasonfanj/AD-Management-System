package com.admanagement.service.impl;

import com.admanagement.entity.SysModule;
import com.admanagement.entity.SysPermission;
import com.admanagement.repository.SysModuleMapper;
import com.admanagement.repository.SysPermissionMapper;
import com.admanagement.service.SysPermissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 权限服务实现类
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Service
public class SysPermissionServiceImpl implements SysPermissionService {
    
    @Autowired
    private SysPermissionMapper sysPermissionMapper;
    
    @Autowired
    private SysModuleMapper sysModuleMapper;
    
    @Override
    public List<String> getPermissionCodesByAdminId(Long adminId) {
        return sysPermissionMapper.selectPermissionCodesByAdminId(adminId);
    }
    
    @Override
    public boolean hasModulePermission(Long adminId, String moduleCode) {
        // 1. 根据模块标识查询模块信息
        SysModule module = sysModuleMapper.selectByModuleCode(moduleCode);
        if (module == null) {
            // 模块不存在或已禁用
            return false;
        }
        
        // 2. 根据管理员ID和模块ID查询权限
        List<String> permissionCodes = sysPermissionMapper.selectPermissionCodesByAdminIdAndModuleId(
            adminId, 
            module.getId()
        );
        
        // 3. 如果查询到权限，说明有该模块的访问权限
        return permissionCodes != null && !permissionCodes.isEmpty();
    }
    
    @Override
    public List<String> getButtonPermissionCodesByAdminId(Long adminId) {
        return sysPermissionMapper.selectButtonPermissionCodesByAdminId(adminId);
    }
}
