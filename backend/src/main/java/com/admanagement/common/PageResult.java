package com.admanagement.common;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * 分页结果类
 * 
 * @author AD Management System
 * @since 2024-12-30
 */
@Data
public class PageResult<T> implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * 当前页码
     */
    private Long pageNum;
    
    /**
     * 每页数量
     */
    private Long pageSize;
    
    /**
     * 总记录数
     */
    private Long total;
    
    /**
     * 总页数
     */
    private Long totalPages;
    
    /**
     * 数据列表
     */
    private List<T> list;
    
    public PageResult() {
    }
    
    public PageResult(Long pageNum, Long pageSize, Long total, List<T> list) {
        this.pageNum = pageNum;
        this.pageSize = pageSize;
        this.total = total;
        this.totalPages = (total + pageSize - 1) / pageSize; // 向上取整
        this.list = list;
    }
    
    /**
     * 创建分页结果
     */
    public static <T> PageResult<T> of(Long pageNum, Long pageSize, Long total, List<T> list) {
        return new PageResult<>(pageNum, pageSize, total, list);
    }
}

