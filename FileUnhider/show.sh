#!/bin/bash

# 获取 workflow 脚本所在目录（自动适应各种路径）
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
log_file="${SCRIPT_DIR}/hidden_files.log"

# 获取要显示的文件路径
file_path=$1

# 在显示文件的脚本中添加：
sed -i '' "\|^${file_path}$|d" "$log_file"

chflags nohidden "$file_path"