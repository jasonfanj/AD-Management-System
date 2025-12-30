package com.admanagement.repository;

import com.admanagement.entity.SysRole;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 角色Mapper接口
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Mapper
public interface SysRoleMapper extends BaseMapper<SysRole> {
    
    /**
     * 根据管理员ID查询角色列表
     * 
     * @param adminId 管理员ID
     * @return 角色列表
     */
    List<SysRole> selectRolesByAdminId(@Param("adminId") Long adminId);
}

