# PowerShell 使用说明

## 快速开始

### 1. 首次运行（安装依赖）

在PowerShell中运行：
```powershell
.\安装依赖.ps1
```

或者：
```powershell
.\install.bat
```

### 2. 启动服务

**方法1：使用PowerShell脚本**
```powershell
.\启动.ps1
```

**方法2：使用批处理文件**
```powershell
.\start.bat
```

**方法3：直接运行Python**
```powershell
venv\Scripts\Activate.ps1
python app.py
```

## 常见问题

### Q: 提示"无法加载文件，因为在此系统上禁止运行脚本"？

**解决方案：**

1. **临时允许（推荐）**
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
   ```

2. **当前用户永久允许**
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

3. **使用批处理文件代替**
   ```powershell
   .\start.bat
   ```

### Q: 提示"系统找不到指定的文件"？

**解决方案：**

确保使用正确的语法：
- ✅ 正确：`.\start.bat`
- ❌ 错误：`start bat`
- ❌ 错误：`start.bat`（在某些PowerShell版本中）

### Q: 虚拟环境激活失败？

**解决方案：**

1. 检查虚拟环境是否存在：
   ```powershell
   Test-Path venv
   ```

2. 如果不存在，创建虚拟环境：
   ```powershell
   python -m venv venv
   ```

3. 手动激活：
   ```powershell
   .\venv\Scripts\Activate.ps1
   ```

## 推荐工作流程

1. **首次使用：**
   ```powershell
   .\安装依赖.ps1
   ```

2. **日常启动：**
   ```powershell
   .\启动.ps1
   ```

3. **或者使用批处理文件（更简单）：**
   ```powershell
   .\start.bat
   ```

## 检查服务状态

启动后，在浏览器中访问：
- 后端API: http://localhost:5000/api
- 前端界面: 打开 `frontend/index.html`

## 停止服务

在运行服务的窗口中按 `Ctrl+C`

