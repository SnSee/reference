#!/bin/bash

###########################################################
#   替换目标文件中的字符串                                  #
###########################################################

var_force=""


# 解析命令行参数
function parse_opt() {
    case $1 in
        f)
            var_force="1";;
        h)
            echo "usage: replace.sh file_or_dir old_str new_str"
            exit 0;;
        *)
            echo "unknown option: $1"
            exit -1;;
    esac
}


# 打印error信息并退出
function error() {
    echo "[ERROR]: $*"
    exit -1
}


# 转义 /
function escape() {
    echo ${1//\//\\\/}
}


# 去除可选参数
args=()
for arg in $*
do
    if [[ $arg != -* ]]; then
        args[${#args[@]}]=$arg
    else
        parse_opt ${arg:1}
    fi
done
# 检查命令行参数
if [[ ${#args[@]} -ne 3 ]]; then
    error "Invalid args count"
fi
# 获取命令行参数
target_path=${args[0]}
if [[ ! -e $target_path ]]; then
    error "$target_path does not exist"
fi
old_str=`escape ${args[1]}`
new_str=`escape ${args[2]}`
echo "replace $old_str with $new_str"
if [[ ! $var_force ]]; then
    read -p "press <Enter> to continue or <Ctrl-C> to stop"
fi


# 替换单个文件
function replace_single_file() {
    file_name=$1
    eval sed -i 's/${old_str}/${new_str}/g' $file_name
}


# 替换目录下所有文件
function replace_dir() {
    dir_name=$1
    for file_name in `find $dir_name -type f`
    do
        replace_single_file $file_name
    done
}


# 替换
if [[ -d $target_path ]]; then
    replace_dir $target_path
elif [[ -f $target_path ]]; then
    replace_single_file $target_path
fi
