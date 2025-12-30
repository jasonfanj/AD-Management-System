package com.admanagement.exception;

/**
 * 权限异常类
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
public class PermissionException extends RuntimeException {
    
    public PermissionException(String message) {
        super(message);
    }
    
    public PermissionException(String message, Throwable cause) {
        super(message, cause);
    }
}

