-- AD Management System Database Initialization
-- Version: 1.0.0
-- Description: 初始化数据库，包含基础表结构和预留的AD管理、自助服务、审计相关表

-- 创建数据库
CREATE DATABASE IF NOT EXISTS `ad_management_system`
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 使用数据库
USE `ad_management_system`;

-- 设置字符集
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ===========================================
-- 基础表结构
-- ===========================================

-- 用户表
CREATE TABLE `sys_user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `password` varchar(255) NOT NULL COMMENT '密码',
  `email` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(20) DEFAULT NULL COMMENT '手机号',
  `real_name` varchar(50) DEFAULT NULL COMMENT '真实姓名',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像',
  `gender` tinyint DEFAULT '0' COMMENT '性别：0-未知，1-男，2-女',
  `birthday` date DEFAULT NULL COMMENT '生日',
  `status` tinyint DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
  `last_login_time` datetime DEFAULT NULL COMMENT '最后登录时间',
  `last_login_ip` varchar(50) DEFAULT NULL COMMENT '最后登录IP',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` varchar(50) DEFAULT NULL COMMENT '创建者',
  `update_by` varchar(50) DEFAULT NULL COMMENT '更新者',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  UNIQUE KEY `uk_email` (`email`),
  KEY `idx_status` (`status`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- 角色表
CREATE TABLE `sys_role` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `role_code` varchar(50) NOT NULL COMMENT '角色编码',
  `role_name` varchar(50) NOT NULL COMMENT '角色名称',
  `description` varchar(200) DEFAULT NULL COMMENT '角色描述',
  `status` tinyint DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
  `sort_order` int DEFAULT '0' COMMENT '排序',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` varchar(50) DEFAULT NULL COMMENT '创建者',
  `update_by` varchar(50) DEFAULT NULL COMMENT '更新者',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_code` (`role_code`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色表';

-- 权限表
CREATE TABLE `sys_permission` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `permission_code` varchar(100) NOT NULL COMMENT '权限编码',
  `permission_name` varchar(100) NOT NULL COMMENT '权限名称',
  `description` varchar(200) DEFAULT NULL COMMENT '权限描述',
  `type` tinyint NOT NULL COMMENT '类型：1-菜单，2-按钮，3-接口',
  `parent_id` bigint DEFAULT '0' COMMENT '父级ID',
  `path` varchar(200) DEFAULT NULL COMMENT '路径',
  `component` varchar(200) DEFAULT NULL COMMENT '组件',
  `icon` varchar(50) DEFAULT NULL COMMENT '图标',
  `sort_order` int DEFAULT '0' COMMENT '排序',
  `status` tinyint DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_permission_code` (`permission_code`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_type` (`type`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='权限表';

-- 用户角色关联表
CREATE TABLE `sys_user_role` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_role` (`user_id`,`role_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户角色关联表';

-- 角色权限关联表
CREATE TABLE `sys_role_permission` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `permission_id` bigint NOT NULL COMMENT '权限ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_permission` (`role_id`,`permission_id`),
  KEY `idx_role_id` (`role_id`),
  KEY `idx_permission_id` (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色权限关联表';

-- ===========================================
-- AD管理相关表
-- ===========================================

-- AD域控制器表
CREATE TABLE `ad_domain_controller` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(100) NOT NULL COMMENT '控制器名称',
  `host` varchar(100) NOT NULL COMMENT '主机地址',
  `port` int DEFAULT '389' COMMENT '端口',
  `domain` varchar(100) NOT NULL COMMENT '域名',
  `base_dn` varchar(200) NOT NULL COMMENT '基础DN',
  `bind_user` varchar(100) NOT NULL COMMENT '绑定用户',
  `bind_password` varchar(255) NOT NULL COMMENT '绑定密码',
  `ssl_enabled` tinyint DEFAULT '0' COMMENT '是否启用SSL：0-否，1-是',
  `status` tinyint DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
  `description` varchar(200) DEFAULT NULL COMMENT '描述',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_host_domain` (`host`,`domain`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AD域控制器表';

-- AD用户表
CREATE TABLE `ad_user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `domain_controller_id` bigint NOT NULL COMMENT '域控制器ID',
  `dn` varchar(500) NOT NULL COMMENT 'DN',
  `sam_account_name` varchar(100) NOT NULL COMMENT 'SAM账户名',
  `user_principal_name` varchar(200) DEFAULT NULL COMMENT '用户主体名称',
  `display_name` varchar(100) DEFAULT NULL COMMENT '显示名称',
  `email` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `department` varchar(100) DEFAULT NULL COMMENT '部门',
  `title` varchar(100) DEFAULT NULL COMMENT '职位',
  `manager` varchar(200) DEFAULT NULL COMMENT '上级',
  `telephone_number` varchar(20) DEFAULT NULL COMMENT '电话',
  `mobile` varchar(20) DEFAULT NULL COMMENT '手机',
  `account_status` tinyint DEFAULT '1' COMMENT '账户状态：0-禁用，1-启用',
  `last_logon` datetime DEFAULT NULL COMMENT '最后登录时间',
  `password_last_set` datetime DEFAULT NULL COMMENT '密码最后设置时间',
  `password_expires` datetime DEFAULT NULL COMMENT '密码过期时间',
  `sync_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '同步时间',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_domain_sam` (`domain_controller_id`,`sam_account_name`),
  KEY `idx_domain_controller_id` (`domain_controller_id`),
  KEY `idx_account_status` (`account_status`),
  KEY `idx_sync_time` (`sync_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AD用户表';

-- AD用户组表
CREATE TABLE `ad_group` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `domain_controller_id` bigint NOT NULL COMMENT '域控制器ID',
  `dn` varchar(500) NOT NULL COMMENT 'DN',
  `sam_account_name` varchar(100) NOT NULL COMMENT 'SAM账户名',
  `display_name` varchar(100) DEFAULT NULL COMMENT '显示名称',
  `description` varchar(200) DEFAULT NULL COMMENT '描述',
  `group_type` int DEFAULT NULL COMMENT '组类型',
  `member_count` int DEFAULT '0' COMMENT '成员数量',
  `sync_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '同步时间',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_domain_sam` (`domain_controller_id`,`sam_account_name`),
  KEY `idx_domain_controller_id` (`domain_controller_id`),
  KEY `idx_sync_time` (`sync_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AD用户组表';

-- AD用户组成员关联表
CREATE TABLE `ad_user_group` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT 'AD用户ID',
  `group_id` bigint NOT NULL COMMENT 'AD用户组ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_group` (`user_id`,`group_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AD用户组成员关联表';

-- ===========================================
-- 自助服务相关表
-- ===========================================

-- 密码重置申请表
CREATE TABLE `self_service_password_reset` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `ad_user_id` bigint DEFAULT NULL COMMENT 'AD用户ID',
  `request_reason` varchar(200) DEFAULT NULL COMMENT '申请原因',
  `status` tinyint DEFAULT '0' COMMENT '状态：0-待审核，1-已批准，2-已拒绝，3-已完成',
  `approved_by` bigint DEFAULT NULL COMMENT '批准人ID',
  `approved_time` datetime DEFAULT NULL COMMENT '批准时间',
  `approved_reason` varchar(200) DEFAULT NULL COMMENT '批准/拒绝原因',
  `completed_time` datetime DEFAULT NULL COMMENT '完成时间',
  `expires_time` datetime DEFAULT NULL COMMENT '过期时间',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_ad_user_id` (`ad_user_id`),
  KEY `idx_status` (`status`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='密码重置申请表';

-- 账户解锁申请表
CREATE TABLE `self_service_account_unlock` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `ad_user_id` bigint NOT NULL COMMENT 'AD用户ID',
  `request_reason` varchar(200) DEFAULT NULL COMMENT '申请原因',
  `status` tinyint DEFAULT '0' COMMENT '状态：0-待审核，1-已批准，2-已拒绝，3-已完成',
  `approved_by` bigint DEFAULT NULL COMMENT '批准人ID',
  `approved_time` datetime DEFAULT NULL COMMENT '批准时间',
  `approved_reason` varchar(200) DEFAULT NULL COMMENT '批准/拒绝原因',
  `completed_time` datetime DEFAULT NULL COMMENT '完成时间',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_ad_user_id` (`ad_user_id`),
  KEY `idx_status` (`status`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='账户解锁申请表';

-- ===========================================
-- 审计相关表
-- ===========================================

-- 操作日志表
CREATE TABLE `audit_operation_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint DEFAULT NULL COMMENT '操作用户ID',
  `username` varchar(50) DEFAULT NULL COMMENT '操作用户名',
  `operation_type` varchar(50) NOT NULL COMMENT '操作类型',
  `operation_name` varchar(100) NOT NULL COMMENT '操作名称',
  `request_method` varchar(10) DEFAULT NULL COMMENT '请求方法',
  `request_url` varchar(500) DEFAULT NULL COMMENT '请求URL',
  `request_params` text COMMENT '请求参数',
  `response_result` text COMMENT '响应结果',
  `operation_status` tinyint DEFAULT '1' COMMENT '操作状态：0-失败，1-成功',
  `error_message` text COMMENT '错误信息',
  `ip_address` varchar(50) DEFAULT NULL COMMENT 'IP地址',
  `user_agent` varchar(500) DEFAULT NULL COMMENT '用户代理',
  `execution_time` bigint DEFAULT NULL COMMENT '执行时间(毫秒)',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_operation_type` (`operation_type`),
  KEY `idx_operation_status` (`operation_status`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='操作日志表';

-- AD变更日志表
CREATE TABLE `audit_ad_change_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '操作用户ID',
  `ad_user_id` bigint DEFAULT NULL COMMENT 'AD用户ID',
  `change_type` varchar(50) NOT NULL COMMENT '变更类型：CREATE, UPDATE, DELETE, PASSWORD_RESET, ACCOUNT_UNLOCK等',
  `object_type` varchar(50) NOT NULL COMMENT '对象类型：USER, GROUP等',
  `object_dn` varchar(500) DEFAULT NULL COMMENT '对象DN',
  `old_value` text COMMENT '旧值',
  `new_value` text COMMENT '新值',
  `change_reason` varchar(200) DEFAULT NULL COMMENT '变更原因',
  `change_status` tinyint DEFAULT '1' COMMENT '变更状态：0-失败，1-成功',
  `error_message` text COMMENT '错误信息',
  `ip_address` varchar(50) DEFAULT NULL COMMENT 'IP地址',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_ad_user_id` (`ad_user_id`),
  KEY `idx_change_type` (`change_type`),
  KEY `idx_object_type` (`object_type`),
  KEY `idx_change_status` (`change_status`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AD变更日志表';

-- 登录日志表
CREATE TABLE `audit_login_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `username` varchar(50) DEFAULT NULL COMMENT '用户名',
  `login_type` varchar(20) NOT NULL COMMENT '登录类型：LOGIN, LOGOUT',
  `login_status` tinyint NOT NULL COMMENT '登录状态：0-失败，1-成功',
  `ip_address` varchar(50) DEFAULT NULL COMMENT 'IP地址',
  `user_agent` varchar(500) DEFAULT NULL COMMENT '用户代理',
  `login_location` varchar(100) DEFAULT NULL COMMENT '登录地点',
  `failure_reason` varchar(200) DEFAULT NULL COMMENT '失败原因',
  `session_id` varchar(100) DEFAULT NULL COMMENT '会话ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_username` (`username`),
  KEY `idx_login_type` (`login_type`),
  KEY `idx_login_status` (`login_status`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='登录日志表';

-- ===========================================
-- 系统配置相关表
-- ===========================================

-- 系统配置表
CREATE TABLE `sys_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `config_key` varchar(100) NOT NULL COMMENT '配置键',
  `config_value` text COMMENT '配置值',
  `config_type` varchar(20) DEFAULT 'string' COMMENT '配置类型：string, number, boolean, json',
  `description` varchar(200) DEFAULT NULL COMMENT '描述',
  `is_system` tinyint DEFAULT '0' COMMENT '是否系统配置：0-否，1-是',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_config_key` (`config_key`),
  KEY `idx_is_system` (`is_system`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统配置表';

-- 定时任务表
CREATE TABLE `sys_scheduled_task` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `task_name` varchar(100) NOT NULL COMMENT '任务名称',
  `task_code` varchar(100) NOT NULL COMMENT '任务编码',
  `cron_expression` varchar(100) NOT NULL COMMENT 'Cron表达式',
  `task_class` varchar(200) NOT NULL COMMENT '任务类名',
  `task_method` varchar(100) NOT NULL COMMENT '任务方法名',
  `task_params` varchar(500) DEFAULT NULL COMMENT '任务参数',
  `status` tinyint DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
  `description` varchar(200) DEFAULT NULL COMMENT '描述',
  `last_execution_time` datetime DEFAULT NULL COMMENT '最后执行时间',
  `next_execution_time` datetime DEFAULT NULL COMMENT '下次执行时间',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_task_code` (`task_code`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='定时任务表';

-- ===========================================
-- 初始化基础数据
-- ===========================================

-- 插入默认管理员用户
INSERT INTO `sys_user` (`username`, `password`, `real_name`, `email`, `status`, `create_by`) VALUES
('admin', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '系统管理员', 'admin@admanagement.com', 1, 'system');

-- 插入默认角色
INSERT INTO `sys_role` (`role_code`, `role_name`, `description`, `status`, `create_by`) VALUES
('SUPER_ADMIN', '超级管理员', '拥有系统所有权限', 1, 'system'),
('ADMIN', '管理员', '拥有管理权限', 1, 'system'),
('USER', '普通用户', '普通用户权限', 1, 'system');

-- 插入用户角色关联
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES
(1, 1);

-- 插入基础权限
INSERT INTO `sys_permission` (`permission_code`, `permission_name`, `description`, `type`, `parent_id`, `path`, `component`, `icon`, `sort_order`, `status`) VALUES
('system', '系统管理', '系统管理模块', 1, 0, '/system', 'Layout', 'setting', 1, 1),
('system:user', '用户管理', '用户管理功能', 1, 1, 'user', 'system/user/index', 'user', 1, 1),
('system:role', '角色管理', '角色管理功能', 1, 1, 'role', 'system/role/index', 'role', 2, 1),
('system:permission', '权限管理', '权限管理功能', 1, 1, 'permission', 'system/permission/index', 'permission', 3, 1),
('ad', 'AD管理', 'AD管理模块', 1, 0, '/ad', 'Layout', 'domain', 2, 1),
('ad:user', 'AD用户管理', 'AD用户管理功能', 1, 5, 'user', 'ad/user/index', 'user', 1, 1),
('ad:group', 'AD组管理', 'AD组管理功能', 1, 5, 'group', 'ad/group/index', 'group', 2, 1),
('self-service', '自助服务', '自助服务模块', 1, 0, '/self-service', 'Layout', 'service', 3, 1),
('self-service:password', '密码重置', '密码重置服务', 1, 8, 'password', 'self-service/password/index', 'password', 1, 1),
('audit', '审计管理', '审计管理模块', 1, 0, '/audit', 'Layout', 'audit', 4, 1),
('audit:operation', '操作日志', '操作日志查看', 1, 11, 'operation', 'audit/operation/index', 'log', 1, 1),
('audit:ad-change', 'AD变更日志', 'AD变更日志查看', 1, 11, 'ad-change', 'audit/ad-change/index', 'change', 2, 1);

-- 插入角色权限关联（超级管理员拥有所有权限）
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`)
SELECT 1, id FROM `sys_permission` WHERE `status` = 1;

-- 插入基础系统配置
INSERT INTO `sys_config` (`config_key`, `config_value`, `config_type`, `description`, `is_system`) VALUES
('system.name', 'AD Management System', 'string', '系统名称', 1),
('system.version', '1.0.0', 'string', '系统版本', 1),
('system.language', 'zh-CN', 'string', '系统语言', 1),
('password.policy.min_length', '8', 'number', '密码最小长度', 0),
('password.policy.require_uppercase', 'true', 'boolean', '密码要求大写字母', 0),
('password.policy.require_lowercase', 'true', 'boolean', '密码要求小写字母', 0),
('password.policy.require_numbers', 'true', 'boolean', '密码要求数字', 0),
('password.policy.require_special_chars', 'true', 'boolean', '密码要求特殊字符', 0),
('ad.sync.interval', '3600000', 'number', 'AD同步间隔(毫秒)', 0),
('audit.retention.days', '365', 'number', '审计日志保留天数', 0);

-- 恢复外键检查
SET FOREIGN_KEY_CHECKS = 1;

-- 创建索引优化查询性能
CREATE INDEX idx_ad_user_sync_time ON ad_user(sync_time);
CREATE INDEX idx_audit_operation_create_time ON audit_operation_log(create_time);
CREATE INDEX idx_audit_login_create_time ON audit_login_log(create_time);
CREATE INDEX idx_audit_ad_change_create_time ON audit_ad_change_log(create_time);

