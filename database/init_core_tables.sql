-- AD Management System - 核心基础表完整初始化脚本
-- Version: 1.0.0
-- Description: 包含核心表创建和测试数据的完整初始化脚本

-- 使用数据库
USE `ad_management_system`;

-- 设置字符集
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ===========================================
-- 第一部分：创建核心基础表
-- ===========================================

-- 1. 管理员用户表 (sys_admin)
DROP TABLE IF EXISTS `sys_admin`;
CREATE TABLE `sys_admin` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `username` varchar(50) NOT NULL COMMENT '管理员账号（唯一）',
  `password` varchar(255) NOT NULL COMMENT '密码（BCrypt加密存储）',
  `real_name` varchar(50) DEFAULT NULL COMMENT '真实姓名',
  `phone` varchar(20) DEFAULT NULL COMMENT '手机号',
  `email` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `avatar` varchar(255) DEFAULT NULL COMMENT '头像URL',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
  `last_login_time` datetime DEFAULT NULL COMMENT '最后登录时间',
  `last_login_ip` varchar(50) DEFAULT NULL COMMENT '最后登录IP',
  `login_fail_count` int DEFAULT '0' COMMENT '登录失败次数',
  `lock_time` datetime DEFAULT NULL COMMENT '账户锁定时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` bigint DEFAULT NULL COMMENT '创建人ID',
  `update_by` bigint DEFAULT NULL COMMENT '更新人ID',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  UNIQUE KEY `uk_email` (`email`),
  UNIQUE KEY `uk_phone` (`phone`),
  KEY `idx_status` (`status`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_last_login_time` (`last_login_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='管理员用户表';

-- 2. 模块表 (sys_module)
DROP TABLE IF EXISTS `sys_module`;
CREATE TABLE `sys_module` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `module_name` varchar(50) NOT NULL COMMENT '模块名称',
  `module_code` varchar(50) NOT NULL COMMENT '模块标识（唯一，如：ad_manager, self_service, audit）',
  `parent_id` bigint NOT NULL DEFAULT '0' COMMENT '父模块ID（0表示顶级模块）',
  `module_path` varchar(200) DEFAULT NULL COMMENT '模块路径（前端路由路径）',
  `icon` varchar(50) DEFAULT NULL COMMENT '模块图标（Element Plus图标名称或图标类名）',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序号（数字越小越靠前）',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
  `description` varchar(200) DEFAULT NULL COMMENT '模块描述',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_module_code` (`module_code`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_status` (`status`),
  KEY `idx_sort_order` (`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='模块表';

-- 3. 权限表 (sys_permission)
DROP TABLE IF EXISTS `sys_permission`;
CREATE TABLE `sys_permission` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `permission_name` varchar(100) NOT NULL COMMENT '权限名称',
  `permission_code` varchar(100) NOT NULL COMMENT '权限标识（唯一，如：ad:manage:user, ad:manage:group）',
  `module_id` bigint DEFAULT NULL COMMENT '所属模块ID（关联sys_module.id）',
  `permission_type` tinyint NOT NULL COMMENT '权限类型：1-模块，2-按钮/菜单，3-接口/API',
  `parent_id` bigint NOT NULL DEFAULT '0' COMMENT '父权限ID（0表示顶级权限）',
  `api_path` varchar(500) DEFAULT NULL COMMENT 'API路径（权限类型为接口时使用）',
  `http_method` varchar(10) DEFAULT NULL COMMENT 'HTTP方法（GET, POST, PUT, DELETE等）',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序号',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
  `description` varchar(200) DEFAULT NULL COMMENT '权限描述',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_permission_code` (`permission_code`),
  KEY `idx_module_id` (`module_id`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_permission_type` (`permission_type`),
  KEY `idx_status` (`status`),
  KEY `idx_sort_order` (`sort_order`),
  CONSTRAINT `fk_permission_module` FOREIGN KEY (`module_id`) REFERENCES `sys_module` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='权限表';

-- 4. 角色表 (sys_role)
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `role_name` varchar(50) NOT NULL COMMENT '角色名称（如：超级管理员、AD管理模块管理员、审计模块查看员）',
  `role_code` varchar(50) NOT NULL COMMENT '角色编码（唯一，如：super_admin, ad_admin, audit_viewer）',
  `description` varchar(200) DEFAULT NULL COMMENT '角色描述',
  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
  `sort_order` int NOT NULL DEFAULT '0' COMMENT '排序号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_by` bigint DEFAULT NULL COMMENT '创建人ID',
  `update_by` bigint DEFAULT NULL COMMENT '更新人ID',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_code` (`role_code`),
  KEY `idx_status` (`status`),
  KEY `idx_sort_order` (`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色表';

-- 5. 角色-权限关联表 (sys_role_permission)
DROP TABLE IF EXISTS `sys_role_permission`;
CREATE TABLE `sys_role_permission` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `role_id` bigint NOT NULL COMMENT '角色ID（关联sys_role.id）',
  `permission_id` bigint NOT NULL COMMENT '权限ID（关联sys_permission.id）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_permission` (`role_id`, `permission_id`),
  KEY `idx_role_id` (`role_id`),
  KEY `idx_permission_id` (`permission_id`),
  CONSTRAINT `fk_role_permission_role` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_role_permission_permission` FOREIGN KEY (`permission_id`) REFERENCES `sys_permission` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色-权限关联表（多对多）';

-- 6. 管理员-角色关联表 (sys_admin_role)
DROP TABLE IF EXISTS `sys_admin_role`;
CREATE TABLE `sys_admin_role` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `admin_id` bigint NOT NULL COMMENT '管理员ID（关联sys_admin.id）',
  `role_id` bigint NOT NULL COMMENT '角色ID（关联sys_role.id）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_admin_role` (`admin_id`, `role_id`),
  KEY `idx_admin_id` (`admin_id`),
  KEY `idx_role_id` (`role_id`),
  CONSTRAINT `fk_admin_role_admin` FOREIGN KEY (`admin_id`) REFERENCES `sys_admin` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_admin_role_role` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='管理员-角色关联表（多对多）';

-- ===========================================
-- 第二部分：插入测试数据
-- ===========================================

-- 1. 插入模块数据（3个核心模块）
INSERT INTO `sys_module` (`module_name`, `module_code`, `parent_id`, `module_path`, `icon`, `sort_order`, `status`, `description`) VALUES
('AD管理', 'ad_manager', 0, '/ad-manager', 'Document', 1, 1, 'Active Directory域管理核心模块，包含用户管理、组管理、OU管理等子功能'),
('自助服务', 'self_service', 0, '/self-service', 'Service', 2, 1, '用户自助服务模块，包含密码重置、账户解锁、个人信息管理等功能'),
('审计管理', 'audit', 0, '/audit', 'Document', 3, 1, '系统审计管理模块，包含操作日志、AD变更日志、登录日志等审计功能');

-- 2. 插入权限数据（10个基础权限）
-- AD管理模块权限
INSERT INTO `sys_permission` (`permission_name`, `permission_code`, `module_id`, `permission_type`, `parent_id`, `api_path`, `http_method`, `sort_order`, `status`, `description`)
SELECT 'AD用户管理', 'ad:manage:user', id, 2, 0, '/api/ad/users', 'GET,POST,PUT,DELETE', 1, 1, 'AD用户管理权限，包含查看、新增、修改、删除AD用户'
FROM sys_module WHERE module_code = 'ad_manager';

INSERT INTO `sys_permission` (`permission_name`, `permission_code`, `module_id`, `permission_type`, `parent_id`, `api_path`, `http_method`, `sort_order`, `status`, `description`)
SELECT 'AD组管理', 'ad:manage:group', id, 2, 0, '/api/ad/groups', 'GET,POST,PUT,DELETE', 2, 1, 'AD组管理权限，包含查看、新增、修改、删除AD组'
FROM sys_module WHERE module_code = 'ad_manager';

INSERT INTO `sys_permission` (`permission_name`, `permission_code`, `module_id`, `permission_type`, `parent_id`, `api_path`, `http_method`, `sort_order`, `status`, `description`)
SELECT 'AD OU管理', 'ad:manage:ou', id, 2, 0, '/api/ad/ous', 'GET,POST,PUT,DELETE', 3, 1, 'AD组织单元管理权限，包含查看、新增、修改、删除OU'
FROM sys_module WHERE module_code = 'ad_manager';

INSERT INTO `sys_permission` (`permission_name`, `permission_code`, `module_id`, `permission_type`, `parent_id`, `api_path`, `http_method`, `sort_order`, `status`, `description`)
SELECT 'AD同步', 'ad:sync', id, 3, 0, '/api/ad/sync', 'POST', 4, 1, 'AD数据同步接口权限'
FROM sys_module WHERE module_code = 'ad_manager';

-- 自助服务模块权限
INSERT INTO `sys_permission` (`permission_name`, `permission_code`, `module_id`, `permission_type`, `parent_id`, `api_path`, `http_method`, `sort_order`, `status`, `description`)
SELECT '密码重置申请', 'self_service:password:request', id, 3, 0, '/api/self-service/password/reset', 'POST', 1, 1, '申请密码重置权限'
FROM sys_module WHERE module_code = 'self_service';

INSERT INTO `sys_permission` (`permission_name`, `permission_code`, `module_id`, `permission_type`, `parent_id`, `api_path`, `http_method`, `sort_order`, `status`, `description`)
SELECT '账户解锁申请', 'self_service:account:unlock', id, 3, 0, '/api/self-service/account/unlock', 'POST', 2, 1, '申请账户解锁权限'
FROM sys_module WHERE module_code = 'self_service';

INSERT INTO `sys_permission` (`permission_name`, `permission_code`, `module_id`, `permission_type`, `parent_id`, `api_path`, `http_method`, `sort_order`, `status`, `description`)
SELECT '申请审批', 'self_service:approve', id, 3, 0, '/api/self-service/approve', 'POST', 3, 1, '审批自助服务申请权限'
FROM sys_module WHERE module_code = 'self_service';

-- 审计管理模块权限
INSERT INTO `sys_permission` (`permission_name`, `permission_code`, `module_id`, `permission_type`, `parent_id`, `api_path`, `http_method`, `sort_order`, `status`, `description`)
SELECT '操作日志查看', 'audit:operation:view', id, 3, 0, '/api/audit/operation-logs', 'GET', 1, 1, '查看系统操作日志权限'
FROM sys_module WHERE module_code = 'audit';

INSERT INTO `sys_permission` (`permission_name`, `permission_code`, `module_id`, `permission_type`, `parent_id`, `api_path`, `http_method`, `sort_order`, `status`, `description`)
SELECT 'AD变更日志查看', 'audit:ad-change:view', id, 3, 0, '/api/audit/ad-change-logs', 'GET', 2, 1, '查看AD变更日志权限'
FROM sys_module WHERE module_code = 'audit';

INSERT INTO `sys_permission` (`permission_name`, `permission_code`, `module_id`, `permission_type`, `parent_id`, `api_path`, `http_method`, `sort_order`, `status`, `description`)
SELECT '登录日志查看', 'audit:login:view', id, 3, 0, '/api/audit/login-logs', 'GET', 3, 1, '查看登录日志权限'
FROM sys_module WHERE module_code = 'audit';

-- 3. 插入角色数据（3个角色）
INSERT INTO `sys_role` (`role_name`, `role_code`, `description`, `status`, `sort_order`) VALUES
('超级管理员', 'super_admin', '拥有系统所有权限，包括AD管理、自助服务、审计管理等所有模块的完整权限', 1, 1),
('AD管理模块管理员', 'ad_admin', '拥有AD管理模块的所有权限，包括用户管理、组管理、OU管理等，以及相关的查看权限', 1, 2),
('审计模块查看员', 'audit_viewer', '仅拥有审计管理模块的查看权限，可以查看操作日志、AD变更日志、登录日志等', 1, 3);

-- 4. 插入管理员数据（5个管理员）
-- 注意：密码使用BCrypt加密，示例密码均为：Admin@123456
-- 实际使用时，请在应用层使用BCryptPasswordEncoder进行密码加密
INSERT INTO `sys_admin` (`username`, `password`, `real_name`, `phone`, `email`, `status`, `create_by`) VALUES
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iwK8pJLu', '超级管理员', '13800138000', 'admin@admanagement.com', 1, 1),
('admanager', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iwK8pJLu', 'AD管理员', '13800138001', 'admanager@admanagement.com', 1, 1),
('auditor1', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iwK8pJLu', '审计员张三', '13800138002', 'auditor1@admanagement.com', 1, 1),
('auditor2', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iwK8pJLu', '审计员李四', '13800138003', 'auditor2@admanagement.com', 1, 1),
('testuser', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iwK8pJLu', '测试用户', '13800138004', 'testuser@admanagement.com', 1, 1);

-- 5. 插入角色-权限关联数据
-- 超级管理员：拥有所有权限（权限ID 1-10）
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES
(1, 1), (1, 2), (1, 3), (1, 4),  -- AD管理权限
(1, 5), (1, 6), (1, 7),           -- 自助服务权限
(1, 8), (1, 9), (1, 10);          -- 审计管理权限

-- AD管理模块管理员：拥有AD管理权限和审计查看权限
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES
(2, 1), (2, 2), (2, 3), (2, 4),  -- AD管理权限
(2, 8), (2, 9), (2, 10);         -- 审计查看权限

-- 审计模块查看员：仅拥有审计查看权限
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES
(3, 8), (3, 9), (3, 10);          -- 审计查看权限

-- 6. 插入管理员-角色关联数据
INSERT INTO `sys_admin_role` (`admin_id`, `role_id`) VALUES
(1, 1),                           -- admin：超级管理员
(2, 2),                           -- admanager：AD管理模块管理员
(3, 3),                           -- auditor1：审计模块查看员
(4, 3),                           -- auditor2：审计模块查看员
(5, 3);                           -- testuser：审计模块查看员（测试用途）

-- ===========================================
-- 恢复外键检查
-- ===========================================
SET FOREIGN_KEY_CHECKS = 1;

-- ===========================================
-- 初始化完成提示
-- ===========================================
SELECT '核心基础表初始化完成！' AS message;
SELECT '已创建 6 张核心表' AS tables_created;
SELECT '已插入 3 个模块、10 个权限、3 个角色、5 个管理员' AS test_data_inserted;
SELECT '默认管理员账户: admin / Admin@123456' AS default_account;
SELECT '请及时修改默认密码！' AS security_reminder;

