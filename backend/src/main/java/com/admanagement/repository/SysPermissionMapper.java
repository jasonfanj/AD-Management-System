package com.admanagement.repository;

import com.admanagement.entity.SysPermission;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 权限Mapper接口
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Mapper
public interface SysPermissionMapper extends BaseMapper<SysPermission> {
    
    /**
     * 根据管理员ID查询所有权限标识列表
     * 
     * @param adminId 管理员ID
     * @return 权限标识列表
     */
    List<String> selectPermissionCodesByAdminId(@Param("adminId") Long adminId);
    
    /**
     * 根据管理员ID和模块ID查询权限标识列表
     * 
     * @param adminId 管理员ID
     * @param moduleId 模块ID
     * @return 权限标识列表
     */
    List<String> selectPermissionCodesByAdminIdAndModuleId(
        @Param("adminId") Long adminId,
        @Param("moduleId") Long moduleId
    );
    
    /**
     * 根据管理员ID查询按钮权限标识列表
     * 
     * @param adminId 管理员ID
     * @return 按钮权限标识列表
     */
    List<String> selectButtonPermissionCodesByAdminId(@Param("adminId") Long adminId);
}
