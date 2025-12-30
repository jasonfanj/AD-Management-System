package com.admanagement.service.impl;

import com.admanagement.common.AdminContext;
import com.admanagement.entity.SysAdmin;
import com.admanagement.entity.dto.PasswordResetDTO;
import com.admanagement.entity.dto.SelfInfoUpdateDTO;
import com.admanagement.entity.vo.PasswordResetPreviewVO;
import com.admanagement.entity.vo.SelfInfoVO;
import com.admanagement.repository.SysAdminMapper;
import com.admanagement.service.SelfService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

/**
 * 自助服务实现类
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Service
public class SelfServiceImpl implements SelfService {
    
    @Autowired
    private SysAdminMapper sysAdminMapper;
    
    @Autowired
    private BCryptPasswordEncoder passwordEncoder;
    
    /**
     * AD密码复杂度要求：
     * 1. 长度至少8位
     * 2. 包含大写字母
     * 3. 包含小写字母
     * 4. 包含数字
     * 5. 包含特殊字符（可选，根据AD策略）
     */
    private static final Pattern UPPERCASE_PATTERN = Pattern.compile("[A-Z]");
    private static final Pattern LOWERCASE_PATTERN = Pattern.compile("[a-z]");
    private static final Pattern DIGIT_PATTERN = Pattern.compile("[0-9]");
    private static final Pattern SPECIAL_CHAR_PATTERN = Pattern.compile("[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>/?]");
    
    @Override
    public SelfInfoVO getSelfInfo(Long adminId) {
        SysAdmin admin = sysAdminMapper.selectById(adminId);
        if (admin == null) {
            throw new RuntimeException("管理员不存在");
        }
        
        SelfInfoVO vo = new SelfInfoVO();
        BeanUtils.copyProperties(admin, vo);
        
        // 设置状态文本
        if (admin.getStatus() != null) {
            vo.setStatusText(admin.getStatus() == 1 ? "启用" : "禁用");
        }
        
        return vo;
    }
    
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateSelfInfo(Long adminId, SelfInfoUpdateDTO updateDTO) {
        SysAdmin admin = sysAdminMapper.selectById(adminId);
        if (admin == null) {
            throw new RuntimeException("管理员不存在");
        }
        
        // 更新信息
        if (updateDTO.getRealName() != null) {
            admin.setRealName(updateDTO.getRealName());
        }
        if (updateDTO.getPhone() != null) {
            admin.setPhone(updateDTO.getPhone());
        }
        if (updateDTO.getEmail() != null) {
            admin.setEmail(updateDTO.getEmail());
        }
        
        admin.setUpdateTime(LocalDateTime.now());
        sysAdminMapper.updateById(admin);
    }
    
    @Override
    public PasswordResetPreviewVO previewPasswordReset(Long adminId, PasswordResetDTO passwordResetDTO) {
        PasswordResetPreviewVO preview = new PasswordResetPreviewVO();
        List<String> messages = new ArrayList<>();
        
        // 1. 校验原密码
        SysAdmin admin = sysAdminMapper.selectById(adminId);
        if (admin == null) {
            preview.setValid(false);
            preview.setMessage("管理员不存在");
            return preview;
        }
        
        if (!passwordEncoder.matches(passwordResetDTO.getOldPassword(), admin.getPassword())) {
            preview.setValid(false);
            preview.setMessage("原密码不正确");
            return preview;
        }
        
        // 2. 校验新密码和确认密码是否一致
        if (!passwordResetDTO.getNewPassword().equals(passwordResetDTO.getConfirmPassword())) {
            preview.setValid(false);
            preview.setMessage("新密码和确认密码不一致");
            return preview;
        }
        
        // 3. 校验新密码不能与原密码相同
        if (passwordEncoder.matches(passwordResetDTO.getNewPassword(), admin.getPassword())) {
            preview.setValid(false);
            preview.setMessage("新密码不能与原密码相同");
            return preview;
        }
        
        // 4. 校验AD密码格式（模拟AD密码格式校验）
        String newPassword = passwordResetDTO.getNewPassword();
        List<String> complexityHints = new ArrayList<>();
        
        // 长度校验
        if (newPassword.length() < 8) {
            messages.add("密码长度至少8位");
        }
        
        // 大写字母校验
        if (!UPPERCASE_PATTERN.matcher(newPassword).find()) {
            complexityHints.add("包含大写字母");
            messages.add("密码必须包含至少一个大写字母");
        }
        
        // 小写字母校验
        if (!LOWERCASE_PATTERN.matcher(newPassword).find()) {
            complexityHints.add("包含小写字母");
            messages.add("密码必须包含至少一个小写字母");
        }
        
        // 数字校验
        if (!DIGIT_PATTERN.matcher(newPassword).find()) {
            complexityHints.add("包含数字");
            messages.add("密码必须包含至少一个数字");
        }
        
        // 特殊字符校验（可选）
        boolean hasSpecialChar = SPECIAL_CHAR_PATTERN.matcher(newPassword).find();
        if (!hasSpecialChar) {
            complexityHints.add("包含特殊字符（可选）");
        }
        
        // 构建复杂度提示
        if (!complexityHints.isEmpty()) {
            preview.setComplexityHint("密码需要：" + String.join("、", complexityHints));
        } else {
            preview.setComplexityHint("密码复杂度符合要求");
        }
        
        // 判断是否通过校验
        if (!messages.isEmpty()) {
            preview.setValid(false);
            preview.setMessage(String.join("；", messages));
        } else {
            preview.setValid(true);
            preview.setMessage("密码格式校验通过");
        }
        
        return preview;
    }
    
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void resetPassword(Long adminId, PasswordResetDTO passwordResetDTO) {
        // 先进行预览校验
        PasswordResetPreviewVO preview = previewPasswordReset(adminId, passwordResetDTO);
        if (!preview.getValid()) {
            throw new RuntimeException(preview.getMessage());
        }
        
        // 更新密码
        SysAdmin admin = sysAdminMapper.selectById(adminId);
        if (admin == null) {
            throw new RuntimeException("管理员不存在");
        }
        
        // 加密新密码
        String encodedPassword = passwordEncoder.encode(passwordResetDTO.getNewPassword());
        admin.setPassword(encodedPassword);
        admin.setUpdateTime(LocalDateTime.now());
        
        sysAdminMapper.updateById(admin);
    }
}

