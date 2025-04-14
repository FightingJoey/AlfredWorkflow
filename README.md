# Alfred Workflows 集合

这是一个 Alfred Workflows 集合，包含多个实用的工作流，旨在提高工作效率。

## 项目列表

### 1. FileUnhider

一个用于管理 macOS 隐藏文件的 Workflow。

#### 主要功能
- 隐藏文件：使用 `filehide` 命令隐藏文件
- 显示文件：使用 `fileshow` 命令显示文件
- 查看记录：使用 `filelist` 命令查看隐藏文件列表
- 自动追踪：记录所有隐藏文件到日志

[查看详细文档](./FileUnhider/README.md)

### 2. CheveretoUploader

一个用于快速上传图片到 Chevereto 图床的 Workflow。

#### 主要功能
- 剪切板图片上传：支持直接上传剪贴板中的图片
- 文件上传：支持上传本地图片文件
- 智能链接生成：自动生成 Markdown 格式的图片链接
- 历史记录：自动记录所有上传历史
- 多账户管理：支持多用户/相册配置

#### 使用方法
1. 上传剪贴板图片：`up_clip`
2. 上传本地图片：`up_img 图片路径`
3. 临时切换用户/相册：`up_clip user1 123` 或 `up_img 图片路径 user2 234`

[查看详细文档](./CheveretoUploader/README.md)

## 环境要求

- macOS 操作系统
- [Alfred](https://www.alfredapp.com/) 4.0 或更高版本
- Alfred Powerpack 许可证

## 安装说明

1. 下载需要的 Workflow 文件（.alfredworkflow）
2. 双击文件导入到 Alfred
3. 按照各个 Workflow 的说明配置必要的环境变量和依赖

## 注意事项

- 确保给予 Alfred 足够的系统权限
- 部分功能可能需要安装额外的依赖工具
- 请参考各个 Workflow 的详细文档进行配置和使用 