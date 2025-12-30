package com.admanagement.controller.ad;

import com.admanagement.annotation.ModulePermission;
import com.admanagement.common.Result;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * AD管理控制器（示例：演示如何使用@ModulePermission注解）
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@RestController
@RequestMapping("/ad-manage")
@ModulePermission(value = "ad_manager", description = "AD管理模块")
public class ADManagerController {
    
    /**
     * 示例控制器（已由AdUserController和AdOuController替代）
     * 保留此文件作为示例参考
     */
    @GetMapping("/test")
    public Result<String> test() {
        return Result.success("AD管理模块测试接口");
    }
}
