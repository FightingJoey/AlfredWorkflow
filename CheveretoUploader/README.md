# 剪切板/图片上传 Chevereto 图床

## 概述

本项目可将剪贴板中的图片或者图片一键上传至 Chevereto 图床，并自动生成 Markdown 格式的图片链接，同时记录完整的上传历史。支持自定义用户、相册、API 密钥等配置，适用于技术写作、博客创作等需要快速发布图片的场景。

## 核心功能

### 1. **剪切板图片上传**

- 自动检测剪贴板中的 PNG/JPG 图片（依赖 `pngpaste` 工具）
- 支持上传失败检测（如剪贴板为空或非图片内容时提示）

### 2. **智能链接生成**

- 自动生成 `![]()` 格式的 Markdown 链接
- 通过系统通知显示用户、相册及上传状态

### 3. **历史日志追踪**

- 记录时间戳、用户、相册及图片 URL 到本地日志文件
- 日志格式示例： 
      `[2025-04-13 15:30:22] 来源: 剪切板 | User: demo | Album: 123 | URL: https://img.example.com/xxx.png`

### 4. **多账户管理**

- 通过环境变量支持多用户/相册配置
- 可扩展性：通过修改参数实现批量上传（需自行扩展脚本）

## 环境准备

▶ **获取 Chevereto API 凭证**

- 登录 Chevereto 后台，创建 API Key

- 获取用户唯一标识（`user_key`）和目标相册 ID（`album_id`）

▶ **安装依赖工具**

```bash
brew install pngpaste jq  # 用于剪切板操作和 JSON 解析
```

## Alfred Workflow

### 配置步骤
1. **导入 Workflow**

   - 双击 `Chevereto Uploader.alfredworkflow` 完成导入

2. **设置 Alfred 环境变量**

   | 变量名             | 示例值            | 说明             |
   | ------------------ | ----------------- | ---------------- |
   | `CHEVERETO_HOST`   | `img.example.com` | 图床服务域名     |
   | `CHEVERETO_KEY`    | `xxxxxxxxxxxx`    | 全局 API 密钥    |
   | `DEFAULT_USER_KEY` | `user123`         | 默认用户标识     |
   | `DEFAULT_ALBUM_ID` | `456`             | 默认相册 ID      |
   | `HISTORY_LOG`      | `~/chevereto.log` | 历史日志存储路径 |

### 使用说明
#### 基础操作流程

1. 复制任意图片到剪贴板（支持截图工具）或直接复制图片路径
2. 通过关键词触发 Workflow
   1. `up_clip`：上传截图
   2. `up_img 图片路径`：上传图片

3. 上传成功后：
   - Markdown 链接自动复制到剪贴板
   - 系统通知显示用户/相册信息（可右键查看详情）
4. 上传失败时显示错误提示

#### 高级用法
- **临时切换用户/相册**
  - 在 Alfred 输入框追加参数：
    - `up_clip user1 123`
    - `up_img ~/Desktop/1.png user2 234`
- **查看历史日志**
  - 通过终端命令快速检索：
    - `grep "2025-04-13" ~/chevereto.log`

## Shell 脚本

在脚本内部硬编码环境变量，然后就可以通过命令快速上传图片到 Chevereto 图床。

### 使用说明

```bash
# 上传图片到指定用户的指定相册
./chevereto_uploader.sh -f image.png -u user123 -a 123

# 上传图片到默认用户的默认相册
./chevereto_uploader.sh -f image.png

# 上传截图到默认用户的默认相册
./chevereto_uploader.sh

# 上传截图到指定用户的指定相册
./chevereto_uploader.sh -u user123 -a 123
```

### 完整代码

```bash
#! /bin/bash

DEFAULT_USER_KEY="" # 默认用户标识
DEFAULT_ALBUM_ID="" # 默认相册 ID
CHEVERETO_KEY=""    # 全局 API 密钥
CHEVERETO_HOST=""   # 图床服务域名
HISTORY_LOG=""      # 历史日志存储路径


# 定义变量默认值
user_key="$DEFAULT_USER_KEY"
album_id="$DEFAULT_ALBUM_ID"
api_key="$CHEVERETO_KEY"
image_path=""

# 解析命名参数
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -u|--user)
            user_key="$2"
            shift 2
            ;;
        -a|--album)
            album_id="$2"
            shift 2
            ;;
        -f|--file)
            image_path="$2"
            shift 2
            ;;
        *)
            echo "未知参数: $1"
            exit 1
            ;;
    esac
done

if [[ -n "$image_path" && -f "$image_path" && -r "$image_path" ]]; then
    # 图片路径模式
    upload_file="$image_path"
    source_type="路径"
else
    # 剪贴板模式
    temp_file="/tmp/chevereto_upload_$(date +%s).png"
    pngpaste "$temp_file" || { echo "剪贴板无图片且未指定有效路径"; exit 1; }
    upload_file="$temp_file"
    source_type="剪贴板"
fi

# --- 上传逻辑 ---
response=$(curl -s -X POST \
  -F "key=$api_key" \
  -F "user=$user_key" \
  -F "album=$album_id" \
  -F "source=@$upload_file" \
  "https://$CHEVERETO_HOST/api/1/upload")

# --- 日志 ---
image_url=$(echo "$response" | jq -r '.image.display_url')

log_entry="[$(date +"%Y-%m-%d %H:%M:%S")] 来源: $source_type | 用户: $user_key | 相册: $album_id | URL: $image_url"
echo "$log_entry" >> "$HISTORY_LOG"

# --- 清理临时文件 ---
[[ "$source_type" == "剪贴板" ]] && rm -f "$temp_file"

# --- 通知 ---
if [[ -n "$image_url" ]]; then
  markdown_url="![]($image_url)"
  echo -n "$markdown_url" | pbcopy  # 复制 Markdown 格式
  # 显示包含用户和相册信息的通知
  osascript -e "display notification \"用户: $user_key 相册: $album_id\" with title \"图片上传成功\" subtitle \"Markdown 已复制\""
else
  osascript -e "display notification \"上传失败，请检查日志\" with title \"Chevereto\""
fi
```

## 注意事项

1. **依赖管理** 

   若未安装 `pngpaste` 或 `jq`，脚本会中断执行，需通过 Homebrew 手动安装

2. **日志安全** 

   `HISTORY_LOG` 默认存储在用户目录，敏感场景建议加密或设置权限

3. **网络要求** 

   需确保 `CHEVERETO_HOST` 可访问，防火墙可能拦截上传请求

## 致谢

- 核心功能基于 [Chevereto API](https://chevereto.com/)
- JSON 解析依赖 [jq](https://stedolan.github.io/jq/) 工具
- 剪切板操作使用 [pngpaste](https://github.com/jcsalterix/pngpaste) 实现
