package com.admanagement.service;

import com.admanagement.entity.dto.PasswordResetDTO;
import com.admanagement.entity.dto.SelfInfoUpdateDTO;
import com.admanagement.entity.vo.PasswordResetPreviewVO;
import com.admanagement.entity.vo.SelfInfoVO;

/**
 * 自助服务接口
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
public interface SelfService {
    
    /**
     * 查询个人信息
     * 
     * @param adminId 管理员ID
     * @return 个人信息
     */
    SelfInfoVO getSelfInfo(Long adminId);
    
    /**
     * 更新个人信息
     * 
     * @param adminId 管理员ID
     * @param updateDTO 更新信息
     */
    void updateSelfInfo(Long adminId, SelfInfoUpdateDTO updateDTO);
    
    /**
     * 密码重置预览（校验密码格式）
     * 
     * @param adminId 管理员ID
     * @param passwordResetDTO 密码重置信息
     * @return 预览结果
     */
    PasswordResetPreviewVO previewPasswordReset(Long adminId, PasswordResetDTO passwordResetDTO);
    
    /**
     * 执行密码重置
     * 
     * @param adminId 管理员ID
     * @param passwordResetDTO 密码重置信息
     */
    void resetPassword(Long adminId, PasswordResetDTO passwordResetDTO);
}

