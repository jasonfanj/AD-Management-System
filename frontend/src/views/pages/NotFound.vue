<template>
  <div class="not-found-container">
    <div class="not-found-content">
      <h1 class="error-code">404</h1>
      <h2 class="error-title">页面不存在</h2>
      <p class="error-description">抱歉，您访问的页面不存在或已被删除</p>
      <el-button type="primary" @click="goHome">返回首页</el-button>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'

const router = useRouter()

const goHome = () => {
  router.push('/')
}
</script>

<style scoped lang="scss">
.not-found-container {
  width: 100%;
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.not-found-content {
  text-align: center;
  color: #fff;
  
  .error-code {
    font-size: 120px;
    font-weight: bold;
    margin: 0;
    line-height: 1;
    text-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
  }
  
  .error-title {
    font-size: 32px;
    margin: 20px 0;
    font-weight: 500;
  }
  
  .error-description {
    font-size: 16px;
    margin-bottom: 40px;
    opacity: 0.9;
  }
}
</style>

