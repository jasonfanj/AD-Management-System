package com.admanagement.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 模块权限注解
 * 用于标记需要模块权限校验的接口
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Target({ElementType.METHOD, ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
public @interface ModulePermission {
    
    /**
     * 模块标识（如：ad_manager, self_service, audit）
     * 必填参数
     */
    String value();
    
    /**
     * 权限说明（可选，用于日志记录）
     */
    String description() default "";
}

