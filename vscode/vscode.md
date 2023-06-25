
# VS-Code

## 制作插件

```text
安装nodejs
```

## 插件

### Vim

修改快捷键

```text
1. 打开设置
2. 搜索 keybindings, 选择 Vim
3. "Vim: Normal Mode Key Bindings" 或其他模式下的 "Edit in setting.json" 编辑
4. 点击 README 查看帮助网页
```

互换快捷键

```json
{
    "vim.normalModeKeyBindingsNonRecursive": [
        {
            "before": ["v"],
            "after": ["<C-v>"]
        },
        {
            "before": ["<C-v>"],
            "after": ["v"]
        },
    ]
}
```

### Qt Configure

```text
ctrl + shift + p: QtConfigure: Set Qt Dir 选择安装Qt时最顶层目录，配置成功后
ctrl + shift + p: QtConfigure: New Project 根据提示配置项目后就会在当前目录生成qt工程了
```

### WSL

[WSL + vscode](https://zhuanlan.zhihu.com/p/409547049)
