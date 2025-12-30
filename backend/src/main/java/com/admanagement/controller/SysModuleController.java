package com.admanagement.controller;

import com.admanagement.annotation.ModulePermission;
import com.admanagement.common.AdminContext;
import com.admanagement.common.Result;
import com.admanagement.entity.dto.ModuleSwitchDTO;
import com.admanagement.entity.vo.ModuleInfoVO;
import com.admanagement.service.SysModuleService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 模块控制器
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@RestController
@RequestMapping("/module")
public class SysModuleController {
    
    @Autowired
    private SysModuleService sysModuleService;
    
    /**
     * 接口2：根据管理员ID查询该用户有权限访问的模块列表（只返回启用状态的模块）
     * 
     * @param adminId 管理员ID（可选，不传则查询当前登录用户）
     * @return 模块列表
     */
    @GetMapping("/list/{adminId}")
    public Result<List<ModuleInfoVO>> getModules(@PathVariable(required = false) Long adminId) {
        // 如果未传递adminId，使用当前登录用户ID
        if (adminId == null) {
            adminId = AdminContext.getAdminId();
        }
        
        List<ModuleInfoVO> modules = sysModuleService.getModulesByAdminId(adminId);
        return Result.success(modules);
    }
    
    /**
     * 查询当前登录用户有权限访问的模块列表
     * 
     * @return 模块列表
     */
    @GetMapping("/list")
    public Result<List<ModuleInfoVO>> getCurrentUserModules() {
        Long adminId = AdminContext.getAdminId();
        List<ModuleInfoVO> modules = sysModuleService.getModulesByAdminId(adminId);
        return Result.success(modules);
    }
    
    /**
     * 模块切换接口：接收目标模块标识参数 → 校验当前管理员是否有该模块权限 → 校验通过后返回该模块的基础信息
     * 
     * @param dto 模块切换DTO
     * @return 模块信息
     */
    @PostMapping("/switch")
    public Result<ModuleInfoVO> switchModule(@Valid @RequestBody ModuleSwitchDTO dto) {
        Long adminId = AdminContext.getAdminId();
        String moduleCode = dto.getModuleCode();
        
        // 校验当前管理员是否有该模块权限
        boolean hasPermission = sysModuleService.hasModulePermission(adminId, moduleCode);
        
        if (!hasPermission) {
            return Result.error(403, "无该模块访问权限：" + moduleCode);
        }
        
        // 获取模块信息（包含子模块）
        ModuleInfoVO moduleInfo = sysModuleService.getModuleInfoByCode(moduleCode);
        
        if (moduleInfo == null) {
            return Result.error("模块不存在或已禁用");
        }
        
        return Result.success("模块切换成功", moduleInfo);
    }
}

