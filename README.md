# 域控通-Web - AD管理系统

[![Python](https://img.shields.io/badge/Python-3.8+-blue.svg)](https://www.python.org/)
[![Flask](https://img.shields.io/badge/Flask-3.0.0-green.svg)](https://flask.palletsprojects.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**域控通-Web** 是一个开源的Active Directory管理系统，旨在替代ADManager Plus、ADSelfService Plus、ADAudit Plus等商业解决方案。

## ✨ 核心特性

### 🎯 运行简单
- **后端启动后，直接打开HTML文件即可使用**
- 无需复杂部署，无需构建前端
- 纯HTML+JavaScript，浏览器直接运行

### 📋 功能模块

#### 1. AD域管理核心
- ✅ **批量用户管理**: CSV/模板批量创建/编辑/删除用户
- ✅ **批量操作**: 批量重置密码、解锁、启用/禁用、迁移
- ✅ **AD对象管控**: 计算机/组/OU/GPO批量管理
- ✅ **权限与工作流**: 基于角色的细粒度权限委派
- ✅ **混合环境支持**: 统一管理AD、Microsoft 365、Exchange等

#### 2. 用户自助服务
- ✅ **密码与账户自助**: 网页重置密码、解锁账户
- ✅ **个人信息管理**: 自助更新电话/地址/部门等属性
- ✅ **密码生命周期**: 密码到期提醒、强制密码策略
- ✅ **多终端适配**: 支持PC浏览器、移动端

#### 3. AD变更审计与安全监控
- ✅ **AD变更审计**: 用户/组/计算机/OU/GPO/权限全变更追踪
- ✅ **登录与账户锁定**: 成功/失败登录全记录、账户锁定告警
- ✅ **实时告警**: 邮件/短信实时推送关键变更
- ✅ **报表与取证**: 150+审计报表、导出PDF/CSV用于取证

## 🚀 快速开始

### 环境要求

- Python 3.8+
- Active Directory域控制器（用于连接AD）

### 安装步骤

#### Windows用户

1. **克隆或下载项目**
   ```bash
   git clone <repository-url>
   cd AD-Management-System
   ```

2. **一键启动（推荐）**
   ```batch
   start.bat
   ```

3. **打开前端界面**
   - 后端启动后，直接双击打开 `frontend/index.html` 文件
   - 或使用浏览器打开: `file:///D:/AD Web/AD-Management-System/frontend/index.html`

#### Linux/Mac用户

1. **克隆或下载项目**
   ```bash
   git clone <repository-url>
   cd AD-Management-System
   ```

2. **添加执行权限并启动**
   ```bash
   chmod +x start.sh
   ./start.sh
   ```

3. **打开前端界面**
   - 后端启动后，使用浏览器打开 `frontend/index.html` 文件

### 配置AD连接

首次使用前，需要配置AD连接信息：

1. 编辑 `config.py` 文件，或设置环境变量：
   ```python
   AD_CONFIG = {
       'SERVER': 'ldap://your-domain-controller:389',
       'BASE_DN': 'dc=example,dc=com',
       'USER_DN': 'cn=admin,dc=example,dc=com',
       'PASSWORD': 'your-password',
       'USE_SSL': False,
       'USE_TLS': True,
   }
   ```

2. 或使用环境变量（推荐）：
   ```bash
   # Windows
   set AD_SERVER=ldap://your-domain-controller:389
   set AD_BASE_DN=dc=example,dc=com
   set AD_USER_DN=cn=admin,dc=example,dc=com
   set AD_PASSWORD=your-password
   
   # Linux/Mac
   export AD_SERVER=ldap://your-domain-controller:389
   export AD_BASE_DN=dc=example,dc=com
   export AD_USER_DN=cn=admin,dc=example,dc=com
   export AD_PASSWORD=your-password
   ```

### 默认账户

- **用户名**: `admin`
- **密码**: `admin123`

**⚠️ 首次登录后请立即修改默认密码！**

## 📁 项目结构

```
AD-Management-System/
├── app.py                 # Flask主应用
├── config.py              # 配置文件
├── models.py              # 数据库模型
├── ad_connector.py        # AD连接模块
├── requirements.txt       # Python依赖
├── start.bat              # Windows启动脚本
├── start.sh               # Linux/Mac启动脚本
├── routes/                # API路由
│   ├── auth.py           # 认证路由
│   ├── ad.py             # AD管理路由
│   ├── selfservice.py    # 自助服务路由
│   ├── audit.py          # 审计路由
│   └── system.py         # 系统管理路由
├── frontend/              # 前端文件
│   ├── index.html        # 主页面
│   ├── js/
│   │   └── app.js        # 前端应用逻辑
│   └── styles/
│       └── main.css      # 样式文件
├── data/                  # 数据库文件（自动创建）
├── logs/                  # 日志文件（自动创建）
└── uploads/               # 上传文件（自动创建）
```

## 🔧 使用说明

### 1. 用户管理

- **查看用户列表**: 登录后默认显示用户管理页面
- **创建用户**: 点击"创建用户"按钮，填写用户信息
- **搜索用户**: 在搜索框输入用户名或显示名称
- **批量操作**: 选择多个用户后，可批量重置密码、解锁、启用/禁用

### 2. 自助服务

- **重置密码**: 在"自助服务"页面，使用重置密码功能
- **解锁账户**: 账户被锁定时，可使用自助解锁功能
- **更新个人信息**: 更新邮箱、电话、地址等信息

### 3. 审计日志

- **查看操作日志**: 在"审计日志"页面查看所有操作记录
- **筛选日志**: 可按时间范围、操作类型、用户等筛选
- **导出日志**: 支持导出CSV格式（开发中）

### 4. 系统设置

- **AD配置**: 管理员可在系统设置中配置AD连接信息
- **测试连接**: 配置后点击"测试连接"验证AD连接

## 🔒 安全特性

- ✅ JWT Token认证
- ✅ 密码加密存储（BCrypt）
- ✅ 操作审计日志
- ✅ 登录日志追踪
- ✅ 基于角色的权限控制

## 📊 API接口

### 认证接口
- `POST /api/auth/login` - 用户登录
- `GET /api/auth/me` - 获取当前用户信息
- `POST /api/auth/change-password` - 修改密码

### AD管理接口
- `GET /api/ad/users` - 获取用户列表
- `GET /api/ad/users/<username>` - 获取用户详情
- `POST /api/ad/users` - 创建用户
- `PUT /api/ad/users/<username>` - 更新用户
- `DELETE /api/ad/users/<username>` - 删除用户
- `POST /api/ad/users/<username>/reset-password` - 重置密码
- `POST /api/ad/users/<username>/unlock` - 解锁用户
- `POST /api/ad/users/batch` - 批量操作

### 自助服务接口
- `POST /api/selfservice/reset-password-request` - 请求密码重置
- `POST /api/selfservice/reset-password` - 重置密码
- `POST /api/selfservice/unlock-account` - 解锁账户
- `POST /api/selfservice/update-profile` - 更新个人信息
- `GET /api/selfservice/my-info` - 获取个人信息

### 审计接口
- `GET /api/audit/logs` - 获取审计日志
- `GET /api/audit/login-logs` - 获取登录日志
- `GET /api/audit/statistics` - 获取统计信息

## 🛠️ 开发指南

### 本地开发

1. **安装依赖**
   ```bash
   pip install -r requirements.txt
   ```

2. **启动开发服务器**
   ```bash
   python app.py
   ```

3. **前端开发**
   - 直接编辑 `frontend/index.html`、`frontend/js/app.js`、`frontend/styles/main.css`
   - 刷新浏览器即可看到更改

### 添加新功能

1. **添加新的API路由**
   - 在 `routes/` 目录下创建新的路由文件
   - 在 `app.py` 中注册蓝图

2. **添加前端页面**
   - 在 `frontend/index.html` 中添加新的页面内容
   - 在 `frontend/js/app.js` 中添加对应的逻辑

## 📝 常见问题

### Q: 无法连接AD域？
A: 请检查：
1. AD服务器地址是否正确
2. 网络是否可达
3. 用户名和密码是否正确
4. 防火墙是否开放389/636端口

### Q: 前端页面无法访问API？
A: 请确保：
1. 后端服务已启动（默认端口5000）
2. 浏览器控制台没有CORS错误
3. API地址配置正确（默认: http://localhost:5000/api）

### Q: 如何修改默认端口？
A: 在 `config.py` 中修改 `PORT` 变量，或设置环境变量 `PORT=8080`

## 🤝 贡献指南

欢迎提交Issue和Pull Request！

1. Fork项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建Pull Request

## 📄 许可证

本项目采用MIT许可证 - 查看 [LICENSE](LICENSE) 文件了解详情

## 🙏 致谢

感谢所有为这个项目做出贡献的开发者！

---

**域控通-Web** - 让AD管理变得简单而强大！ 🚀
