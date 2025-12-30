package com.admanagement.controller.ad;

import com.admanagement.annotation.ModulePermission;
import com.admanagement.annotation.OperationLog;
import com.admanagement.common.PageResult;
import com.admanagement.common.Result;
import com.admanagement.entity.dto.AdUserQueryDTO;
import com.admanagement.entity.vo.AdUserVO;
import com.admanagement.service.AdUserService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * AD用户控制器
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@RestController
@RequestMapping("/ad-manage/users")
@ModulePermission(value = "ad_manager", description = "AD管理模块")
public class AdUserController {
    
    @Autowired
    private AdUserService adUserService;
    
    /**
     * 分页查询AD用户列表
     * 
     * @param queryDTO 查询条件
     * @return 分页结果
     */
    @GetMapping("/list")
    @OperationLog(operationType = "QUERY", operationContent = "查询AD用户列表", operationModule = "ad_manager")
    public Result<PageResult<AdUserVO>> getAdUserList(@Valid AdUserQueryDTO queryDTO) {
        try {
            PageResult<AdUserVO> result = adUserService.getAdUserList(queryDTO);
            return Result.success(result);
        } catch (Exception e) {
            return Result.error("查询AD用户列表失败：" + e.getMessage());
        }
    }
    
    /**
     * 批量导入预览
     * 
     * @param users 用户数据
     * @return 预览结果
     */
    @PostMapping("/preview-import")
    public Result<List<AdUserVO>> previewBatchImport(@RequestBody List<AdUserVO> users) {
        try {
            List<AdUserVO> result = adUserService.previewBatchImport(users);
            return Result.success(result);
        } catch (Exception e) {
            return Result.error("批量导入预览失败：" + e.getMessage());
        }
    }
}
