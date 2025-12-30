<template>
  <div class="ad-user-list-container">
    <el-card>
      <!-- 搜索栏 -->
      <div class="search-bar">
        <el-form :inline="true" :model="queryParams" class="search-form">
          <el-form-item label="搜索">
            <el-input
              v-model="queryParams.keyword"
              placeholder="请输入账号、姓名、邮箱"
              clearable
              style="width: 250px"
              @keyup.enter="handleSearch"
            />
          </el-form-item>
          <el-form-item label="账户状态">
            <el-select
              v-model="queryParams.accountStatus"
              placeholder="请选择"
              clearable
              style="width: 150px"
            >
              <el-option label="启用" :value="1" />
              <el-option label="禁用" :value="0" />
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="handleSearch">查询</el-button>
            <el-button @click="handleReset">重置</el-button>
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
        <el-table-column prop="samAccountName" label="账号" width="150" />
        <el-table-column prop="displayName" label="姓名" width="150" />
        <el-table-column prop="userPrincipalName" label="用户主体名称" width="200" />
        <el-table-column prop="email" label="邮箱" width="200" />
        <el-table-column prop="department" label="部门" width="120" />
        <el-table-column prop="title" label="职位" width="120" />
        <el-table-column prop="telephoneNumber" label="电话" width="120" />
        <el-table-column prop="mobile" label="手机" width="120" />
        <el-table-column prop="accountStatusText" label="账户状态" width="100">
          <template #default="{ row }">
            <el-tag :type="row.accountStatus === 1 ? 'success' : 'danger'">
              {{ row.accountStatusText }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="lastLogon" label="最后登录时间" width="180">
          <template #default="{ row }">
            {{ formatDateTime(row.lastLogon) }}
          </template>
        </el-table-column>
        <el-table-column prop="passwordExpires" label="密码过期时间" width="180">
          <template #default="{ row }">
            {{ formatDateTime(row.passwordExpires) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="150" fixed="right">
          <template #default="{ row }">
            <el-button 
              type="primary" 
              link 
              size="small"
              v-permission="'ad:manage:user:edit'"
              @click="handleEdit(row)"
            >
              编辑
            </el-button>
            <el-button 
              type="danger" 
              link 
              size="small"
              v-permission="'ad:manage:user:delete'"
              @click="handleDelete(row)"
            >
              删除
            </el-button>
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
import { getAdUserList } from '@/api/ad'
import dayjs from 'dayjs'

// 加载状态
const loading = ref(false)

// 查询参数
const queryParams = reactive({
  keyword: '',
  accountStatus: null,
  pageNum: 1,
  pageSize: 10
})

// 表格数据
const tableData = ref([])

// 总数
const total = ref(0)

// 格式化日期时间
const formatDateTime = (dateTime) => {
  if (!dateTime) return '-'
  return dayjs(dateTime).format('YYYY-MM-DD HH:mm:ss')
}

// 查询数据
const fetchData = async () => {
  loading.value = true
  try {
    const response = await getAdUserList(queryParams)
    if (response.code === 200) {
      tableData.value = response.data.list || []
      total.value = response.data.total || 0
    } else {
      ElMessage.error(response.message || '查询失败')
    }
  } catch (error) {
    console.error('查询AD用户列表失败:', error)
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
  queryParams.keyword = ''
  queryParams.accountStatus = null
  queryParams.pageNum = 1
  queryParams.pageSize = 10
  fetchData()
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

// 页面加载时查询数据
onMounted(() => {
  fetchData()
})
</script>

<style scoped lang="scss">
.ad-user-list-container {
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
