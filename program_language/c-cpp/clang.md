
# clang

## clangd

[clangd-Configuration](https://clangd.llvm.org/config)

[vscode-clangd](https://blog.csdn.net/callinglove/article/details/132539448)

```sh
sudo apt install bear
# 生成 compile_commands.json
bear -- make -n -j$(nproc)      # 不真正编译
bear -- make -j$(nproc)         # 真正编译
bear -- gcc test.c              # 直接使用 gcc 编译

# vscode 安装 clangd 插件
# 代码所在主机安装 clangd
sudo apt-get install clangd
```

.clangd

```yml
InlayHints:
    Enabled: false
```

## clang-format

```sh
# 如果有 .clang-format 文件(当前目录或任意一级父目录)，默认使用该文件进行格式化
clang-format [options] [@<file>] [<file> ...]
    -i                  : Inplace edit <file>s
    --style=<string>    : Set coding style

# 创建格式化文件
clang-format -style=google -dump-config > .clang-format
# 使用指定 style 格式化
clang-format -style=google test.cpp > test.google.cpp
# 使用指定文件格式化
clang-format -style=file:.clang-format test.cpp > test.google.cpp
```

在源码中标记不需要格式化的代码

```c
/* clang-format off */
int a;
/* clang-format on */
```
