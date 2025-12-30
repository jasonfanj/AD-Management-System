package com.admanagement.controller.audit;

import com.admanagement.annotation.ModulePermission;
import com.admanagement.annotation.OperationLog;
import com.admanagement.common.PageResult;
import com.admanagement.common.Result;
import com.admanagement.entity.dto.AuditLogQueryDTO;
import com.admanagement.entity.vo.AuditLogVO;
import com.admanagement.service.AdOperationAuditService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 审计日志控制器
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@RestController
@RequestMapping("/ad-audit/logs")
@ModulePermission(value = "audit", description = "审计管理模块")
// 注意：模块标识使用"audit"（与数据库sys_module表中的module_code保持一致）
public class AuditLogController {
    
    @Autowired
    private AdOperationAuditService adOperationAuditService;
    
    /**
     * 分页查询审计日志列表
     * 支持按操作人、操作时间、操作模块筛选
     * 
     * @param queryDTO 查询条件
     * @return 分页结果
     */
    @GetMapping("/list")
    @OperationLog(operationType = "QUERY", operationContent = "查询审计日志列表", operationModule = "audit")
    public Result<PageResult<AuditLogVO>> getAuditLogList(@Valid AuditLogQueryDTO queryDTO) {
        try {
            PageResult<AuditLogVO> result = adOperationAuditService.getAuditLogList(queryDTO);
            return Result.success(result);
        } catch (Exception e) {
            return Result.error("查询审计日志列表失败：" + e.getMessage());
        }
    }
    
    /**
     * 插入模拟审计数据（用于测试）
     * 
     * @return 操作结果
     */
    @PostMapping("/mock-data")
    public Result<Void> insertMockData() {
        try {
            adOperationAuditService.insertMockAuditData();
            return Result.success("模拟数据插入成功");
        } catch (Exception e) {
            return Result.error("插入模拟数据失败：" + e.getMessage());
        }
    }
}
