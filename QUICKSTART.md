# 快速开始指南

## 5分钟快速上手

### 第一步：启动后端服务

**Windows用户：**
```batch
start.bat
```

**Linux/Mac用户：**
```bash
chmod +x start.sh
./start.sh
```

等待看到以下信息表示启动成功：
```
============================================================
域控通-Web AD管理系统
============================================================
初始化数据库...
✓ 默认管理员账户已创建: admin / admin123
后端服务启动中...
API地址: http://localhost:5000/api
前端地址: 直接打开 frontend/index.html 文件
默认账户: admin / admin123
============================================================
```

### 第二步：配置AD连接

编辑 `config.py` 文件，修改以下配置：

```python
AD_CONFIG = {
    'SERVER': 'ldap://your-domain-controller:389',  # 你的AD服务器地址
    'BASE_DN': 'dc=example,dc=com',                  # 你的域DN
    'USER_DN': 'cn=admin,dc=example,dc=com',         # AD管理员账户
    'PASSWORD': 'your-password',                     # AD管理员密码
    'USE_SSL': False,
    'USE_TLS': True,
}
```

### 第三步：打开前端界面

1. 在文件管理器中找到 `frontend/index.html` 文件
2. 双击打开（或右键选择浏览器打开）
3. 使用默认账户登录：
   - 用户名: `admin`
   - 密码: `admin123`

### 第四步：测试AD连接

1. 登录后，点击左侧菜单"系统设置"
2. 在"AD配置"标签页中，点击"测试连接"按钮
3. 如果显示"AD连接成功"，说明配置正确

## 常见问题

### Q: 启动时提示"未检测到Python"？
A: 请先安装Python 3.8+，下载地址：https://www.python.org/downloads/

### Q: 前端页面无法加载？
A: 确保后端服务已启动，并且浏览器控制台没有错误

### Q: AD连接失败？
A: 检查：
- AD服务器地址是否正确
- 网络是否可达
- 用户名和密码是否正确
- 防火墙是否开放389端口

### Q: 如何修改端口？
A: 编辑 `config.py`，修改 `PORT = 5000` 为你想要的端口

## 下一步

- 查看 [README.md](README.md) 了解完整功能
- 查看 API 文档了解接口详情
- 根据需要自定义配置

