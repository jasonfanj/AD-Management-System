package com.admanagement.interceptor;

import com.admanagement.common.AdminContext;
import com.admanagement.exception.AuthenticationException;
import com.admanagement.utils.JwtUtil;
import com.admanagement.utils.RedisUtil;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;


/**
 * Token校验拦截器
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Component
public class TokenInterceptor implements HandlerInterceptor {
    
    @Autowired
    private JwtUtil jwtUtil;
    
    @Autowired
    private RedisUtil redisUtil;
    
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 1. 从请求头获取Token
        String authHeader = request.getHeader("Authorization");
        String token = jwtUtil.extractTokenFromHeader(authHeader);
        
        if (token == null || token.isEmpty()) {
            // Token为空，抛出认证异常
            throw new AuthenticationException("未授权，请先登录");
        }
        
        // 2. 校验Token是否在黑名单中
        if (redisUtil.isTokenInBlacklist(token)) {
            throw new AuthenticationException("Token已失效，请重新登录");
        }
        
        // 3. 校验Token是否有效（是否过期）
        if (!jwtUtil.validateToken(token)) {
            throw new AuthenticationException("Token已过期，请重新登录");
        }
        
        // 4. 解析Token中的管理员信息存入上下文
        AdminContext.AdminInfo adminInfo = new AdminContext.AdminInfo();
        adminInfo.setAdminId(jwtUtil.getAdminIdFromToken(token));
        adminInfo.setUsername(jwtUtil.getUsernameFromToken(token));
        adminInfo.setRoleIds(jwtUtil.getRoleIdsFromToken(token));
        adminInfo.setRoleCodes(jwtUtil.getRoleCodesFromToken(token));
        AdminContext.setAdminInfo(adminInfo);
        
        return true;
    }
    
    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        // 请求完成后清除上下文信息，防止内存泄漏
        AdminContext.clear();
    }
}
