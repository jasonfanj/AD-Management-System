package com.admanagement.service;

import com.admanagement.common.PageResult;
import com.admanagement.entity.dto.AdUserQueryDTO;
import com.admanagement.entity.vo.AdUserVO;

import java.util.List;

/**
 * AD用户服务接口
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
public interface AdUserService {
    
    /**
     * 分页查询AD用户列表
     * 
     * @param queryDTO 查询条件
     * @return 分页结果
     */
    PageResult<AdUserVO> getAdUserList(AdUserQueryDTO queryDTO);
    
    /**
     * 批量导入预览（模拟数据）
     * 
     * @param users 用户数据
     * @return 预览结果
     */
    List<AdUserVO> previewBatchImport(List<AdUserVO> users);
}

