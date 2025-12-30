package com.admanagement.utils;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;

import java.util.concurrent.TimeUnit;

/**
 * Redis工具类
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Component
public class RedisUtil {
    
    @Autowired
    private RedisTemplate<String, Object> redisTemplate;
    
    /**
     * Token黑名单前缀
     */
    private static final String TOKEN_BLACKLIST_PREFIX = "token:blacklist:";
    
    /**
     * 将Token加入黑名单
     * 
     * @param token JWT Token
     * @param expirationSeconds 过期时间（秒）
     */
    public void addTokenToBlacklist(String token, long expirationSeconds) {
        String key = TOKEN_BLACKLIST_PREFIX + token;
        redisTemplate.opsForValue().set(key, "1", expirationSeconds, TimeUnit.SECONDS);
    }
    
    /**
     * 检查Token是否在黑名单中
     * 
     * @param token JWT Token
     * @return 是否在黑名单中
     */
    public boolean isTokenInBlacklist(String token) {
        String key = TOKEN_BLACKLIST_PREFIX + token;
        return Boolean.TRUE.equals(redisTemplate.hasKey(key));
    }
    
    /**
     * 从黑名单中移除Token
     * 
     * @param token JWT Token
     */
    public void removeTokenFromBlacklist(String token) {
        String key = TOKEN_BLACKLIST_PREFIX + token;
        redisTemplate.delete(key);
    }
    
    /**
     * 设置缓存
     * 
     * @param key 键
     * @param value 值
     * @param timeout 过期时间（秒）
     */
    public void set(String key, Object value, long timeout) {
        redisTemplate.opsForValue().set(key, value, timeout, TimeUnit.SECONDS);
    }
    
    /**
     * 获取缓存
     * 
     * @param key 键
     * @return 值
     */
    public Object get(String key) {
        return redisTemplate.opsForValue().get(key);
    }
    
    /**
     * 删除缓存
     * 
     * @param key 键
     */
    public void delete(String key) {
        redisTemplate.delete(key);
    }
    
    /**
     * 判断key是否存在
     * 
     * @param key 键
     * @return 是否存在
     */
    public boolean hasKey(String key) {
        return Boolean.TRUE.equals(redisTemplate.hasKey(key));
    }
    
    /**
     * 设置过期时间
     * 
     * @param key 键
     * @param timeout 过期时间（秒）
     * @return 是否设置成功
     */
    public boolean expire(String key, long timeout) {
        return Boolean.TRUE.equals(redisTemplate.expire(key, timeout, TimeUnit.SECONDS));
    }
}

