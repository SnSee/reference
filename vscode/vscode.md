
# VS-Code

## 制作插件

```text
安装nodejs
```

## 快捷键

```text
1. 点击左下角齿轮，选择 Keyboard Shortcuts
2. 输入关键字搜索，选中 Record Keys 时可根据快捷键搜索
```

* **Alt + H**   : 切换到左侧tab页(View: Open Previous Editor)
* **Alt + L**   : 切换到右侧tab页(View: Open Next Editor)
* **Alt + ]**   : 跳转到声明或引用(使用vim默认即可：extension.vim_ctrl+])
* **Alt + O**   : 回退(Go Back)
* **Alt + I**   : 前进(Go Forward)

## 针对某个文件类型设置

用 vscode 打开文件时，右下角会显示文件类型，在 settings.json 中全小写即可，空格不需要。

如设置markdown自动补全功能: crtl+shift+p, 搜索 settings，打开User Settings, 添加下面的json项

```json
"[markdown]": {
    "editor.quickSuggestions": {
        "other": "on",
        "comments": "off",
        "strings": "off"
    },
    // 基于单词自动补全
    "editor.wordBasedSuggestions": false,
    // 基于代码块自动补全
    "editor.snippetSuggestions": "none",
},
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

```txt
# 使用 <Alt-J> 映射到 <Esc>
1. 点击左下角齿轮，选中Keyboard Shortcuts
2. 搜索 escape
3. 在 Source 是 Vim 的快捷键上右键添加
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

<h1 id="vim-foldopen"></h1>

按 j 时自动打开折叠问题

```text
打开设置，搜索 foldfix，勾选即可
```

### Qt Configure

```text
ctrl + shift + p: QtConfigure: Set Qt Dir 选择安装Qt时最顶层目录，配置成功后
ctrl + shift + p: QtConfigure: New Project 根据提示配置项目后就会在当前目录生成qt工程了
```

### WSL

[WSL + vscode](https://zhuanlan.zhihu.com/p/409547049)
