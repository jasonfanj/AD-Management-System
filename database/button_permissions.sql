-- 按钮级权限测试数据
-- Version: 1.0.0
-- Description: 添加按钮级权限到权限表

USE `ad_management_system`;

-- 获取AD管理模块ID
SET @module_id_ad = (SELECT id FROM sys_module WHERE module_code = 'ad_manager' LIMIT 1);
-- 获取自助服务模块ID
SET @module_id_self = (SELECT id FROM sys_module WHERE module_code = 'self_service' LIMIT 1);
-- 获取审计模块ID
SET @module_id_audit = (SELECT id FROM sys_module WHERE module_code = 'audit' LIMIT 1);

-- ===========================================
-- AD管理模块按钮权限
-- ===========================================
-- AD用户管理按钮权限
INSERT INTO `sys_permission` (`permission_name`, `permission_code`, `module_id`, `permission_type`, `parent_id`, `sort_order`, `api_path`, `http_method`, `status`, `create_time`, `description`) VALUES
('AD用户查看', 'ad:manage:user:view', @module_id_ad, 2, (SELECT id FROM sys_permission WHERE permission_code = 'ad:manage:user' LIMIT 1), 1, '/api/ad-manage/users/list', 'GET', 1, NOW(), 'AD用户列表查看权限'),
('AD用户新增', 'ad:manage:user:add', @module_id_ad, 2, (SELECT id FROM sys_permission WHERE permission_code = 'ad:manage:user' LIMIT 1), 2, '/api/ad-manage/users', 'POST', 1, NOW(), 'AD用户新增权限'),
('AD用户编辑', 'ad:manage:user:edit', @module_id_ad, 2, (SELECT id FROM sys_permission WHERE permission_code = 'ad:manage:user' LIMIT 1), 3, '/api/ad-manage/users/{id}', 'PUT', 1, NOW(), 'AD用户编辑权限'),
('AD用户删除', 'ad:manage:user:delete', @module_id_ad, 2, (SELECT id FROM sys_permission WHERE permission_code = 'ad:manage:user' LIMIT 1), 4, '/api/ad-manage/users/{id}', 'DELETE', 1, NOW(), 'AD用户删除权限');

-- AD组管理按钮权限（如果存在）
INSERT INTO `sys_permission` (`permission_name`, `permission_code`, `module_id`, `permission_type`, `parent_id`, `sort_order`, `api_path`, `http_method`, `status`, `create_time`, `description`) VALUES
('AD组查看', 'ad:manage:group:view', @module_id_ad, 2, (SELECT id FROM sys_permission WHERE permission_code = 'ad:manage:group' LIMIT 1), 1, '/api/ad-manage/groups/list', 'GET', 1, NOW(), 'AD组列表查看权限'),
('AD组新增', 'ad:manage:group:add', @module_id_ad, 2, (SELECT id FROM sys_permission WHERE permission_code = 'ad:manage:group' LIMIT 1), 2, '/api/ad-manage/groups', 'POST', 1, NOW(), 'AD组新增权限'),
('AD组编辑', 'ad:manage:group:edit', @module_id_ad, 2, (SELECT id FROM sys_permission WHERE permission_code = 'ad:manage:group' LIMIT 1), 3, '/api/ad-manage/groups/{id}', 'PUT', 1, NOW(), 'AD组编辑权限'),
('AD组删除', 'ad:manage:group:delete', @module_id_ad, 2, (SELECT id FROM sys_permission WHERE permission_code = 'ad:manage:group' LIMIT 1), 4, '/api/ad-manage/groups/{id}', 'DELETE', 1, NOW(), 'AD组删除权限');

-- OU管理按钮权限
INSERT INTO `sys_permission` (`permission_name`, `permission_code`, `module_id`, `permission_type`, `parent_id`, `sort_order`, `api_path`, `http_method`, `status`, `create_time`, `description`) VALUES
('OU查看', 'ad:manage:ou:view', @module_id_ad, 2, (SELECT id FROM sys_permission WHERE permission_code = 'ad:manage:ou' LIMIT 1), 1, '/api/ad-manage/ous/list', 'GET', 1, NOW(), 'OU列表查看权限'),
('OU新增', 'ad:manage:ou:add', @module_id_ad, 2, (SELECT id FROM sys_permission WHERE permission_code = 'ad:manage:ou' LIMIT 1), 2, '/api/ad-manage/ous', 'POST', 1, NOW(), 'OU新增权限'),
('OU编辑', 'ad:manage:ou:edit', @module_id_ad, 2, (SELECT id FROM sys_permission WHERE permission_code = 'ad:manage:ou' LIMIT 1), 3, '/api/ad-manage/ous/{id}', 'PUT', 1, NOW(), 'OU编辑权限'),
('OU删除', 'ad:manage:ou:delete', @module_id_ad, 2, (SELECT id FROM sys_permission WHERE permission_code = 'ad:manage:ou' LIMIT 1), 4, '/api/ad-manage/ous/{id}', 'DELETE', 1, NOW(), 'OU删除权限');

-- ===========================================
-- 自助服务模块按钮权限
-- ===========================================
INSERT INTO `sys_permission` (`permission_name`, `permission_code`, `module_id`, `permission_type`, `parent_id`, `sort_order`, `api_path`, `http_method`, `status`, `create_time`, `description`) VALUES
('个人信息查看', 'self:info:view', @module_id_self, 2, (SELECT id FROM sys_permission WHERE permission_code LIKE 'self_service:%' LIMIT 1), 1, '/api/ad-self/info', 'GET', 1, NOW(), '个人信息查看权限'),
('个人信息编辑', 'self:info:edit', @module_id_self, 2, (SELECT id FROM sys_permission WHERE permission_code LIKE 'self_service:%' LIMIT 1), 2, '/api/ad-self/info', 'PUT', 1, NOW(), '个人信息编辑权限'),
('密码重置', 'self:password:reset', @module_id_self, 2, (SELECT id FROM sys_permission WHERE permission_code LIKE 'self_service:%' LIMIT 1), 3, '/api/ad-self/password/reset', 'POST', 1, NOW(), '密码重置权限');

-- ===========================================
-- 审计模块按钮权限
-- ===========================================
INSERT INTO `sys_permission` (`permission_name`, `permission_code`, `module_id`, `permission_type`, `parent_id`, `sort_order`, `api_path`, `http_method`, `status`, `create_time`, `description`) VALUES
('审计日志查看', 'audit:log:view', @module_id_audit, 2, (SELECT id FROM sys_permission WHERE permission_code LIKE 'audit:%' LIMIT 1), 1, '/api/ad-audit/logs/list', 'GET', 1, NOW(), '审计日志查看权限'),
('审计日志导出', 'audit:log:export', @module_id_audit, 2, (SELECT id FROM sys_permission WHERE permission_code LIKE 'audit:%' LIMIT 1), 2, '/api/ad-audit/logs/export', 'GET', 1, NOW(), '审计日志导出权限');

-- ===========================================
-- ===========================================
-- 将按钮权限分配给角色
-- ===========================================
-- 超级管理员：所有权限
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`)
SELECT 1, id FROM sys_permission WHERE permission_type = 2 AND status = 1;

-- AD管理员：AD管理相关按钮权限
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`)
SELECT 2, id FROM sys_permission 
WHERE permission_type = 2 
AND permission_code LIKE 'ad:manage:%'
AND status = 1;

-- 审计查看员：审计日志查看和导出权限
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`)
SELECT 3, id FROM sys_permission 
WHERE permission_type = 2 
AND permission_code IN ('audit:log:view', 'audit:log:export')
AND status = 1;
