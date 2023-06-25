
# pycharm

设置python解释器, 安装包, 添加包搜索路径

```text
File -> settings -> Project: xxx -> Python Interpreter
下拉 -> show all
点击 + 添加解释器
    一般选择System Interpreter就可以 -> 选择python可执行文件路径
    (选择Virtualenv Environment可以分离不同项目使用的包)
```

![包](./pics/pycharm_package.png)

修改vim设置

```text
~/.ideavimrc
```

覆盖vim代码跳转快捷键

```text
1. 打开设置，选择 Keymap
2. 搜索 forward/back，将 Navigate -> Forward/Back 改为 Ctrl + I/O
3. 选择 Editor->Vim，找到 Ctrl + I/O, handler 改为 IDE
```

其他快捷键及名称

* **Alt + H**   : 切换到左侧tab页(Editor Tabs -> Select Previous Tab)
* **Alt + L**   : 切换到右侧tab页(Editor Tabs -> Select Next Tab)
* **Ctrl + Tab**: 多个tab页选择
* **Alt + ]**   : 跳转到声明或引用(Go to Declaration or Usages)
* **Alt + O**   : 回退(Navigate -> Back)
* **Alt + I**   : 前进(Navigate -> Forward)
