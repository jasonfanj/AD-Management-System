package com.admanagement.aspect;

import com.admanagement.annotation.OperationLog;
import com.admanagement.common.AdminContext;
import jakarta.servlet.http.HttpServletRequest;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.lang.reflect.Method;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

/**
 * 操作日志切面
 * 记录管理员的登录、模块切换、核心业务操作
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Aspect
@Component
@Order(2) // 设置切面优先级，在权限校验切面之后执行
public class OperationLogAspect {
    
    private static final Logger operationLogger = LoggerFactory.getLogger("OPERATION_LOG");
    
    @Autowired
    private com.admanagement.service.AdOperationAuditService adOperationAuditService;
    
    /**
     * 定义切点：拦截所有Controller类中带有@OperationLog注解的方法
     */
    @Pointcut("@annotation(com.admanagement.annotation.OperationLog)")
    public void operationLogPointcut() {
    }
    
    /**
     * 环绕通知：记录操作日志
     */
    @Around("operationLogPointcut()")
    public Object doAround(ProceedingJoinPoint joinPoint) throws Throwable {
        // 开始时间
        long startTime = System.currentTimeMillis();
        
        // 获取请求信息
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        HttpServletRequest request = attributes != null ? attributes.getRequest() : null;
        
        // 获取方法签名和注解
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        Method method = signature.getMethod();
        OperationLog operationLog = method.getAnnotation(OperationLog.class);
        
        // 获取操作信息
        String operationType = operationLog.operationType();
        String operationContent = operationLog.operationContent();
        String operationModule = operationLog.operationModule();
        String requestUrl = request != null ? request.getRequestURI() : "";
        String requestMethod = request != null ? request.getMethod() : "";
        String operationIp = getClientIp(request);
        
        // 获取管理员信息
        Long adminId = AdminContext.getCurrentAdminId();
        String adminUsername = AdminContext.getCurrentAdminUsername();
        
        // 执行结果
        boolean success = false;
        String errorMessage = null;
        Object result = null;
        
        try {
            // 执行方法
            result = joinPoint.proceed();
            
            // 判断是否成功（Result对象且code为200）
            if (result instanceof com.admanagement.common.Result) {
                com.admanagement.common.Result<?> resultObj = (com.admanagement.common.Result<?>) result;
                success = resultObj.getCode() != null && resultObj.getCode() == 200;
                if (!success) {
                    errorMessage = resultObj.getMessage();
                }
            } else {
                success = true;
            }
            
            return result;
        } catch (Exception e) {
            success = false;
            errorMessage = e.getMessage();
            throw e;
        } finally {
            // 计算执行时间
            long executionTime = System.currentTimeMillis() - startTime;
            
            // 记录操作日志到文件
            logOperationToFile(adminId, adminUsername, operationType, operationContent, 
                             operationModule, operationIp, requestUrl, requestMethod, 
                             success, errorMessage, executionTime);
            
            // 保存操作日志到数据库（异步，避免影响主流程）
            saveOperationLogToDatabase(adminId, adminUsername, operationType, operationContent,
                                     operationModule, operationIp, requestUrl, requestMethod,
                                     success, errorMessage, executionTime);
        }
    }
    
    /**
     * 记录操作日志到文件
     */
    private void logOperationToFile(Long adminId, String adminUsername, String operationType,
                                   String operationContent, String operationModule, String operationIp,
                                   String requestUrl, String requestMethod, boolean success,
                                   String errorMessage, long executionTime) {
        try {
            StringBuilder logBuilder = new StringBuilder();
            logBuilder.append("操作人ID: ").append(adminId != null ? adminId : "未知").append(" | ");
            logBuilder.append("操作人: ").append(adminUsername != null ? adminUsername : "未知").append(" | ");
            logBuilder.append("操作类型: ").append(operationType).append(" | ");
            logBuilder.append("操作内容: ").append(operationContent).append(" | ");
            logBuilder.append("操作模块: ").append(operationModule).append(" | ");
            logBuilder.append("操作IP: ").append(operationIp).append(" | ");
            logBuilder.append("请求URL: ").append(requestUrl).append(" | ");
            logBuilder.append("请求方法: ").append(requestMethod).append(" | ");
            logBuilder.append("操作结果: ").append(success ? "成功" : "失败").append(" | ");
            if (!success && errorMessage != null) {
                logBuilder.append("错误信息: ").append(errorMessage).append(" | ");
            }
            logBuilder.append("执行时间: ").append(executionTime).append("ms");
            
            operationLogger.info(logBuilder.toString());
        } catch (Exception e) {
            // 记录日志失败不影响主流程
            LoggerFactory.getLogger(OperationLogAspect.class)
                .error("记录操作日志到文件失败", e);
        }
    }
    
    /**
     * 保存操作日志到数据库
     */
    private void saveOperationLogToDatabase(Long adminId, String adminUsername, String operationType,
                                           String operationContent, String operationModule, String operationIp,
                                           String requestUrl, String requestMethod, boolean success,
                                           String errorMessage, long executionTime) {
        try {
            com.admanagement.entity.AdOperationAudit auditLog = new com.admanagement.entity.AdOperationAudit();
            auditLog.setOperatorId(adminId);
            auditLog.setOperatorUsername(adminUsername);
            auditLog.setOperationType(operationType);
            auditLog.setOperationContent(operationContent);
            auditLog.setOperationModule(operationModule);
            auditLog.setOperationIp(operationIp);
            auditLog.setRequestUrl(requestUrl);
            auditLog.setRequestMethod(requestMethod);
            auditLog.setOperationResult(success ? 1 : 0);
            auditLog.setErrorMessage(errorMessage);
            auditLog.setExecutionTime(executionTime);
            auditLog.setOperationTime(java.time.LocalDateTime.now());
            
            // 异步保存（这里简化为同步，实际可以使用@Async）
            adOperationAuditService.insertAuditLog(auditLog);
        } catch (Exception e) {
            // 保存数据库失败不影响主流程，只记录错误日志
            LoggerFactory.getLogger(OperationLogAspect.class)
                .error("保存操作日志到数据库失败", e);
        }
    }
    
    /**
     * 生成操作内容
     */
    private String generateOperationContent(String methodName, String operationType) {
        // 根据方法名和操作类型生成操作内容
        if (methodName.contains("login")) {
            return "用户登录";
        } else if (methodName.contains("logout")) {
            return "用户登出";
        } else if (methodName.contains("switch")) {
            return "模块切换";
        } else if (methodName.contains("add") || methodName.contains("create")) {
            return "新增操作";
        } else if (methodName.contains("update") || methodName.contains("edit")) {
            return "更新操作";
        } else if (methodName.contains("delete") || methodName.contains("remove")) {
            return "删除操作";
        } else if (methodName.contains("query") || methodName.contains("get") || methodName.contains("list")) {
            return "查询操作";
        }
        return "系统操作";
    }
    
    /**
     * 获取客户端IP地址
     */
    private String getClientIp(HttpServletRequest request) {
        if (request == null) {
            return "未知";
        }
        
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        
        // 如果是多级代理，取第一个IP
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }
        
        return ip != null ? ip : "未知";
    }
}
