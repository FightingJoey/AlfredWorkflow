#!/bin/bash

# 获取 workflow 脚本所在目录（自动适应各种路径）
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
log_file="${SCRIPT_DIR}/hidden_files.log"

# 获取要隐藏的文件路径（根据你的实际情况替换这个变量）
file_path=$1

# 写入前检查是否已存在（支持含空格路径）
if ! grep -qFx "$file_path" "$log_file" 2>/dev/null; then
    echo "$file_path" >> "$log_file"
fi

# 原有隐藏文件命令（保持不变）
chflags hidden "$file_path"