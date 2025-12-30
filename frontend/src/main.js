/**
 * 项目入口文件
 */
import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import { createPinia } from 'pinia'

// Element Plus
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'
import zhCn from 'element-plus/dist/locale/zh-cn.mjs'

// 创建应用实例
const app = createApp(App)

// 注册Element Plus图标
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  app.component(key, component)
}

// 配置Pinia（注意：我们使用手动localStorage管理，不使用persistedstate插件）
const pinia = createPinia()

// 安装插件
app.use(pinia)
app.use(router)
app.use(ElementPlus, {
  locale: zhCn
})

// 注册权限指令
import permissionDirective from '@/directives/permission'
app.directive('permission', permissionDirective)

// 挂载应用
app.mount('#app')
