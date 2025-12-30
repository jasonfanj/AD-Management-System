# Python 安装指南

## 问题：系统未检测到 Python

如果运行脚本时提示 "Python not found"，说明系统中没有安装 Python 或 Python 未添加到 PATH 环境变量。

## 解决方案

### 方法一：从官网下载安装（推荐）

1. **访问 Python 官网**
   - 地址：https://www.python.org/downloads/
   - 点击 "Download Python 3.x.x" 按钮

2. **运行安装程序**
   - 双击下载的 `.exe` 文件
   - **重要**：勾选 ✅ **"Add Python to PATH"**（添加到路径）
   - 点击 "Install Now"

3. **验证安装**
   - 打开新的 PowerShell 或 CMD 窗口
   - 运行：`python --version`
   - 应该显示 Python 版本号

### 方法二：从 Microsoft Store 安装

1. 打开 Microsoft Store
2. 搜索 "Python"
3. 选择 "Python 3.11" 或更高版本
4. 点击 "获取" 或 "安装"
5. 安装完成后会自动添加到 PATH

### 方法三：使用 Chocolatey（如果已安装）

```powershell
choco install python
```

### 方法四：使用 winget（Windows 10/11）

```powershell
winget install Python.Python.3.11
```

## 安装后验证

1. **关闭当前 PowerShell/CMD 窗口**
2. **重新打开 PowerShell/CMD**
3. **运行检查脚本**：
   ```powershell
   .\检查环境.ps1
   ```
4. **或手动检查**：
   ```powershell
   python --version
   ```

## 如果 Python 已安装但未检测到

### 检查 Python 是否真的安装了

1. 检查常见安装位置：
   - `C:\Python*`
   - `C:\Users\你的用户名\AppData\Local\Programs\Python`
   - `C:\Program Files\Python*`

2. 如果找到了 Python，手动添加到 PATH：
   - 右键 "此电脑" → "属性"
   - "高级系统设置" → "环境变量"
   - 在 "系统变量" 中找到 "Path"，点击 "编辑"
   - 点击 "新建"，添加 Python 安装路径（例如：`C:\Python311`）
   - 添加 Scripts 路径（例如：`C:\Python311\Scripts`）
   - 点击 "确定" 保存
   - **重启 PowerShell/CMD**

## 快速检查脚本

运行以下脚本检查环境：

```powershell
.\检查环境.ps1
```

## 安装完成后

1. 运行环境检查：
   ```powershell
   .\检查环境.ps1
   ```

2. 如果 Python 检测成功，运行安装依赖：
   ```powershell
   .\安装依赖.ps1
   ```

3. 然后启动服务：
   ```powershell
   .\启动.ps1
   ```

## 需要帮助？

如果仍然无法检测到 Python，请：
1. 运行 `.\检查环境.ps1` 查看详细信息
2. 检查 Python 安装路径
3. 确认 PATH 环境变量包含 Python 路径
4. 重启计算机后再试

