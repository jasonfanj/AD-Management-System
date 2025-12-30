package com.admanagement.service.impl;

import com.admanagement.entity.vo.AdOuVO;
import com.admanagement.service.AdOuService;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * OU服务实现类（模拟数据，后续替换为真实AD对接）
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Service
public class AdOuServiceImpl implements AdOuService {
    
    @Override
    public List<AdOuVO> getOuList() {
        // 模拟OU数据（后续替换为真实AD对接）
        List<AdOuVO> ouList = new ArrayList<>();
        
        // 根OU
        AdOuVO rootOu = new AdOuVO();
        rootOu.setDn("OU=Users,DC=example,DC=com");
        rootOu.setName("Users");
        rootOu.setDescription("用户组织单元");
        rootOu.setPath("DC=example,DC=com > Users");
        rootOu.setUserCount(100);
        rootOu.setGroupCount(20);
        
        // 子OU
        List<AdOuVO> children = new ArrayList<>();
        
        AdOuVO itOu = new AdOuVO();
        itOu.setDn("OU=IT,OU=Users,DC=example,DC=com");
        itOu.setName("IT");
        itOu.setDescription("IT部门");
        itOu.setPath("DC=example,DC=com > Users > IT");
        itOu.setUserCount(30);
        itOu.setGroupCount(5);
        children.add(itOu);
        
        AdOuVO hrOu = new AdOuVO();
        hrOu.setDn("OU=HR,OU=Users,DC=example,DC=com");
        hrOu.setName("HR");
        hrOu.setDescription("人事部门");
        hrOu.setPath("DC=example,DC=com > Users > HR");
        hrOu.setUserCount(20);
        hrOu.setGroupCount(3);
        children.add(hrOu);
        
        rootOu.setChildren(children);
        ouList.add(rootOu);
        
        return ouList;
    }
    
    @Override
    public AdOuVO getOuByDn(String dn) {
        // 模拟根据DN查询OU（后续替换为真实AD对接）
        AdOuVO ou = new AdOuVO();
        ou.setDn(dn);
        ou.setName(dn.split(",")[0].replace("OU=", ""));
        ou.setDescription("OU描述");
        ou.setUserCount(0);
        ou.setGroupCount(0);
        return ou;
    }
}

