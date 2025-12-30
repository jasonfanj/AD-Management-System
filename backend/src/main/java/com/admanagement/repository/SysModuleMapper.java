package com.admanagement.repository;

import com.admanagement.entity.SysModule;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 模块Mapper接口
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Mapper
public interface SysModuleMapper extends BaseMapper<SysModule> {
    
    /**
     * 根据管理员ID查询有权限访问的模块列表（只返回启用状态的模块）
     * 
     * @param adminId 管理员ID
     * @return 模块列表
     */
    List<SysModule> selectModulesByAdminId(@Param("adminId") Long adminId);
    
    /**
     * 根据模块标识查询模块信息
     * 
     * @param moduleCode 模块标识
     * @return 模块信息
     */
    SysModule selectByModuleCode(@Param("moduleCode") String moduleCode);
    
    /**
     * 根据父模块ID查询子模块列表（只返回启用状态的模块）
     * 
     * @param parentId 父模块ID
     * @return 子模块列表
     */
    List<SysModule> selectChildrenByParentId(@Param("parentId") Long parentId);
}

