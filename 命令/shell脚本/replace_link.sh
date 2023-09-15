#!/bin/bash
# 将软链接都替换为实际的文件

# 定义函数，用于递归处理指定目录下的软链接
function replace_symlinks() {
    local target_dir="$1"

    # 遍历目录下的所有文件和子目录
    for file in "$target_dir"/*; do
        if [[ -L "$file" ]]; then                   # 判断是否为软链接
            local real_file=$(readlink -f "$file")  # 获取软链接对应的实际文件路径
            rm "$file"                              # 删除软链接
            cp -a "$real_file" "$file"              # 将实际文件复制到软链接位置
        elif [[ -d "$file" ]]; then                 # 如果是目录，则递归处理
            replace_symlinks "$file"
        fi
    done
}

replace_symlinks $1
