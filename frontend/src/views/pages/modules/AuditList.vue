<template>
  <div class="audit-list-container">
    <el-card>
      <!-- 搜索栏 -->
      <div class="search-bar">
        <el-form :inline="true" :model="queryParams" class="search-form">
          <el-form-item label="操作人">
            <el-input
              v-model="queryParams.operatorUsername"
              placeholder="请输入操作人账号"
              clearable
              style="width: 200px"
              @keyup.enter="handleSearch"
            />
          </el-form-item>
          <el-form-item label="操作模块">
            <el-select
              v-model="queryParams.operationModule"
              placeholder="请选择"
              clearable
              style="width: 150px"
            >
              <el-option label="AD管理" value="ad_manager" />
              <el-option label="自助服务" value="self_service" />
              <el-option label="审计管理" value="audit" />
            </el-select>
          </el-form-item>
          <el-form-item label="操作类型">
            <el-select
              v-model="queryParams.operationType"
              placeholder="请选择"
              clearable
              style="width: 150px"
            >
              <el-option label="创建" value="CREATE" />
              <el-option label="更新" value="UPDATE" />
              <el-option label="删除" value="DELETE" />
              <el-option label="查询" value="QUERY" />
              <el-option label="登录" value="LOGIN" />
              <el-option label="登出" value="LOGOUT" />
            </el-select>
          </el-form-item>
          <el-form-item label="操作结果">
            <el-select
              v-model="queryParams.operationResult"
              placeholder="请选择"
              clearable
              style="width: 120px"
            >
              <el-option label="成功" :value="1" />
              <el-option label="失败" :value="0" />
            </el-select>
          </el-form-item>
          <el-form-item label="操作时间">
            <el-date-picker
              v-model="timeRange"
              type="datetimerange"
              range-separator="至"
              start-placeholder="开始时间"
              end-placeholder="结束时间"
              format="YYYY-MM-DD HH:mm:ss"
              value-format="YYYY-MM-DD HH:mm:ss"
              style="width: 380px"
              @change="handleTimeRangeChange"
            />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="handleSearch">查询</el-button>
            <el-button @click="handleReset">重置</el-button>
            <el-button type="success" @click="handleExport">导出Excel</el-button>
          </el-form-item>
        </el-form>
      </div>
      
      <!-- 表格 -->
      <el-table
        v-loading="loading"
        :data="tableData"
        border
        stripe
        style="width: 100%"
      >
        <el-table-column type="index" label="序号" width="60" align="center" />
        <el-table-column prop="operationTime" label="操作时间" width="180">
          <template #default="{ row }">
            {{ formatDateTime(row.operationTime) }}
          </template>
        </el-table-column>
        <el-table-column prop="operatorUsername" label="操作人账号" width="120" />
        <el-table-column prop="operatorName" label="操作人姓名" width="120" />
        <el-table-column prop="operationModuleText" label="操作模块" width="120" />
        <el-table-column prop="operationTypeText" label="操作类型" width="100" />
        <el-table-column prop="operationContent" label="操作内容" min-width="200" show-overflow-tooltip />
        <el-table-column prop="operationIp" label="操作IP" width="130" />
        <el-table-column prop="operationResultText" label="操作结果" width="100" align="center">
          <template #default="{ row }">
            <el-tag :type="row.operationResult === 1 ? 'success' : 'danger'">
              {{ row.operationResultText }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="executionTime" label="执行时间(ms)" width="120" align="center" />
        <el-table-column prop="requestMethod" label="请求方法" width="100" align="center">
          <template #default="{ row }">
            <el-tag :type="getMethodTagType(row.requestMethod)">
              {{ row.requestMethod }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="requestUrl" label="请求URL" min-width="200" show-overflow-tooltip />
        <el-table-column prop="errorMessage" label="错误信息" min-width="200" show-overflow-tooltip>
          <template #default="{ row }">
            <span v-if="row.errorMessage" style="color: #f56c6c">
              {{ row.errorMessage }}
            </span>
            <span v-else>-</span>
          </template>
        </el-table-column>
      </el-table>
      
      <!-- 分页 -->
      <div class="pagination-container">
        <el-pagination
          v-model:current-page="queryParams.pageNum"
          v-model:page-size="queryParams.pageSize"
          :total="total"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import * as XLSX from 'xlsx'
import { getAuditLogList } from '@/api/audit'
import dayjs from 'dayjs'

// 加载状态
const loading = ref(false)

// 查询参数
const queryParams = reactive({
  operatorUsername: '',
  operationModule: '',
  operationType: '',
  operationResult: null,
  startTime: null,
  endTime: null,
  pageNum: 1,
  pageSize: 10
})

// 时间范围
const timeRange = ref(null)

// 表格数据
const tableData = ref([])

// 总数
const total = ref(0)

// 格式化日期时间
const formatDateTime = (dateTime) => {
  if (!dateTime) return '-'
  return dayjs(dateTime).format('YYYY-MM-DD HH:mm:ss')
}

// 获取请求方法标签类型
const getMethodTagType = (method) => {
  const methodMap = {
    'GET': 'info',
    'POST': 'success',
    'PUT': 'warning',
    'DELETE': 'danger'
  }
  return methodMap[method] || ''
}

// 查询数据
const fetchData = async () => {
  loading.value = true
  try {
    const response = await getAuditLogList(queryParams)
    if (response.code === 200) {
      tableData.value = response.data.list || []
      total.value = response.data.total || 0
    } else {
      ElMessage.error(response.message || '查询失败')
    }
  } catch (error) {
    console.error('查询审计日志列表失败:', error)
    ElMessage.error('查询失败，请稍后重试')
  } finally {
    loading.value = false
  }
}

// 搜索
const handleSearch = () => {
  queryParams.pageNum = 1
  fetchData()
}

// 重置
const handleReset = () => {
  queryParams.operatorUsername = ''
  queryParams.operationModule = ''
  queryParams.operationType = ''
  queryParams.operationResult = null
  queryParams.startTime = null
  queryParams.endTime = null
  queryParams.pageNum = 1
  queryParams.pageSize = 10
  timeRange.value = null
  fetchData()
}

// 时间范围变化
const handleTimeRangeChange = (value) => {
  if (value && value.length === 2) {
    queryParams.startTime = value[0]
    queryParams.endTime = value[1]
  } else {
    queryParams.startTime = null
    queryParams.endTime = null
  }
}

// 分页大小变化
const handleSizeChange = (size) => {
  queryParams.pageSize = size
  queryParams.pageNum = 1
  fetchData()
}

// 当前页变化
const handleCurrentChange = (page) => {
  queryParams.pageNum = page
  fetchData()
}

// 导出Excel
const handleExport = () => {
  if (tableData.value.length === 0) {
    ElMessage.warning('暂无数据可导出')
    return
  }
  
  try {
    // 准备导出数据
    const exportData = tableData.value.map((item, index) => ({
      序号: index + 1,
      操作时间: formatDateTime(item.operationTime),
      操作人账号: item.operatorUsername,
      操作人姓名: item.operatorName,
      操作模块: item.operationModuleText,
      操作类型: item.operationTypeText,
      操作内容: item.operationContent,
      操作IP: item.operationIp,
      操作结果: item.operationResultText,
      执行时间ms: item.executionTime || 0,
      请求方法: item.requestMethod,
      请求URL: item.requestUrl,
      错误信息: item.errorMessage || ''
    }))
    
    // 创建工作簿
    const wb = XLSX.utils.book_new()
    const ws = XLSX.utils.json_to_sheet(exportData)
    
    // 设置列宽
    const colWidths = [
      { wch: 8 },   // 序号
      { wch: 20 },  // 操作时间
      { wch: 15 },  // 操作人账号
      { wch: 15 },  // 操作人姓名
      { wch: 12 },  // 操作模块
      { wch: 12 },  // 操作类型
      { wch: 30 },  // 操作内容
      { wch: 15 },  // 操作IP
      { wch: 10 },  // 操作结果
      { wch: 12 },  // 执行时间
      { wch: 10 },  // 请求方法
      { wch: 40 },  // 请求URL
      { wch: 30 }   // 错误信息
    ]
    ws['!cols'] = colWidths
    
    // 添加工作表到工作簿
    XLSX.utils.book_append_sheet(wb, ws, '审计日志')
    
    // 导出文件
    const fileName = `审计日志_${dayjs().format('YYYY-MM-DD_HH-mm-ss')}.xlsx`
    XLSX.writeFile(wb, fileName)
    
    ElMessage.success('导出成功')
  } catch (error) {
    console.error('导出Excel失败:', error)
    ElMessage.error('导出失败，请稍后重试')
  }
}

// 页面加载时查询数据
onMounted(() => {
  fetchData()
})
</script>

<style scoped lang="scss">
.audit-list-container {
  padding: 0;
  
  .search-bar {
    margin-bottom: 20px;
    padding: 20px;
    background-color: #f5f7fa;
    border-radius: 4px;
    
    .search-form {
      margin: 0;
    }
  }
  
  .pagination-container {
    margin-top: 20px;
    display: flex;
    justify-content: flex-end;
  }
}
</style>

