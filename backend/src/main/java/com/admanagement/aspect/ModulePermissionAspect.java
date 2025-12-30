package com.admanagement.aspect;

import com.admanagement.annotation.ModulePermission;
import com.admanagement.common.AdminContext;
import com.admanagement.exception.PermissionException;
import com.admanagement.service.SysPermissionService;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.lang.reflect.Method;

/**
 * 模块权限校验切面
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Aspect
@Component
@Order(1) // 设置切面优先级，确保在其他切面之前执行
public class ModulePermissionAspect {
    
    private static final Logger logger = LoggerFactory.getLogger(ModulePermissionAspect.class);
    
    @Autowired
    private SysPermissionService sysPermissionService;
    
    /**
     * 定义切点：拦截带有@ModulePermission注解的方法
     */
    @Pointcut("@annotation(com.admanagement.annotation.ModulePermission)")
    public void modulePermissionPointcut() {
    }
    
    /**
     * 权限校验通知：在方法执行前进行权限校验
     */
    @Before("modulePermissionPointcut()")
    public void doBefore(JoinPoint joinPoint) {
        // 获取方法签名
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        Method method = signature.getMethod();
        
        // 获取@ModulePermission注解
        ModulePermission annotation = method.getAnnotation(ModulePermission.class);
        if (annotation == null) {
            // 如果方法上没有注解，尝试从类上获取
            annotation = method.getDeclaringClass().getAnnotation(ModulePermission.class);
        }
        
        if (annotation == null) {
            logger.warn("未找到@ModulePermission注解，跳过权限校验");
            return;
        }
        
        // 获取模块标识
        String moduleCode = annotation.value();
        String description = annotation.description();
        
        // 获取当前管理员ID
        Long adminId = AdminContext.getAdminId();
        if (adminId == null) {
            logger.error("管理员ID为空，无法进行权限校验");
            throw new PermissionException("未登录或登录已过期，请重新登录");
        }
        
        // 校验权限
        boolean hasPermission = sysPermissionService.hasModulePermission(adminId, moduleCode);
        
        if (!hasPermission) {
            String errorMsg = String.format("无该模块访问权限：%s", 
                description.isEmpty() ? moduleCode : description);
            logger.warn("管理员[{}]尝试访问无权限的模块[{}]", adminId, moduleCode);
            throw new PermissionException(errorMsg);
        }
        
        logger.debug("管理员[{}]通过模块权限校验[{}]", adminId, moduleCode);
    }
}

