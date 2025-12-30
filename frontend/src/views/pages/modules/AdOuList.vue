<template>
  <div class="ad-ou-list-container">
    <el-card>
      <!-- 工具栏 -->
      <div class="toolbar">
        <el-button type="primary" @click="handleRefresh">刷新</el-button>
      </div>
      
      <!-- OU树形表格 -->
      <el-table
        v-loading="loading"
        :data="ouList"
        border
        stripe
        row-key="dn"
        :tree-props="{ children: 'children', hasChildren: 'hasChildren' }"
        style="width: 100%"
      >
        <el-table-column prop="name" label="OU名称" width="300" />
        <el-table-column prop="description" label="描述" min-width="200" />
        <el-table-column prop="path" label="路径" min-width="300" />
        <el-table-column prop="userCount" label="用户数量" width="120" align="center">
          <template #default="{ row }">
            <el-tag type="info">{{ row.userCount || 0 }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="groupCount" label="组数量" width="120" align="center">
          <template #default="{ row }">
            <el-tag type="warning">{{ row.groupCount || 0 }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link size="small" @click="handleView(row)">查看</el-button>
            <el-button type="success" link size="small" @click="handleEdit(row)">编辑</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { getOuList } from '@/api/ad'

// 加载状态
const loading = ref(false)

// OU列表数据
const ouList = ref([])

// 查询OU列表
const fetchOuList = async () => {
  loading.value = true
  try {
    const response = await getOuList()
    if (response.code === 200) {
      ouList.value = response.data || []
    } else {
      ElMessage.error(response.message || '查询失败')
    }
  } catch (error) {
    console.error('查询OU列表失败:', error)
    ElMessage.error('查询失败，请稍后重试')
  } finally {
    loading.value = false
  }
}

// 刷新
const handleRefresh = () => {
  fetchOuList()
}

// 查看
const handleView = (row) => {
  ElMessage.info(`查看OU: ${row.name}`)
  // TODO: 实现查看详情功能
}

// 编辑
const handleEdit = (row) => {
  ElMessage.info(`编辑OU: ${row.name}`)
  // TODO: 实现编辑功能
}

// 页面加载时查询数据
onMounted(() => {
  fetchOuList()
})
</script>

<style scoped lang="scss">
.ad-ou-list-container {
  padding: 0;
  
  .toolbar {
    margin-bottom: 20px;
  }
}
</style>

