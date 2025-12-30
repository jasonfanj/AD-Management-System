import { defineConfig, loadEnv } from 'vite'
import vue from '@vitejs/plugin-vue'
import vueJsx from '@vitejs/plugin-vue-jsx'
import { resolve } from 'path'
import { createHtmlPlugin } from 'vite-plugin-html'
import { visualizer } from 'rollup-plugin-visualizer'
import compression from 'vite-plugin-compression'
import eslint from 'vite-plugin-eslint'
import AutoImport from 'unplugin-auto-import/vite'
import Components from 'unplugin-vue-components/vite'
import { ElementPlusResolver } from 'unplugin-vue-components/resolvers'

// https://vitejs.dev/config/
export default defineConfig(({ mode, command }) => {
  const env = loadEnv(mode, process.cwd(), '')
  const isProduction = command === 'build'
  const isDevelopment = command === 'serve'

  return {
    base: env.VITE_PUBLIC_PATH || '/',

    // 路径别名
    resolve: {
      alias: {
        '@': resolve(__dirname, 'src'),
        '~': resolve(__dirname, 'src'),
        '#': resolve(__dirname, 'types'),
        'vue-i18n': 'vue-i18n/dist/vue-i18n.cjs.js'
      }
    },

    // 插件配置
    plugins: [
      vue({
        script: {
          defineModel: true,
          propsDestructure: true
        }
      }),

      vueJsx(),

      // 自动导入
      AutoImport({
        imports: [
          'vue',
          'vue-router',
          'pinia',
          '@vueuse/core',
          {
            'vue-i18n': ['useI18n']
          }
        ],
        dts: 'src/types/auto-imports.d.ts',
        vueTemplate: true,
        eslintrc: {
          enabled: true
        }
      }),

      // 自动导入组件
      Components({
        dts: 'src/types/components.d.ts',
        resolvers: [
          ElementPlusResolver({
            importStyle: 'sass'
          })
        ]
      }),

      // HTML插件
      createHtmlPlugin({
        inject: {
          data: {
            title: env.VITE_APP_TITLE || 'AD管理系统',
            favicon: '/favicon.ico'
          }
        },
        minify: isProduction
      }),

      // ESLint插件
      isDevelopment && eslint({
        cache: false,
        include: ['src/**/*.vue', 'src/**/*.js', 'src/**/*.jsx', 'src/**/*.ts', 'src/**/*.tsx']
      }),

      // 生产环境插件
      isProduction && visualizer({
        filename: 'dist/stats.html',
        open: false,
        gzipSize: true,
        brotliSize: true
      }),

      // 压缩插件
      isProduction && compression({
        algorithm: 'gzip',
        ext: '.gz',
        threshold: 1024,
        deleteOriginFile: false
      }),

      isProduction && compression({
        algorithm: 'brotliCompress',
        ext: '.br',
        threshold: 1024,
        deleteOriginFile: false
      })
    ].filter(Boolean),

    // CSS配置
    css: {
      preprocessorOptions: {
        scss: {
          additionalData: `@use "@/styles/variables.scss" as *;`
        }
      },
      postcss: {
        plugins: [
          require('autoprefixer'),
          require('tailwindcss'),
          require('postcss-preset-env')
        ]
      }
    },

    // 开发服务器配置
    server: {
      host: '0.0.0.0',
      port: env.VITE_PORT || 3000,
      open: true,
      cors: true,
      strictPort: false,
      proxy: {
        '/api': {
          target: env.VITE_API_BASE_URL || 'http://localhost:8080',
          changeOrigin: true,
          rewrite: (path) => path.replace(/^\/api/, ''),
          configure: (proxy, options) => {
            proxy.on('error', (err, req, res) => {
              console.log('proxy error', err)
            })
            proxy.on('proxyReq', (proxyReq, req, res) => {
              console.log('Sending Request to the Target:', req.method, req.url)
            })
            proxy.on('proxyRes', (proxyRes, req, res) => {
              console.log('Received Response from the Target:', proxyRes.statusCode, req.url)
            })
          }
        },
        '/ws': {
          target: env.VITE_WS_BASE_URL || 'ws://localhost:8080',
          changeOrigin: true,
          ws: true
        }
      }
    },

    // 构建配置
    build: {
      target: 'es2015',
      outDir: 'dist',
      assetsDir: 'assets',
      sourcemap: !isProduction,
      minify: isProduction ? 'terser' : false,
      terserOptions: isProduction ? {
        compress: {
          drop_console: true,
          drop_debugger: true,
          pure_funcs: ['console.log']
        }
      } : {},
      rollupOptions: {
        output: {
          chunkFileNames: 'js/[name]-[hash].js',
          entryFileNames: 'js/[name]-[hash].js',
          assetFileNames: (assetInfo) => {
            const info = assetInfo.name.split('.')
            const extType = info[info.length - 1]
            if (/\.(png|jpe?g|gif|svg)(\?.*)?$/.test(assetInfo.name)) {
              return `images/[name]-[hash].${extType}`
            }
            if (/\.(woff2?|eot|ttf|otf)(\?.*)?$/.test(assetInfo.name)) {
              return `fonts/[name]-[hash].${extType}`
            }
            return `assets/[name]-[hash].${extType}`
          },
          manualChunks: {
            'vue-vendor': ['vue', 'vue-router', 'pinia'],
            'element-plus': ['element-plus', '@element-plus/icons-vue'],
            'utils': ['axios', 'dayjs', 'crypto-js', 'js-cookie']
          }
        }
      },
      reportCompressedSize: false,
      chunkSizeWarningLimit: 1000
    },

    // 依赖优化
    optimizeDeps: {
      include: [
        'vue',
        'vue-router',
        'pinia',
        'axios',
        'element-plus/es',
        'element-plus/es/components/message/style/css',
        'element-plus/es/components/message-box/style/css',
        'element-plus/es/components/notification/style/css',
        '@element-plus/icons-vue',
        'dayjs',
        'crypto-js',
        'js-cookie',
        'nprogress'
      ],
      exclude: ['vue-demi']
    },

    // 环境变量
    define: {
      __VUE_I18N_FULL_INSTALL__: true,
      __VUE_I18N_LEGACY_API__: false,
      __INTLIFY_PROD_DEVTOOLS__: false
    },

    // 测试配置
    test: {
      globals: true,
      environment: 'jsdom',
      setupFiles: ['./src/tests/setup.js'],
      include: ['src/**/*.{test,spec}.{js,mjs,cjs,ts,mts,cts,jsx,tsx}'],
      exclude: ['node_modules', 'dist', '.idea', '.git', '.cache'],
      coverage: {
        provider: 'v8',
        reporter: ['text', 'json', 'html'],
        exclude: [
          'node_modules/',
          'src/tests/',
          '**/*.d.ts',
          'dist/',
          'coverage/',
          '**/*.config.*'
        ]
      }
    },

    // 预览配置
    preview: {
      port: 4173,
      host: '0.0.0.0',
      cors: true
    }
  }
})

