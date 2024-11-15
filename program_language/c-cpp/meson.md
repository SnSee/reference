
# meson

[官网](https://mesonbuild.com)

[参考手册](https://mesonbuild.com/Reference-manual.html)

安装

```sh
pip install meson
sudo apt-get install ninja-build
# 或
sudo apt-get install ninja
# windows 下载链接中的压缩包，解压后将路径添加到PATH
```

[ninja下载链接](https://github.com/ninja-build/ninja/releases)

## 编译

```sh
mkdir build && cd build
meson .. --prefix=/where/to/install
ninja -j 10
ninja install
```

### 编译模式

```sh
meson setup build_dir --buildtype=debug                 # debug 模式
meson setup build_dir --reconfigure --buildtype=debug   # 重新 config
```

### 编译选项

```sh
# 获取编译选项，默认使用 meson_options.txt 中的值
# 也可通过 -D 指定，优先级更高，如 -Damd-use-llvm=false
opt = get_option('opt')
```

```sh
# 指定 option 的方式
meson setup build -Da=true -Db=enabled -DC=s1,s2
```

## 语法

### 宏

```meson
# 指定宏
add_project_arguments('-DMY_MACRO=1', language : 'c')
add_project_arguments('-DMY_MACRO=1', language : 'cpp')
```

### 字符串拼接

```py
# 只能用单引号
'var = @0@'.format(value)
```

### 包含子目录

```c
subdir('dir_name')
```

## 命令

### 日志

```py
# 打印日志并退出
error('Error message')
```
