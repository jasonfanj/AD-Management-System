package com.admanagement.exception;

/**
 * 认证异常（未登录或登录已过期）
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
public class AuthenticationException extends RuntimeException {
    
    public AuthenticationException(String message) {
        super(message);
    }
    
    public AuthenticationException(String message, Throwable cause) {
        super(message, cause);
    }
}

