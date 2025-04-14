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
