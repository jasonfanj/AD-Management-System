package com.admanagement.controller.self;

import com.admanagement.annotation.ModulePermission;
import com.admanagement.common.AdminContext;
import com.admanagement.common.Result;
import com.admanagement.entity.dto.PasswordResetDTO;
import com.admanagement.entity.dto.SelfInfoUpdateDTO;
import com.admanagement.entity.vo.PasswordResetPreviewVO;
import com.admanagement.entity.vo.SelfInfoVO;
import com.admanagement.service.SelfService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 自助服务控制器
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@RestController
@RequestMapping("/ad-self")
@ModulePermission(value = "self_service", description = "自助服务模块")
// 注意：模块标识使用"self_service"（与数据库sys_module表中的module_code保持一致）
public class SelfServiceController {
    
    @Autowired
    private SelfService selfService;
    
    /**
     * 查询个人信息
     * 
     * @return 个人信息
     */
    @GetMapping("/info")
    public Result<SelfInfoVO> getSelfInfo() {
        try {
            Long adminId = AdminContext.getCurrentAdminId();
            if (adminId == null) {
                return Result.error("未登录或登录已过期，请重新登录");
            }
            
            SelfInfoVO selfInfo = selfService.getSelfInfo(adminId);
            return Result.success(selfInfo);
        } catch (Exception e) {
            return Result.error("查询个人信息失败：" + e.getMessage());
        }
    }
    
    /**
     * 更新个人信息
     * 
     * @param updateDTO 更新信息
     * @return 操作结果
     */
    @PutMapping("/info")
    public Result<Void> updateSelfInfo(@Valid @RequestBody SelfInfoUpdateDTO updateDTO) {
        try {
            Long adminId = AdminContext.getCurrentAdminId();
            if (adminId == null) {
                return Result.error("未登录或登录已过期，请重新登录");
            }
            
            selfService.updateSelfInfo(adminId, updateDTO);
            return Result.success("更新个人信息成功");
        } catch (Exception e) {
            return Result.error("更新个人信息失败：" + e.getMessage());
        }
    }
    
    /**
     * 密码重置预览（校验密码格式）
     * 
     * @param passwordResetDTO 密码重置信息
     * @return 预览结果
     */
    @PostMapping("/password/preview")
    public Result<PasswordResetPreviewVO> previewPasswordReset(@Valid @RequestBody PasswordResetDTO passwordResetDTO) {
        try {
            Long adminId = AdminContext.getCurrentAdminId();
            if (adminId == null) {
                return Result.error("未登录或登录已过期，请重新登录");
            }
            
            PasswordResetPreviewVO preview = selfService.previewPasswordReset(adminId, passwordResetDTO);
            return Result.success(preview);
        } catch (Exception e) {
            return Result.error("密码重置预览失败：" + e.getMessage());
        }
    }
    
    /**
     * 执行密码重置
     * 
     * @param passwordResetDTO 密码重置信息
     * @return 操作结果
     */
    @PostMapping("/password/reset")
    public Result<Void> resetPassword(@Valid @RequestBody PasswordResetDTO passwordResetDTO) {
        try {
            Long adminId = AdminContext.getCurrentAdminId();
            if (adminId == null) {
                return Result.error("未登录或登录已过期，请重新登录");
            }
            
            selfService.resetPassword(adminId, passwordResetDTO);
            return Result.success("密码重置成功");
        } catch (Exception e) {
            return Result.error("密码重置失败：" + e.getMessage());
        }
    }
}

