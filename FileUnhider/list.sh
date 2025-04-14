#!/bin/bash

# 获取 workflow 脚本所在目录（自动适应各种路径）
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
log_file="${SCRIPT_DIR}/hidden_files.log"

open -R "$log_file"