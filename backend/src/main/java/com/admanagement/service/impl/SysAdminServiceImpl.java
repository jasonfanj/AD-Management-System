package com.admanagement.service.impl;

import com.admanagement.common.AdminContext;
import com.admanagement.entity.SysAdmin;
import com.admanagement.entity.SysRole;
import com.admanagement.entity.dto.LoginDTO;
import com.admanagement.entity.vo.LoginVO;
import com.admanagement.repository.SysAdminMapper;
import com.admanagement.repository.SysRoleMapper;
import com.admanagement.service.SysAdminService;
import com.admanagement.utils.JwtUtil;
import com.admanagement.utils.RedisUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 管理员服务实现类
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Service
@Transactional(rollbackFor = Exception.class)
public class SysAdminServiceImpl implements SysAdminService {
    
    @Autowired
    private SysAdminMapper sysAdminMapper;
    
    @Autowired
    private SysRoleMapper sysRoleMapper;
    
    @Autowired
    private JwtUtil jwtUtil;
    
    @Autowired
    private RedisUtil redisUtil;
    
    @Autowired
    private BCryptPasswordEncoder passwordEncoder;
    
    @Override
    public LoginVO login(LoginDTO loginDTO) {
        String username = loginDTO.getUsername();
        String password = loginDTO.getPassword();
        
        // 1. 查询管理员信息
        LambdaQueryWrapper<SysAdmin> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysAdmin::getUsername, username);
        SysAdmin admin = sysAdminMapper.selectOne(wrapper);
        
        // 2. 校验账号是否存在
        if (admin == null) {
            throw new RuntimeException("账号不存在");
        }
        
        // 3. 校验账号是否启用
        if (admin.getStatus() == null || admin.getStatus() != 1) {
            throw new RuntimeException("账号已被禁用，请联系管理员");
        }
        
        // 4. 校验密码（BCrypt加密比对）
        if (!passwordEncoder.matches(password, admin.getPassword())) {
            // 密码错误，记录失败次数
            int failCount = (admin.getLoginFailCount() == null ? 0 : admin.getLoginFailCount()) + 1;
            admin.setLoginFailCount(failCount);
            sysAdminMapper.updateById(admin);
            throw new RuntimeException("账号或密码错误");
        }
        
        // 5. 查询角色信息
        List<Long> roleIds = sysAdminMapper.selectRoleIdsByAdminId(admin.getId());
        List<String> roleCodes = sysAdminMapper.selectRoleCodesByAdminId(admin.getId());
        List<SysRole> roleList = sysRoleMapper.selectRolesByAdminId(admin.getId());
        
        // 6. 生成JWT Token（包含管理员ID、账号、角色信息，过期时间2小时）
        String token = jwtUtil.generateToken(admin.getId(), admin.getUsername(), roleIds, roleCodes);
        
        // 7. 更新登录信息
        admin.setLastLoginTime(LocalDateTime.now());
        admin.setLoginFailCount(0);
        sysAdminMapper.updateById(admin);
        
        // 8. 构建返回结果
        LoginVO loginVO = new LoginVO();
        loginVO.setToken(token);
        
        // 管理员基本信息
        LoginVO.AdminInfo adminInfo = new LoginVO.AdminInfo();
        adminInfo.setId(admin.getId());
        adminInfo.setUsername(admin.getUsername());
        adminInfo.setRealName(admin.getRealName());
        adminInfo.setPhone(admin.getPhone());
        adminInfo.setEmail(admin.getEmail());
        adminInfo.setAvatar(admin.getAvatar());
        loginVO.setAdminInfo(adminInfo);
        
        // 角色列表（从数据库查询完整角色信息）
        List<LoginVO.RoleInfo> roles = roleList.stream().map(role -> {
            LoginVO.RoleInfo roleInfo = new LoginVO.RoleInfo();
            roleInfo.setId(role.getId());
            roleInfo.setRoleCode(role.getRoleCode());
            roleInfo.setRoleName(role.getRoleName());
            return roleInfo;
        }).collect(Collectors.toList());
        
        loginVO.setRoles(roles);
        
        return loginVO;
    }
    
    @Override
    public void logout(String token) {
        // 1. 验证Token有效性
        if (!jwtUtil.validateToken(token)) {
            throw new RuntimeException("Token无效或已过期");
        }
        
        // 2. 获取Token剩余过期时间
        Long expirationSeconds = jwtUtil.getExpirationFromToken(token);
        if (expirationSeconds > 0) {
            // 3. 将Token加入Redis黑名单，过期时间与Token一致
            redisUtil.addTokenToBlacklist(token, expirationSeconds);
        }
    }
}
