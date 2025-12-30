package com.admanagement.utils;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * JWT工具类
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Component
public class JwtUtil {
    
    /**
     * JWT密钥
     */
    @Value("${jwt.secret}")
    private String secret;
    
    /**
     * Token过期时间（秒），默认2小时
     */
    @Value("${jwt.expiration:7200}")
    private Long expiration;
    
    /**
     * JWT签发者
     */
    @Value("${jwt.issuer:AD Management System}")
    private String issuer;
    
    /**
     * Token前缀
     */
    private static final String TOKEN_PREFIX = "Bearer ";
    
    /**
     * 获取签名密钥
     */
    private SecretKey getSignKey() {
        return Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
    }
    
    /**
     * 生成JWT Token
     * 
     * @param adminId 管理员ID
     * @param username 管理员账号
     * @param roleIds 角色ID列表
     * @param roleCodes 角色编码列表
     * @return JWT Token
     */
    public String generateToken(Long adminId, String username, List<Long> roleIds, List<String> roleCodes) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("adminId", adminId);
        claims.put("username", username);
        claims.put("roleIds", roleIds);
        claims.put("roleCodes", roleCodes);
        
        return Jwts.builder()
                .setClaims(claims)
                .setSubject(username)
                .setIssuer(issuer)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + expiration * 1000))
                .signWith(getSignKey())
                .compact();
    }
    
    /**
     * 从Token中获取Claims
     * 
     * @param token JWT Token
     * @return Claims
     */
    public Claims getClaimsFromToken(String token) {
        try {
            return Jwts.parserBuilder()
                    .setSigningKey(getSignKey())
                    .build()
                    .parseClaimsJws(token)
                    .getBody();
        } catch (Exception e) {
            return null;
        }
    }
    
    /**
     * 从Token中获取管理员ID
     * 
     * @param token JWT Token
     * @return 管理员ID
     */
    public Long getAdminIdFromToken(String token) {
        Claims claims = getClaimsFromToken(token);
        if (claims != null) {
            Object adminId = claims.get("adminId");
            if (adminId instanceof Integer) {
                return ((Integer) adminId).longValue();
            } else if (adminId instanceof Long) {
                return (Long) adminId;
            }
        }
        return null;
    }
    
    /**
     * 从Token中获取管理员账号
     * 
     * @param token JWT Token
     * @return 管理员账号
     */
    public String getUsernameFromToken(String token) {
        Claims claims = getClaimsFromToken(token);
        return claims != null ? claims.getSubject() : null;
    }
    
    /**
     * 从Token中获取角色ID列表
     * 
     * @param token JWT Token
     * @return 角色ID列表
     */
    @SuppressWarnings("unchecked")
    public List<Long> getRoleIdsFromToken(String token) {
        Claims claims = getClaimsFromToken(token);
        if (claims != null) {
            return (List<Long>) claims.get("roleIds");
        }
        return null;
    }
    
    /**
     * 从Token中获取角色编码列表
     * 
     * @param token JWT Token
     * @return 角色编码列表
     */
    @SuppressWarnings("unchecked")
    public List<String> getRoleCodesFromToken(String token) {
        Claims claims = getClaimsFromToken(token);
        if (claims != null) {
            return (List<String>) claims.get("roleCodes");
        }
        return null;
    }
    
    /**
     * 验证Token是否有效
     * 
     * @param token JWT Token
     * @return 是否有效
     */
    public boolean validateToken(String token) {
        try {
            Claims claims = getClaimsFromToken(token);
            if (claims == null) {
                return false;
            }
            // 检查Token是否过期
            return !claims.getExpiration().before(new Date());
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * 获取Token过期时间（秒）
     * 
     * @param token JWT Token
     * @return 过期时间（秒），如果Token无效返回-1
     */
    public Long getExpirationFromToken(String token) {
        Claims claims = getClaimsFromToken(token);
        if (claims != null && claims.getExpiration() != null) {
            long expirationTime = claims.getExpiration().getTime();
            long currentTime = System.currentTimeMillis();
            long remainingSeconds = (expirationTime - currentTime) / 1000;
            return remainingSeconds > 0 ? remainingSeconds : 0;
        }
        return -1L;
    }
    
    /**
     * 从请求头中提取Token（去除Bearer前缀）
     * 
     * @param authHeader 请求头Authorization的值
     * @return Token字符串
     */
    public String extractTokenFromHeader(String authHeader) {
        if (authHeader != null && authHeader.startsWith(TOKEN_PREFIX)) {
            return authHeader.substring(TOKEN_PREFIX.length());
        }
        return null;
    }
}

