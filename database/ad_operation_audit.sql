-- AD操作审计表
-- Version: 1.0.0
-- Description: AD操作审计表，用于记录AD相关的所有操作

USE `ad_management_system`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ===========================================
-- AD操作审计表 (ad_operation_audit)
-- ===========================================
DROP TABLE IF EXISTS `ad_operation_audit`;
CREATE TABLE `ad_operation_audit` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '审计ID',
  `operator_id` bigint DEFAULT NULL COMMENT '操作人ID（关联sys_admin.id）',
  `operator_username` varchar(50) DEFAULT NULL COMMENT '操作人账号',
  `operator_name` varchar(50) DEFAULT NULL COMMENT '操作人姓名',
  `operation_module` varchar(50) DEFAULT NULL COMMENT '操作模块（如：ad_manager, self_service, audit）',
  `operation_type` varchar(50) NOT NULL COMMENT '操作类型（如：CREATE, UPDATE, DELETE, QUERY, LOGIN, LOGOUT）',
  `operation_content` varchar(500) DEFAULT NULL COMMENT '操作内容（简要描述）',
  `operation_detail` text COMMENT '操作详情（JSON格式，存储详细操作信息）',
  `operation_ip` varchar(50) DEFAULT NULL COMMENT '操作IP地址',
  `operation_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  `operation_result` tinyint NOT NULL DEFAULT '1' COMMENT '操作结果：0-失败，1-成功',
  `error_message` varchar(500) DEFAULT NULL COMMENT '错误信息（操作失败时记录）',
  `request_url` varchar(500) DEFAULT NULL COMMENT '请求URL',
  `request_method` varchar(10) DEFAULT NULL COMMENT '请求方法（GET, POST, PUT, DELETE）',
  `execution_time` bigint DEFAULT NULL COMMENT '执行时间（毫秒）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_operator_id` (`operator_id`),
  KEY `idx_operator_username` (`operator_username`),
  KEY `idx_operation_module` (`operation_module`),
  KEY `idx_operation_type` (`operation_type`),
  KEY `idx_operation_time` (`operation_time`),
  KEY `idx_operation_result` (`operation_result`),
  KEY `idx_operation_module_time` (`operation_module`, `operation_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AD操作审计表';

-- ===========================================
-- 插入测试数据（模拟AD操作审计数据）
-- ===========================================
INSERT INTO `ad_operation_audit` (
  `operator_id`, `operator_username`, `operator_name`, 
  `operation_module`, `operation_type`, `operation_content`, 
  `operation_ip`, `operation_time`, `operation_result`, 
  `request_url`, `request_method`, `execution_time`
) VALUES
(1, 'admin', '超级管理员', 'ad_manager', 'QUERY', '查询AD用户列表', '192.168.1.100', NOW() - INTERVAL 1 HOUR, 1, '/api/ad-manage/users/list', 'GET', 125),
(1, 'admin', '超级管理员', 'ad_manager', 'CREATE', '创建AD用户：testuser01', '192.168.1.100', NOW() - INTERVAL 2 HOUR, 1, '/api/ad-manage/users', 'POST', 234),
(2, 'admanager', 'AD管理员', 'ad_manager', 'UPDATE', '更新AD用户：testuser02的邮箱', '192.168.1.101', NOW() - INTERVAL 3 HOUR, 1, '/api/ad-manage/users/123', 'PUT', 189),
(1, 'admin', '超级管理员', 'ad_manager', 'QUERY', '查询OU列表', '192.168.1.100', NOW() - INTERVAL 4 HOUR, 1, '/api/ad-manage/ous/list', 'GET', 87),
(2, 'admanager', 'AD管理员', 'ad_manager', 'DELETE', '删除AD用户：testuser03', '192.168.1.101', NOW() - INTERVAL 5 HOUR, 0, '/api/ad-manage/users/456', 'DELETE', 156),
(1, 'admin', '超级管理员', 'self_service', 'PASSWORD_RESET', '密码重置申请审批通过', '192.168.1.100', NOW() - INTERVAL 6 HOUR, 1, '/api/self-service/password/reset/approve', 'POST', 312),
(3, 'auditor1', '审计员张三', 'audit', 'QUERY', '查询审计日志列表', '192.168.1.102', NOW() - INTERVAL 7 HOUR, 1, '/api/ad-audit/logs/list', 'GET', 98),
(1, 'admin', '超级管理员', 'ad_manager', 'QUERY', '查询AD用户列表', '192.168.1.100', NOW() - INTERVAL 8 HOUR, 1, '/api/ad-manage/users/list', 'GET', 134),
(2, 'admanager', 'AD管理员', 'ad_manager', 'CREATE', '批量导入AD用户', '192.168.1.101', NOW() - INTERVAL 9 HOUR, 1, '/api/ad-manage/users/batch-import', 'POST', 2345),
(1, 'admin', '超级管理员', 'ad_manager', 'QUERY', '查询OU详细信息', '192.168.1.100', NOW() - INTERVAL 10 HOUR, 1, '/api/ad-manage/ous/OU=Users,DC=example,DC=com', 'GET', 76);

SET FOREIGN_KEY_CHECKS = 1;

