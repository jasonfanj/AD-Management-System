<template>
  <div class="self-info-container">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>个人信息</span>
        </div>
      </template>
      
      <el-form
        ref="formRef"
        :model="formData"
        :rules="formRules"
        label-width="120px"
        style="max-width: 600px"
      >
        <el-form-item label="账号">
          <el-input v-model="formData.username" disabled />
        </el-form-item>
        
        <el-form-item label="真实姓名" prop="realName">
          <el-input
            v-model="formData.realName"
            placeholder="请输入真实姓名"
            maxlength="50"
            show-word-limit
          />
        </el-form-item>
        
        <el-form-item label="手机号" prop="phone">
          <el-input
            v-model="formData.phone"
            placeholder="请输入手机号"
            maxlength="11"
          />
        </el-form-item>
        
        <el-form-item label="邮箱" prop="email">
          <el-input
            v-model="formData.email"
            placeholder="请输入邮箱"
            maxlength="100"
          />
        </el-form-item>
        
        <el-form-item label="状态">
          <el-tag :type="formData.status === 1 ? 'success' : 'danger'">
            {{ formData.statusText }}
          </el-tag>
        </el-form-item>
        
        <el-form-item label="创建时间">
          <span>{{ formatDateTime(formData.createTime) }}</span>
        </el-form-item>
        
        <el-form-item label="最后登录时间">
          <span>{{ formatDateTime(formData.lastLoginTime) || '-' }}</span>
        </el-form-item>
        
        <el-form-item>
          <el-button type="primary" @click="handleSubmit" :loading="loading">
            保存
          </el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { getSelfInfo, updateSelfInfo } from '@/api/self'
import dayjs from 'dayjs'

// 表单引用
const formRef = ref(null)

// 加载状态
const loading = ref(false)

// 表单数据
const formData = reactive({
  id: null,
  username: '',
  realName: '',
  phone: '',
  email: '',
  status: 1,
  statusText: '启用',
  createTime: null,
  lastLoginTime: null
})

// 原始数据（用于重置）
const originalData = ref({})

// 表单验证规则
const formRules = {
  realName: [
    { required: true, message: '请输入真实姓名', trigger: 'blur' },
    { min: 2, max: 50, message: '长度在 2 到 50 个字符', trigger: 'blur' }
  ],
  phone: [
    { pattern: /^1[3-9]\d{9}$/, message: '手机号格式不正确', trigger: 'blur' }
  ],
  email: [
    { type: 'email', message: '邮箱格式不正确', trigger: 'blur' }
  ]
}

// 格式化日期时间
const formatDateTime = (dateTime) => {
  if (!dateTime) return '-'
  return dayjs(dateTime).format('YYYY-MM-DD HH:mm:ss')
}

// 加载个人信息
const loadSelfInfo = async () => {
  loading.value = true
  try {
    const response = await getSelfInfo()
    if (response.code === 200) {
      Object.assign(formData, response.data)
      // 保存原始数据
      originalData.value = { ...response.data }
    } else {
      ElMessage.error(response.message || '查询个人信息失败')
    }
  } catch (error) {
    console.error('查询个人信息失败:', error)
    ElMessage.error('查询个人信息失败，请稍后重试')
  } finally {
    loading.value = false
  }
}

// 提交表单
const handleSubmit = async () => {
  if (!formRef.value) return
  
  try {
    await formRef.value.validate()
    
    loading.value = true
    try {
      const updateData = {
        realName: formData.realName,
        phone: formData.phone,
        email: formData.email
      }
      
      const response = await updateSelfInfo(updateData)
      if (response.code === 200) {
        ElMessage.success('更新个人信息成功')
        // 重新加载数据
        await loadSelfInfo()
      } else {
        ElMessage.error(response.message || '更新个人信息失败')
      }
    } catch (error) {
      console.error('更新个人信息失败:', error)
      ElMessage.error('更新个人信息失败，请稍后重试')
    } finally {
      loading.value = false
    }
  } catch (error) {
    console.error('表单验证失败:', error)
  }
}

// 重置表单
const handleReset = () => {
  if (originalData.value) {
    Object.assign(formData, originalData.value)
  }
  formRef.value?.clearValidate()
}

// 页面加载时获取个人信息
onMounted(() => {
  loadSelfInfo()
})
</script>

<style scoped lang="scss">
.self-info-container {
  padding: 0;
  
  .card-header {
    font-size: 16px;
    font-weight: 600;
  }
}
</style>

