package com.admanagement.service.impl;

import com.admanagement.common.PageResult;
import com.admanagement.entity.AdOperationAudit;
import com.admanagement.entity.dto.AuditLogQueryDTO;
import com.admanagement.entity.vo.AuditLogVO;
import com.admanagement.repository.AdOperationAuditMapper;
import com.admanagement.service.AdOperationAuditService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * AD操作审计服务实现类
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Service
public class AdOperationAuditServiceImpl implements AdOperationAuditService {
    
    @Autowired
    private AdOperationAuditMapper adOperationAuditMapper;
    
    // 操作模块映射
    private static final Map<String, String> MODULE_MAP = new HashMap<>();
    static {
        MODULE_MAP.put("ad_manager", "AD管理");
        MODULE_MAP.put("self_service", "自助服务");
        MODULE_MAP.put("audit", "审计管理");
    }
    
    // 操作类型映射
    private static final Map<String, String> TYPE_MAP = new HashMap<>();
    static {
        TYPE_MAP.put("CREATE", "创建");
        TYPE_MAP.put("UPDATE", "更新");
        TYPE_MAP.put("DELETE", "删除");
        TYPE_MAP.put("QUERY", "查询");
        TYPE_MAP.put("LOGIN", "登录");
        TYPE_MAP.put("LOGOUT", "登出");
        TYPE_MAP.put("PASSWORD_RESET", "密码重置");
        TYPE_MAP.put("ACCOUNT_UNLOCK", "账户解锁");
    }
    
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void insertAuditLog(AdOperationAudit auditLog) {
        // 设置操作时间为当前时间
        if (auditLog.getOperationTime() == null) {
            auditLog.setOperationTime(LocalDateTime.now());
        }
        adOperationAuditMapper.insert(auditLog);
    }
    
    @Override
    public PageResult<AuditLogVO> getAuditLogList(AuditLogQueryDTO queryDTO) {
        // 计算偏移量
        queryDTO.setOffset(queryDTO.getOffset());
        
        // 查询总数
        Long total = adOperationAuditMapper.countAuditLogList(queryDTO);
        
        // 查询列表
        List<AdOperationAudit> auditLogs = adOperationAuditMapper.selectAuditLogList(queryDTO);
        
        // 转换为VO
        List<AuditLogVO> voList = auditLogs.stream()
            .map(this::convertToVO)
            .collect(Collectors.toList());
        
        // 构建分页结果
        return PageResult.of(
            queryDTO.getPageNum().longValue(),
            queryDTO.getPageSize().longValue(),
            total,
            voList
        );
    }
    
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void insertMockAuditData() {
        // 模拟插入AD操作审计数据
        LocalDateTime now = LocalDateTime.now();
        
        // 模拟数据1：查询AD用户列表
        AdOperationAudit audit1 = new AdOperationAudit();
        audit1.setOperatorId(1L);
        audit1.setOperatorUsername("admin");
        audit1.setOperatorName("超级管理员");
        audit1.setOperationModule("ad_manager");
        audit1.setOperationType("QUERY");
        audit1.setOperationContent("查询AD用户列表");
        audit1.setOperationIp("192.168.1.100");
        audit1.setOperationTime(now.minusHours(1));
        audit1.setOperationResult(1);
        audit1.setRequestUrl("/api/ad-manage/users/list");
        audit1.setRequestMethod("GET");
        audit1.setExecutionTime(125L);
        adOperationAuditMapper.insert(audit1);
        
        // 模拟数据2：创建AD用户
        AdOperationAudit audit2 = new AdOperationAudit();
        audit2.setOperatorId(1L);
        audit2.setOperatorUsername("admin");
        audit2.setOperatorName("超级管理员");
        audit2.setOperationModule("ad_manager");
        audit2.setOperationType("CREATE");
        audit2.setOperationContent("创建AD用户：testuser01");
        audit2.setOperationIp("192.168.1.100");
        audit2.setOperationTime(now.minusHours(2));
        audit2.setOperationResult(1);
        audit2.setRequestUrl("/api/ad-manage/users");
        audit2.setRequestMethod("POST");
        audit2.setExecutionTime(234L);
        adOperationAuditMapper.insert(audit2);
        
        // 模拟数据3：更新AD用户（失败）
        AdOperationAudit audit3 = new AdOperationAudit();
        audit3.setOperatorId(2L);
        audit3.setOperatorUsername("admanager");
        audit3.setOperatorName("AD管理员");
        audit3.setOperationModule("ad_manager");
        audit3.setOperationType("UPDATE");
        audit3.setOperationContent("更新AD用户信息");
        audit3.setOperationIp("192.168.1.101");
        audit3.setOperationTime(now.minusHours(3));
        audit3.setOperationResult(0);
        audit3.setErrorMessage("用户不存在");
        audit3.setRequestUrl("/api/ad-manage/users/999");
        audit3.setRequestMethod("PUT");
        audit3.setExecutionTime(89L);
        adOperationAuditMapper.insert(audit3);
    }
    
    /**
     * 将AdOperationAudit实体转换为AuditLogVO
     */
    private AuditLogVO convertToVO(AdOperationAudit auditLog) {
        AuditLogVO vo = new AuditLogVO();
        BeanUtils.copyProperties(auditLog, vo);
        
        // 设置操作模块文本
        vo.setOperationModuleText(MODULE_MAP.getOrDefault(auditLog.getOperationModule(), auditLog.getOperationModule()));
        
        // 设置操作类型文本
        vo.setOperationTypeText(TYPE_MAP.getOrDefault(auditLog.getOperationType(), auditLog.getOperationType()));
        
        // 设置操作结果文本
        if (auditLog.getOperationResult() != null) {
            vo.setOperationResultText(auditLog.getOperationResult() == 1 ? "成功" : "失败");
        }
        
        return vo;
    }
}

