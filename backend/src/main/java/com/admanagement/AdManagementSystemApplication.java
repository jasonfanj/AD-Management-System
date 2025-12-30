package com.admanagement;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * AD管理系统启动类
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@SpringBootApplication
@MapperScan("com.admanagement.repository")
public class AdManagementSystemApplication {
    
    public static void main(String[] args) {
        SpringApplication.run(AdManagementSystemApplication.class, args);
    }
}

