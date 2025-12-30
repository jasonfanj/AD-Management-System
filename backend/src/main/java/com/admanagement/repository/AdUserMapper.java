package com.admanagement.repository;

import com.admanagement.entity.AdUser;
import com.admanagement.entity.dto.AdUserQueryDTO;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * AD用户Mapper接口
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Mapper
public interface AdUserMapper extends BaseMapper<AdUser> {
    
    /**
     * 分页查询AD用户列表
     * 
     * @param queryDTO 查询条件
     * @return AD用户列表
     */
    List<AdUser> selectAdUserList(@Param("query") AdUserQueryDTO queryDTO);
    
    /**
     * 统计AD用户数量
     * 
     * @param queryDTO 查询条件
     * @return 数量
     */
    Long countAdUserList(@Param("query") AdUserQueryDTO queryDTO);
}

