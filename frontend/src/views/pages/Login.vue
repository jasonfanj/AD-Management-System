<template>
  <div class="login-container">
    <div class="login-box">
      <div class="login-header">
        <h1 class="login-title">AD管理系统</h1>
        <p class="login-subtitle">AD Management System</p>
      </div>
      
      <el-form
        ref="loginFormRef"
        :model="loginForm"
        :rules="loginRules"
        class="login-form"
        @keyup.enter="handleLogin"
      >
        <el-form-item prop="username">
          <el-input
            v-model="loginForm.username"
            placeholder="请输入账号"
            size="large"
            prefix-icon="User"
            clearable
          />
        </el-form-item>
        
        <el-form-item prop="password">
          <el-input
            v-model="loginForm.password"
            type="password"
            placeholder="请输入密码"
            size="large"
            prefix-icon="Lock"
            show-password
            clearable
            @keyup.enter="handleLogin"
          />
        </el-form-item>
        
        <el-form-item>
          <div class="login-options">
            <el-checkbox v-model="loginForm.rememberMe">记住密码</el-checkbox>
          </div>
        </el-form-item>
        
        <el-form-item>
          <el-button
            type="primary"
            size="large"
            class="login-button"
            :loading="loading"
            @click="handleLogin"
          >
            {{ loading ? '登录中...' : '登录' }}
          </el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { User, Lock } from '@element-plus/icons-vue'
import { useAdminStore } from '@/store/adminStore'

const router = useRouter()
const adminStore = useAdminStore()

// 表单引用
const loginFormRef = ref(null)

// 加载状态
const loading = ref(false)

// 登录表单数据
const loginForm = reactive({
  username: '',
  password: '',
  rememberMe: false
})

// 表单校验规则
const loginRules = {
  username: [
    { required: true, message: '请输入账号', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' }
  ]
}

// 登录处理
const handleLogin = async () => {
  // 表单校验
  if (!loginFormRef.value) return
  
  await loginFormRef.value.validate((valid) => {
    if (!valid) {
      return false
    }
    
    // 执行登录
    doLogin()
  })
}

// 执行登录
const doLogin = async () => {
  loading.value = true
  
  try {
    // 调用Pinia store的login方法
    await adminStore.login({
      username: loginForm.username,
      password: loginForm.password
    })
    
    // 登录成功，跳转到首页
    ElMessage.success('登录成功')
    router.push('/')
  } catch (error) {
    console.error('登录失败:', error)
    ElMessage.error(error.message || '登录失败，请检查账号和密码')
  } finally {
    loading.value = false
  }
}

// 执行登录
const doLogin = async () => {
  loading.value = true
  
  try {
    // 调用Pinia store的login方法
    await adminStore.login({
      username: loginForm.username,
      password: loginForm.password
    })
    
    // 处理记住密码
    if (loginForm.rememberMe) {
      localStorage.setItem('rememberedUsername', loginForm.username)
      // 注意：实际项目中不建议存储明文密码，这里仅作演示
      // 可以考虑使用加密存储或仅记住用户名
      // localStorage.setItem('rememberedPassword', loginForm.password)
    } else {
      localStorage.removeItem('rememberedUsername')
      localStorage.removeItem('rememberedPassword')
    }
    
    // 登录成功，跳转到首页
    ElMessage.success('登录成功')
    router.push('/')
  } catch (error) {
    console.error('登录失败:', error)
    ElMessage.error(error.message || '登录失败，请检查账号和密码')
  } finally {
    loading.value = false
  }
}

// 页面加载时，如果已登录则跳转
onMounted(() => {
  if (adminStore.isLoggedIn) {
    router.push('/')
  }
  
  // 如果勾选了记住密码，从localStorage恢复用户名
  const rememberedUsername = localStorage.getItem('rememberedUsername')
  
  if (rememberedUsername) {
    loginForm.username = rememberedUsername
    loginForm.rememberMe = true
    // 注意：实际项目中不建议存储明文密码
    // const rememberedPassword = localStorage.getItem('rememberedPassword')
    // if (rememberedPassword) {
    //   loginForm.password = rememberedPassword
    // }
  }
})
</script>

<style scoped lang="scss">
.login-container {
  width: 100%;
  height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  justify-content: center;
  align-items: center;
  position: relative;
  overflow: hidden;
  
  // 背景装饰
  &::before {
    content: '';
    position: absolute;
    width: 500px;
    height: 500px;
    background: rgba(255, 255, 255, 0.1);
    border-radius: 50%;
    top: -250px;
    right: -250px;
  }
  
  &::after {
    content: '';
    position: absolute;
    width: 400px;
    height: 400px;
    background: rgba(255, 255, 255, 0.08);
    border-radius: 50%;
    bottom: -200px;
    left: -200px;
  }
}

.login-box {
  width: 450px;
  padding: 50px 40px;
  background: rgba(255, 255, 255, 0.95);
  border-radius: 16px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  backdrop-filter: blur(10px);
  position: relative;
  z-index: 1;
  animation: fadeInUp 0.6s ease-out;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.login-header {
  text-align: center;
  margin-bottom: 40px;
  
  .login-title {
    font-size: 32px;
    font-weight: 600;
    color: #333;
    margin: 0 0 8px 0;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
  }
  
  .login-subtitle {
    font-size: 14px;
    color: #999;
    margin: 0;
    letter-spacing: 2px;
  }
}

.login-form {
  .el-form-item {
    margin-bottom: 24px;
    
    :deep(.el-input__wrapper) {
      border-radius: 8px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
      transition: all 0.3s;
      
      &:hover {
        box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
      }
      
      &.is-focus {
        box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
      }
    }
  }
  
  .login-options {
    width: 100%;
    display: flex;
    justify-content: space-between;
    align-items: center;
    
    :deep(.el-checkbox) {
      .el-checkbox__label {
        color: #666;
        font-size: 14px;
      }
    }
  }
  
  .login-button {
    width: 100%;
    height: 48px;
    font-size: 16px;
    font-weight: 500;
    border-radius: 8px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border: none;
    transition: all 0.3s;
    
    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
    }
    
    &:active {
      transform: translateY(0);
    }
  }
}

// 响应式设计
@media (max-width: 768px) {
  .login-box {
    width: 90%;
    padding: 40px 30px;
  }
  
  .login-header {
    .login-title {
      font-size: 28px;
    }
  }
}
</style>
