package com.admanagement.annotation;

import java.lang.annotation.*;

/**
 * 操作日志注解
 * 用于标记需要记录操作日志的方法
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface OperationLog {
    
    /**
     * 操作类型（如：LOGIN, LOGOUT, QUERY, CREATE, UPDATE, DELETE）
     */
    String operationType();
    
    /**
     * 操作内容描述（支持SpEL表达式，如：#{#dto.name}）
     */
    String operationContent() default "";
    
    /**
     * 操作模块（如：ad_manager, self_service, audit）
     */
    String operationModule() default "";
}

