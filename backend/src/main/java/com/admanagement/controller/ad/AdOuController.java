package com.admanagement.controller.ad;

import com.admanagement.annotation.ModulePermission;
import com.admanagement.annotation.OperationLog;
import com.admanagement.common.Result;
import com.admanagement.entity.vo.AdOuVO;
import com.admanagement.service.AdOuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * OU控制器
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@RestController
@RequestMapping("/ad-manage/ous")
@ModulePermission(value = "ad_manager", description = "AD管理模块")
public class AdOuController {
    
    @Autowired
    private AdOuService adOuService;
    
    /**
     * 查询OU列表（树形结构）
     * 
     * @return OU列表
     */
    @GetMapping("/list")
    @OperationLog(operationType = "QUERY", operationContent = "查询OU列表", operationModule = "ad_manager")
    public Result<List<AdOuVO>> getOuList() {
        try {
            List<AdOuVO> ouList = adOuService.getOuList();
            return Result.success(ouList);
        } catch (Exception e) {
            return Result.error("查询OU列表失败：" + e.getMessage());
        }
    }
    
    /**
     * 根据DN查询OU信息
     * 
     * @param dn OU的DN
     * @return OU信息
     */
    @GetMapping("/{dn}")
    public Result<AdOuVO> getOuByDn(@PathVariable String dn) {
        try {
            AdOuVO ou = adOuService.getOuByDn(dn);
            return Result.success(ou);
        } catch (Exception e) {
            return Result.error("查询OU信息失败：" + e.getMessage());
        }
    }
}
