package com.admanagement.repository;

import com.admanagement.entity.SysAdmin;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 管理员Mapper接口
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Mapper
public interface SysAdminMapper extends BaseMapper<SysAdmin> {
    
    /**
     * 根据用户名查询管理员（包含角色信息）
     * 
     * @param username 用户名
     * @return 管理员信息
     */
    SysAdmin selectByUsername(@Param("username") String username);
    
    /**
     * 查询管理员的所有角色ID
     * 
     * @param adminId 管理员ID
     * @return 角色ID列表
     */
    List<Long> selectRoleIdsByAdminId(@Param("adminId") Long adminId);
    
    /**
     * 查询管理员的所有角色编码
     * 
     * @param adminId 管理员ID
     * @return 角色编码列表
     */
    List<String> selectRoleCodesByAdminId(@Param("adminId") Long adminId);
}

