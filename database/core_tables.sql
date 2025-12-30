-- AD Management System - 核心基础表（用户与权限模块）
-- Version: 1.0.0
-- Description: 核心用户权限管理表结构，包含管理员、角色、权限、模块等基础表

-- 使用数据库
USE `ad_management_system`;

-- 设置字符集
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ===========================================
-- 1. 管理员用户表 (sys_admin)
-- ===========================================
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

-- ===========================================
-- 2. 模块表 (sys_module)
-- ===========================================
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

-- ===========================================
-- 3. 权限表 (sys_permission)
-- ===========================================
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

-- ===========================================
-- 4. 角色表 (sys_role)
-- ===========================================
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

-- ===========================================
-- 5. 角色-权限关联表 (sys_role_permission)
-- ===========================================
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

-- ===========================================
-- 6. 管理员-角色关联表 (sys_admin_role)
-- ===========================================
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
-- 恢复外键检查
-- ===========================================
SET FOREIGN_KEY_CHECKS = 1;

-- ===========================================
-- 表关联关系说明
-- ===========================================
/*
表关联关系说明：

1. sys_admin (管理员用户表)
   - 主键：id
   - 与 sys_admin_role 一对多关系（一个管理员可以有多个角色）

2. sys_role (角色表)
   - 主键：id
   - 与 sys_admin_role 一对多关系（一个角色可以分配给多个管理员）
   - 与 sys_role_permission 一对多关系（一个角色可以拥有多个权限）

3. sys_permission (权限表)
   - 主键：id
   - 外键：module_id -> sys_module.id（权限属于某个模块）
   - 与 sys_role_permission 一对多关系（一个权限可以分配给多个角色）
   - 自关联：parent_id -> id（权限树形结构）

4. sys_module (模块表)
   - 主键：id
   - 与 sys_permission 一对多关系（一个模块可以有多个权限）
   - 自关联：parent_id -> id（模块树形结构）

5. sys_admin_role (管理员-角色关联表)
   - 多对多关系：sys_admin <-> sys_role
   - 外键：admin_id -> sys_admin.id
   - 外键：role_id -> sys_role.id
   - 唯一索引：确保一个管理员不能重复分配同一个角色

6. sys_role_permission (角色-权限关联表)
   - 多对多关系：sys_role <-> sys_permission
   - 外键：role_id -> sys_role.id
   - 外键：permission_id -> sys_permission.id
   - 唯一索引：确保一个角色不能重复分配同一个权限

索引优化说明：
- 所有外键字段都已建立索引，提升关联查询效率
- 状态字段、排序字段建立索引，便于条件筛选和排序
- 唯一字段建立唯一索引，保证数据唯一性
- 时间字段建立索引，便于时间范围查询
*/

