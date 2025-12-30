# 启动说明 - 重要提示

## 问题：Python 已安装但未在 PATH 中

如果运行脚本时提示 "Python not found"，但检查脚本发现 Python 已安装，这是因为 Python 没有添加到 PATH 环境变量。

## 解决方案

### 方案一：使用完整路径启动脚本（最简单）⭐

直接运行：
```powershell
.\使用完整路径启动.ps1
```

这个脚本会使用检测到的 Python 完整路径，无需修改 PATH。

### 方案二：修复 PATH（推荐，一次设置永久有效）

1. **运行修复脚本**：
   ```powershell
   .\fix-python-path.ps1
   ```

2. **重启 PowerShell**（重要！）
   - 关闭当前 PowerShell 窗口
   - 重新打开 PowerShell
   - 进入项目目录

3. **运行启动脚本**：
   ```powershell
   .\启动.ps1
   ```

### 方案三：手动添加到 PATH

1. 右键 "此电脑" → "属性"
2. "高级系统设置" → "环境变量"
3. 在 "用户变量" 中找到 "Path"，点击 "编辑"
4. 点击 "新建"，添加以下路径：
   - `C:\Users\CEM\AppData\Local\Programs\Python\Python314`
   - `C:\Users\CEM\AppData\Local\Programs\Python\Python314\Scripts`
5. 点击 "确定" 保存
6. **重启 PowerShell**

## 快速启动步骤

### 首次运行：

1. **检查环境**：
   ```powershell
   .\check-env.ps1
   ```

2. **如果 Python 未在 PATH 中，使用完整路径启动**：
   ```powershell
   .\使用完整路径启动.ps1
   ```

3. **或者修复 PATH 后重启 PowerShell**：
   ```powershell
   .\fix-python-path.ps1
   # 然后关闭并重新打开 PowerShell
   .\启动.ps1
   ```

### 日常使用：

如果 PATH 已修复：
```powershell
.\启动.ps1
```

如果 PATH 未修复：
```powershell
.\使用完整路径启动.ps1
```

## 验证 Python 是否可用

运行以下命令检查：
```powershell
python --version
```

如果显示版本号（如 `Python 3.14.2`），说明 Python 可用。

## 常见问题

### Q: 为什么修复 PATH 后还是提示找不到 Python？

A: 需要**重启 PowerShell**。PATH 的更改只在新的会话中生效。

### Q: 不想修改 PATH 怎么办？

A: 使用 `.\使用完整路径启动.ps1`，这个脚本不依赖 PATH。

### Q: 如何确认 Python 路径？

A: 运行 `.\check-env.ps1` 查看检测到的 Python 安装路径。

