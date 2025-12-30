-- AD Management System - 核心基础表测试数据
-- Version: 1.0.0
-- Description: 插入测试数据，包含3个角色、5个管理员、10个基础权限、3个核心模块

-- 使用数据库
USE `ad_management_system`;

-- 设置字符集
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ===========================================
-- 1. 插入模块数据（3个核心模块）
-- ===========================================
INSERT INTO `sys_module` (`module_name`, `module_code`, `parent_id`, `module_path`, `icon`, `sort_order`, `status`, `description`) VALUES
('AD管理', 'ad_manager', 0, '/ad-manager', 'Document', 1, 1, 'Active Directory域管理核心模块，包含用户管理、组管理、OU管理等子功能'),
('自助服务', 'self_service', 0, '/self-service', 'Service', 2, 1, '用户自助服务模块，包含密码重置、账户解锁、个人信息管理等功能'),
('审计管理', 'audit', 0, '/audit', 'Document', 3, 1, '系统审计管理模块，包含操作日志、AD变更日志、登录日志等审计功能');

-- ===========================================
-- 2. 插入权限数据（10个基础权限）
-- ===========================================

-- AD管理模块权限（使用子查询获取模块ID）
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

-- ===========================================
-- 3. 插入角色数据（3个角色）
-- ===========================================
INSERT INTO `sys_role` (`role_name`, `role_code`, `description`, `status`, `sort_order`) VALUES
('超级管理员', 'super_admin', '拥有系统所有权限，包括AD管理、自助服务、审计管理等所有模块的完整权限', 1, 1),
('AD管理模块管理员', 'ad_admin', '拥有AD管理模块的所有权限，包括用户管理、组管理、OU管理等，以及相关的查看权限', 1, 2),
('审计模块查看员', 'audit_viewer', '仅拥有审计管理模块的查看权限，可以查看操作日志、AD变更日志、登录日志等', 1, 3);

-- ===========================================
-- 4. 插入管理员数据（5个管理员）
-- 注意：密码使用BCrypt加密，这里使用示例加密字符串（实际应用中应使用真实加密）
-- 示例密码均为：Admin@123456 （BCrypt加密后的值）
-- ===========================================
INSERT INTO `sys_admin` (`username`, `password`, `real_name`, `phone`, `email`, `status`, `create_by`) VALUES
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iwK8pJLu', '超级管理员', '13800138000', 'admin@admanagement.com', 1, 1),
('admanager', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iwK8pJLu', 'AD管理员', '13800138001', 'admanager@admanagement.com', 1, 1),
('auditor1', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iwK8pJLu', '审计员张三', '13800138002', 'auditor1@admanagement.com', 1, 1),
('auditor2', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iwK8pJLu', '审计员李四', '13800138003', 'auditor2@admanagement.com', 1, 1),
('testuser', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iwK8pJLu', '测试用户', '13800138004', 'testuser@admanagement.com', 1, 1);

-- ===========================================
-- 5. 插入角色-权限关联数据
-- ===========================================
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

-- ===========================================
-- 6. 插入管理员-角色关联数据
-- ===========================================
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
-- 数据验证查询
-- ===========================================
-- 查询所有模块
-- SELECT * FROM sys_module ORDER BY sort_order;

-- 查询所有权限
-- SELECT p.*, m.module_name FROM sys_permission p LEFT JOIN sys_module m ON p.module_id = m.id ORDER BY p.sort_order;

-- 查询所有角色及其权限
-- SELECT r.role_name, p.permission_name, p.permission_code 
-- FROM sys_role r
-- LEFT JOIN sys_role_permission rp ON r.id = rp.role_id
-- LEFT JOIN sys_permission p ON rp.permission_id = p.id
-- ORDER BY r.id, p.sort_order;

-- 查询所有管理员及其角色
-- SELECT a.username, a.real_name, r.role_name, r.role_code
-- FROM sys_admin a
-- LEFT JOIN sys_admin_role ar ON a.id = ar.admin_id
-- LEFT JOIN sys_role r ON ar.role_id = r.id
-- ORDER BY a.id, r.sort_order;

-- 查询某个管理员的所有权限（通过角色关联）
-- SELECT DISTINCT p.permission_code, p.permission_name
-- FROM sys_admin a
-- JOIN sys_admin_role ar ON a.id = ar.admin_id
-- JOIN sys_role_permission rp ON ar.role_id = rp.role_id
-- JOIN sys_permission p ON rp.permission_id = p.id
-- WHERE a.username = 'admin'
-- ORDER BY p.sort_order;
