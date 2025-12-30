package com.admanagement.service.impl;

import com.admanagement.entity.SysModule;
import com.admanagement.entity.vo.ModuleInfoVO;
import com.admanagement.repository.SysModuleMapper;
import com.admanagement.service.SysModuleService;
import com.admanagement.service.SysPermissionService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 模块服务实现类
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Service
public class SysModuleServiceImpl implements SysModuleService {
    
    @Autowired
    private SysModuleMapper sysModuleMapper;
    
    @Autowired
    private SysPermissionService sysPermissionService;
    
    @Override
    public List<ModuleInfoVO> getModulesByAdminId(Long adminId) {
        // 查询管理员有权限的模块列表
        List<SysModule> modules = sysModuleMapper.selectModulesByAdminId(adminId);
        
        // 转换为VO
        List<ModuleInfoVO> moduleInfoList = modules.stream()
            .map(this::convertToVO)
            .collect(Collectors.toList());
        
        // 构建树形结构
        return buildModuleTree(moduleInfoList, 0L);
    }
    
    @Override
    public ModuleInfoVO getModuleInfoByCode(String moduleCode) {
        // 查询模块信息
        SysModule module = sysModuleMapper.selectByModuleCode(moduleCode);
        if (module == null) {
            return null;
        }
        
        // 转换为VO
        ModuleInfoVO moduleInfo = convertToVO(module);
        
        // 查询子模块
        List<SysModule> children = sysModuleMapper.selectChildrenByParentId(module.getId());
        if (children != null && !children.isEmpty()) {
            List<ModuleInfoVO> childrenVO = children.stream()
                .map(this::convertToVO)
                .collect(Collectors.toList());
            moduleInfo.setChildren(childrenVO);
        }
        
        return moduleInfo;
    }
    
    @Override
    public boolean hasModulePermission(Long adminId, String moduleCode) {
        return sysPermissionService.hasModulePermission(adminId, moduleCode);
    }
    
    /**
     * 将SysModule转换为ModuleInfoVO
     */
    private ModuleInfoVO convertToVO(SysModule module) {
        ModuleInfoVO vo = new ModuleInfoVO();
        BeanUtils.copyProperties(module, vo);
        return vo;
    }
    
    /**
     * 构建模块树形结构
     * 注意：当前查询逻辑已经通过关联查询过滤了有权限的模块，这里简化处理直接返回
     * 如果需要完整的树形结构，需要查询所有模块然后根据权限过滤
     */
    private List<ModuleInfoVO> buildModuleTree(List<ModuleInfoVO> allModules, Long parentId) {
        // 当前实现：由于已经通过SQL关联查询过滤了有权限的模块
        // 简化处理，直接返回所有模块（都是顶级模块或已过滤的子模块）
        // 如果需要构建完整的树形结构，可以在这里实现递归逻辑
        return allModules;
    }
}
