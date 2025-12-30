package com.admanagement.service;

import com.admanagement.entity.vo.AdOuVO;

import java.util.List;

/**
 * OU服务接口
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
public interface AdOuService {
    
    /**
     * 查询OU列表（树形结构）
     * 
     * @return OU列表
     */
    List<AdOuVO> getOuList();
    
    /**
     * 根据DN查询OU信息
     * 
     * @param dn OU的DN
     * @return OU信息
     */
    AdOuVO getOuByDn(String dn);
}

