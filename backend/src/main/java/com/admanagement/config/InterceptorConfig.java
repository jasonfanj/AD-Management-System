package com.admanagement.config;

import com.admanagement.interceptor.TokenInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * 拦截器配置类
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Configuration
public class InterceptorConfig implements WebMvcConfigurer {
    
    @Autowired
    private TokenInterceptor tokenInterceptor;
    
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(tokenInterceptor)
                .addPathPatterns("/**")  // 拦截所有请求
                .excludePathPatterns(
                        // 登录接口
                        "/admin/login",
                        // 静态资源
                        "/**/*.html",
                        "/**/*.css",
                        "/**/*.js",
                        "/**/*.jpg",
                        "/**/*.png",
                        "/**/*.gif",
                        "/**/*.ico",
                        "/**/*.svg",
                        "/**/*.woff",
                        "/**/*.woff2",
                        "/**/*.ttf",
                        "/**/*.eot",
                        // Swagger文档
                        "/swagger-ui/**",
                        "/swagger-resources/**",
                        "/v3/api-docs/**",
                        "/doc.html",
                        "/webjars/**",
                        // 健康检查
                        "/actuator/**",
                        // 错误页面
                        "/error"
                );
    }
}

