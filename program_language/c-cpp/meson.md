
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

## 语法

### 宏

```meson
# 指定宏
add_project_arguments('-DMY_MACRO=1', language : 'c')
add_project_arguments('-DMY_MACRO=1', language : 'cpp')
```

### 字符串拼接

```py
'var = @0@'.format(value)
```

## 命令

### 日志

```py
# 打印日志并退出
error('Error message')
```
