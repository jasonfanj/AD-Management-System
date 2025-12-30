package com.admanagement.service;

import com.admanagement.entity.dto.LoginDTO;
import com.admanagement.entity.vo.LoginVO;

/**
 * 管理员服务接口
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
public interface SysAdminService {
    
    /**
     * 管理员登录
     * 
     * @param loginDTO 登录信息
     * @return 登录结果（包含Token和管理员信息）
     */
    LoginVO login(LoginDTO loginDTO);
    
    /**
     * 管理员登出
     * 
     * @param token JWT Token
     */
    void logout(String token);
}

