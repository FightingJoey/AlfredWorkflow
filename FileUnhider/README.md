# FileUnhider Alfred Workflow

这是一个用于管理 macOS 隐藏文件的 Alfred Workflow。它允许你通过 Alfred 快速隐藏和显示文件，并保持对已隐藏文件的追踪。

## 功能特点

- 隐藏文件：使用 `chflags hidden` 命令隐藏文件
- 显示文件：使用 `chflags nohidden` 命令显示文件
- 文件追踪：自动记录所有被隐藏的文件到 `hidden_files.log`
- 查看记录：快速打开隐藏文件记录日志

## 使用方法

1. **隐藏文件**
   - 在 Alfred 中输入 `filehide` 后跟文件路径
   - 文件将被隐藏，并且路径会被记录到日志文件中

2. **显示文件**
   - 在 Alfred 中输入 `fileshow` 后跟文件路径
   - 文件将被显示，并且从日志文件中移除

3. **查看隐藏文件列表**
   - 在 Alfred 中输入 `filelist`
   - 将打开包含所有隐藏文件路径的日志文件

## 技术细节

- 使用 bash 脚本实现
- 自动适应不同的工作目录
- 支持包含空格的文件路径
- 使用 `hidden_files.log` 文件追踪所有隐藏的文件

## 注意事项

- 需要适当的文件权限才能执行隐藏/显示操作
- 日志文件会自动创建在 workflow 目录下
- 确保 Alfred 有足够的权限访问目标文件 