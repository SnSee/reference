
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
