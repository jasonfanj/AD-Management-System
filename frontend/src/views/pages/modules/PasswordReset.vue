<template>
  <div class="password-reset-container">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>密码重置</span>
        </div>
      </template>
      
      <el-form
        ref="formRef"
        :model="formData"
        :rules="formRules"
        label-width="120px"
        style="max-width: 600px"
      >
        <el-form-item label="原密码" prop="oldPassword">
          <el-input
            v-model="formData.oldPassword"
            type="password"
            placeholder="请输入原密码"
            show-password
            clearable
          />
        </el-form-item>
        
        <el-form-item label="新密码" prop="newPassword">
          <el-input
            v-model="formData.newPassword"
            type="password"
            placeholder="请输入新密码（至少8位，包含大小写字母和数字）"
            show-password
            clearable
            @blur="handlePasswordBlur"
          />
          <div class="password-hint" v-if="passwordComplexityHint">
            <el-alert
              :title="passwordComplexityHint"
              type="info"
              :closable="false"
              show-icon
              style="margin-top: 8px"
            />
          </div>
        </el-form-item>
        
        <el-form-item label="确认密码" prop="confirmPassword">
          <el-input
            v-model="formData.confirmPassword"
            type="password"
            placeholder="请再次输入新密码"
            show-password
            clearable
          />
        </el-form-item>
        
        <!-- 密码复杂度提示 -->
        <el-form-item>
          <el-alert
            title="密码复杂度要求："
            type="warning"
            :closable="false"
            show-icon
          >
            <template #default>
              <ul style="margin: 8px 0 0 0; padding-left: 20px">
                <li>长度至少8位</li>
                <li>包含至少一个大写字母</li>
                <li>包含至少一个小写字母</li>
                <li>包含至少一个数字</li>
                <li>建议包含特殊字符（!@#$%^&*等）</li>
              </ul>
            </template>
          </el-alert>
        </el-form-item>
        
        <el-form-item>
          <el-button type="primary" @click="handlePreview" :loading="previewLoading">
            预览（校验）
          </el-button>
          <el-button type="success" @click="handleSubmit" :loading="loading">
            提交
          </el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { ElMessage } from 'element-plus'
import { previewPasswordReset, resetPassword } from '@/api/self'

// 表单引用
const formRef = ref(null)

// 加载状态
const loading = ref(false)
const previewLoading = ref(false)

// 密码复杂度提示
const passwordComplexityHint = ref('')

// 表单数据
const formData = reactive({
  oldPassword: '',
  newPassword: '',
  confirmPassword: ''
})

// 自定义验证：确认密码
const validateConfirmPassword = (rule, value, callback) => {
  if (!value) {
    callback(new Error('请再次输入新密码'))
  } else if (value !== formData.newPassword) {
    callback(new Error('两次输入的密码不一致'))
  } else {
    callback()
  }
}

// 自定义验证：新密码复杂度
const validateNewPassword = (rule, value, callback) => {
  if (!value) {
    callback(new Error('请输入新密码'))
  } else if (value.length < 8) {
    callback(new Error('密码长度至少8位'))
  } else {
    // 检查是否包含大写字母、小写字母、数字
    const hasUpperCase = /[A-Z]/.test(value)
    const hasLowerCase = /[a-z]/.test(value)
    const hasDigit = /[0-9]/.test(value)
    
    if (!hasUpperCase) {
      callback(new Error('密码必须包含至少一个大写字母'))
    } else if (!hasLowerCase) {
      callback(new Error('密码必须包含至少一个小写字母'))
    } else if (!hasDigit) {
      callback(new Error('密码必须包含至少一个数字'))
    } else {
      callback()
    }
  }
}

// 表单验证规则
const formRules = {
  oldPassword: [
    { required: true, message: '请输入原密码', trigger: 'blur' }
  ],
  newPassword: [
    { required: true, validator: validateNewPassword, trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, validator: validateConfirmPassword, trigger: 'blur' }
  ]
}

// 密码输入失焦事件（实时校验）
const handlePasswordBlur = async () => {
  if (!formData.newPassword) {
    passwordComplexityHint.value = ''
    return
  }
  
  // 前端实时校验密码复杂度
  const hints = []
  if (formData.newPassword.length < 8) {
    hints.push('长度至少8位')
  }
  if (!/[A-Z]/.test(formData.newPassword)) {
    hints.push('包含大写字母')
  }
  if (!/[a-z]/.test(formData.newPassword)) {
    hints.push('包含小写字母')
  }
  if (!/[0-9]/.test(formData.newPassword)) {
    hints.push('包含数字')
  }
  
  if (hints.length > 0) {
    passwordComplexityHint.value = '密码需要：' + hints.join('、')
  } else {
    passwordComplexityHint.value = '密码复杂度符合要求'
  }
}

// 预览（校验）
const handlePreview = async () => {
  if (!formRef.value) return
  
  try {
    await formRef.value.validate()
    
    previewLoading.value = true
    try {
      const response = await previewPasswordReset({
        oldPassword: formData.oldPassword,
        newPassword: formData.newPassword,
        confirmPassword: formData.confirmPassword
      })
      
      if (response.code === 200) {
        const preview = response.data
        if (preview.valid) {
          ElMessage.success(preview.message || '密码格式校验通过')
          if (preview.complexityHint) {
            passwordComplexityHint.value = preview.complexityHint
          }
        } else {
          ElMessage.warning(preview.message || '密码格式校验未通过')
          if (preview.complexityHint) {
            passwordComplexityHint.value = preview.complexityHint
          }
        }
      } else {
        ElMessage.error(response.message || '密码格式校验失败')
      }
    } catch (error) {
      console.error('密码格式校验失败:', error)
      ElMessage.error('密码格式校验失败，请稍后重试')
    } finally {
      previewLoading.value = false
    }
  } catch (error) {
    console.error('表单验证失败:', error)
  }
}

// 提交
const handleSubmit = async () => {
  if (!formRef.value) return
  
  try {
    await formRef.value.validate()
    
    loading.value = true
    try {
      const response = await resetPassword({
        oldPassword: formData.oldPassword,
        newPassword: formData.newPassword,
        confirmPassword: formData.confirmPassword
      })
      
      if (response.code === 200) {
        ElMessage.success('密码重置成功，请重新登录')
        // 清空表单
        handleReset()
        // 跳转到登录页（可选）
        // router.push('/login')
      } else {
        ElMessage.error(response.message || '密码重置失败')
      }
    } catch (error) {
      console.error('密码重置失败:', error)
      ElMessage.error('密码重置失败，请稍后重试')
    } finally {
      loading.value = false
    }
  } catch (error) {
    console.error('表单验证失败:', error)
  }
}

// 重置表单
const handleReset = () => {
  formData.oldPassword = ''
  formData.newPassword = ''
  formData.confirmPassword = ''
  passwordComplexityHint.value = ''
  formRef.value?.clearValidate()
}
</script>

<style scoped lang="scss">
.password-reset-container {
  padding: 0;
  
  .card-header {
    font-size: 16px;
    font-weight: 600;
  }
  
  .password-hint {
    margin-top: 8px;
  }
}
</style>

