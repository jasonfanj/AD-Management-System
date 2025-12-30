package com.admanagement.service;

import com.admanagement.entity.vo.ModuleInfoVO;

import java.util.List;

/**
 * 模块服务接口
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
public interface SysModuleService {
    
    /**
     * 根据管理员ID查询有权限访问的模块列表（只返回启用状态的模块）
     * 
     * @param adminId 管理员ID
     * @return 模块列表
     */
    List<ModuleInfoVO> getModulesByAdminId(Long adminId);
    
    /**
     * 根据模块标识获取模块信息（包含子模块）
     * 
     * @param moduleCode 模块标识
     * @return 模块信息
     */
    ModuleInfoVO getModuleInfoByCode(String moduleCode);
    
    /**
     * 检查管理员是否有指定模块的权限
     * 
     * @param adminId 管理员ID
     * @param moduleCode 模块标识
     * @return 是否有权限
     */
    boolean hasModulePermission(Long adminId, String moduleCode);
}

