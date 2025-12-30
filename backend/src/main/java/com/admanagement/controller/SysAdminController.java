package com.admanagement.controller;

import com.admanagement.common.Result;
import com.admanagement.entity.dto.LoginDTO;
import com.admanagement.entity.vo.LoginVO;
import com.admanagement.service.SysAdminService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 管理员控制器
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@RestController
@RequestMapping("/admin")
public class SysAdminController {
    
    @Autowired
    private SysAdminService sysAdminService;
    
    /**
     * 管理员登录接口
     * 
     * @param loginDTO 登录信息（账号、密码）
     * @return 统一响应结果（包含Token、管理员基本信息、角色列表）
     */
    @PostMapping("/login")
    public Result<LoginVO> login(@Valid @RequestBody LoginDTO loginDTO) {
        try {
            LoginVO loginVO = sysAdminService.login(loginDTO);
            return Result.success("登录成功", loginVO);
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }
    
    /**
     * 管理员登出接口
     * 
     * @param request HTTP请求
     * @return 统一响应结果
     */
    @PostMapping("/logout")
    public Result<Void> logout(HttpServletRequest request) {
        try {
            // 从请求头获取Token
            String authHeader = request.getHeader("Authorization");
            if (authHeader != null && authHeader.startsWith("Bearer ")) {
                String token = authHeader.substring(7);
                sysAdminService.logout(token);
                return Result.success("登出成功", null);
            } else {
                return Result.error("Token不能为空");
            }
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }
}

