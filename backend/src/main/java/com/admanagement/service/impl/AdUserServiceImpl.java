package com.admanagement.service.impl;

import com.admanagement.common.PageResult;
import com.admanagement.entity.AdUser;
import com.admanagement.entity.dto.AdUserQueryDTO;
import com.admanagement.entity.vo.AdUserVO;
import com.admanagement.repository.AdUserMapper;
import com.admanagement.service.AdUserService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * AD用户服务实现类
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Service
public class AdUserServiceImpl implements AdUserService {
    
    @Autowired
    private AdUserMapper adUserMapper;
    
    @Override
    public PageResult<AdUserVO> getAdUserList(AdUserQueryDTO queryDTO) {
        // 保存原始页码
        Integer originalPageNum = queryDTO.getPageNum();
        
        // 计算偏移量并设置到DTO
        queryDTO.setOffset((queryDTO.getPageNum() - 1) * queryDTO.getPageSize());
        
        // 查询总数
        Long total = adUserMapper.countAdUserList(queryDTO);
        
        // 查询列表
        List<AdUser> adUsers = adUserMapper.selectAdUserList(queryDTO);
        
        // 转换为VO
        List<AdUserVO> voList = adUsers.stream()
            .map(this::convertToVO)
            .collect(Collectors.toList());
        
        // 构建分页结果（使用原始页码）
        return PageResult.of(
            originalPageNum.longValue(),
            queryDTO.getPageSize().longValue(),
            total,
            voList
        );
    }
    
    @Override
    public List<AdUserVO> previewBatchImport(List<AdUserVO> users) {
        // 批量导入预览（模拟数据验证）
        // 这里可以添加数据验证逻辑，如检查必填字段、格式验证等
        return users;
    }
    
    /**
     * 将AdUser实体转换为AdUserVO
     */
    private AdUserVO convertToVO(AdUser adUser) {
        AdUserVO vo = new AdUserVO();
        BeanUtils.copyProperties(adUser, vo);
        
        // 设置账户状态文本
        if (adUser.getAccountStatus() != null) {
            vo.setAccountStatusText(adUser.getAccountStatus() == 1 ? "启用" : "禁用");
        }
        
        return vo;
    }
}
