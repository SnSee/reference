
# VS-Code

[doc](https://code.visualstudio.com/docs)
[插件官网](https://marketplace.visualstudio.com/vscode)
[vsix-hub](https://www.vsixhub.com)

## 制作插件

```text
安装nodejs
```

## 快捷键

```text
1. 点击左下角齿轮，选择 Keyboard Shortcuts
2. 输入关键字搜索，选中 Record Keys 时可根据快捷键搜索
```

### 窗口/文件切换

* 按快捷键搜索 **Ctrl + J**，删除原有绑定
* **Ctrl + J H**: 切换焦点到 Explorer(View: Show Explorer)
* **Ctrl + J L**: 切换焦点到 Editor(View: Focus Active Editor Group)
* **Alt + H**   : 切换到左侧tab页(View: Open Previous Editor)
* **Alt + L**   : 切换到右侧tab页(View: Open Next Editor)

### 代码跳转

* **Alt + ]**   : 跳转到声明或引用(使用vim默认即可：extension.vim_ctrl+])
* **Alt + O**   : 回退(Go Back)
* **Alt + I**   : 前进(Go Forward)
* **Ctrl + Shift + O**: 显示当前文件所有函数，默认会选中当前函数，按 Enter 跳转到函数名位置

Ctrl-P 在不同 vim 模式下行为:

* Normal | Insert: 搜索 Go to File，将 When 设置为 vim.mode == 'Normal' || vim.mode == 'Insert'
* Command        : 按键搜索上箭头，找到 Command 为 extension.vim_up 一项，添加 Ctrl-P 快捷键后将 When 修改为 vim.mode == 'CommandlineInProgress'

### 运行/调试

* **Shift + F10**: 运行(Run Code)
* **Shift + F9**: 调试(Start Debugging)

### Ctrl + P

[tips](https://code.visualstudio.com/docs/getstarted/tips-and-tricks)

```txt
default : 当前项目 文件名
?       : 查看所有支持操作
@       : 当前文件 symbol, 宏如 函数名、类名、变量名等，按出现顺序排序
@:      : 会将相同类型 symbol 放在一起
#       : 当前项目 symbol
!       : Errors / Warnings
>       : 等同于 Ctrl + Shift + P
```

## settings.json

```yml
files.exclude       : 不显示指定 pattern 文件
search.exclude      : 搜索时跳过指定 pattern 文件，继承 files.exclude
```

```json
{
    "files.exclude": {
        "**/*.o": true
    },
    "search.exclude": {
        "**/*.cmd": true
    }
}
```

### 针对某个文件类型设置

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

```sh
code --list-extensions                      # 查看已安装插件
code --install-extension <extension-name>   # 安装指定插件
```

### Vim

#### 使用 vimrc

设置中搜索 vim.vimrc.enable 勾选，vim.vimrc.path 设置路径

#### vim 快捷键

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
// ctrl + shift + p 搜索 User Settings (JSON)
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
    ],
    "vim.insertModeKeyBindingsNonRecursive": [
        {
            "before": ["alt+j"],
            "after": ["<Esc>"]
        }
    ],
    "vim.commandLineModeKeyBindingsNonRecursive": [
        {
            "before": ["<Alt>-j"],
            "after": ["<Esc>"]
        }
    ]
}
```

<h1 id="vim-foldopen"></h1>

#### 折叠

按 j 时自动打开折叠问题

```text
打开设置，搜索 foldfix，勾选即可
```

#### 中文有问题

切换到 insert mode 输入中文有问题，设置搜索 editor.experimentalEditContextEnabled，关闭 Editor: Edit Context

### Qt Configure

```text
ctrl + shift + p: QtConfigure: Set Qt Dir 选择安装Qt时最顶层目录，配置成功后
ctrl + shift + p: QtConfigure: New Project 根据提示配置项目后就会在当前目录生成qt工程了
```

### WSL

[WSL + vscode](https://zhuanlan.zhihu.com/p/409547049)

### clangd

[clangd](../program_language/c-cpp/clang.md#clangd)

.vscode/settings.json 中设置禁止在 include 下加下划线(其他链接也不会被识别为链接)
[issue](https://github.com/clangd/clangd/issues/630)

```json
{
    "[h]": {
        "editor.links": false
    },
    "[c]": {
    },
    "[cpp]": {
        "editor.links": false
    }
}
```

## Debug

### C/C++

[配置文档](https://code.visualstudio.com/docs/cpp/launch-json-reference)

1. 配置好 launch.json 和 tasks.json
2. 点击左侧 Run and Debug 打开 debug 界面
3. 打断点
4. 点击 Start Debugging 按钮
5. VARIABLES 窗口查看变量
6. TERMINAL 位置点击 DEBUG CONSOLE，可以输入表达式

#### 使用 gdb 原生命令

```sh
-exec <gdb_command>
```

#### 优化显示效果

[pretty-printer](../program_language/c-cpp/gdb调试.md#pretty-printer)

## 禁用 alt 唤起菜单栏

在设置中搜索并应用

```txt
window.titleBarStyle 设置为 custom
window.customMenuBarAltFocus 取消勾选
```

## 配置代码片段 snippets

1. Ctrl-Shift-P 搜索 snippets
2. 点击 Configure Snippets
3. 搜索要配置的文件类型如 cpp
4. 编辑显示的文件
