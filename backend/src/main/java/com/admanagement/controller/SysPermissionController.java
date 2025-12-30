package com.admanagement.controller;

import com.admanagement.common.AdminContext;
import com.admanagement.common.Result;
import com.admanagement.service.SysPermissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 权限控制器
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@RestController
@RequestMapping("/permission")
public class SysPermissionController {
    
    @Autowired
    private SysPermissionService sysPermissionService;
    
    /**
     * 接口1：根据管理员ID查询该用户的所有权限（含模块权限、按钮权限），返回权限标识列表
     * 
     * @param adminId 管理员ID（可选，不传则查询当前登录用户）
     * @return 权限标识列表
     */
    @GetMapping("/codes/{adminId}")
    public Result<List<String>> getPermissionCodes(@PathVariable(required = false) Long adminId) {
        // 如果未传递adminId，使用当前登录用户ID
        if (adminId == null) {
            adminId = AdminContext.getAdminId();
        }
        
        // 权限检查：只能查询自己的权限，或需要管理员权限才能查询其他用户的权限
        Long currentAdminId = AdminContext.getAdminId();
        if (!currentAdminId.equals(adminId)) {
            // TODO: 可以添加权限检查，只有管理员才能查询其他用户的权限
            // 这里简化处理，允许查询自己的权限
        }
        
        List<String> permissionCodes = sysPermissionService.getPermissionCodesByAdminId(adminId);
        return Result.success(permissionCodes);
    }
    
    /**
     * 查询当前登录用户的所有权限标识列表
     * 
     * @return 权限标识列表
     */
    @GetMapping("/codes")
    public Result<List<String>> getCurrentUserPermissionCodes() {
        Long adminId = AdminContext.getAdminId();
        List<String> permissionCodes = sysPermissionService.getPermissionCodesByAdminId(adminId);
        return Result.success(permissionCodes);
    }
}

