
# tmux

[github源码](https://github.com/tmux/tmux)
[使用教程](https://www.kancloud.cn/kancloud/tmux/62459)

[安装pkg-config](../环境/linux.md#pkg-config)
[安装libevent](../环境/linux.md#libevent)

```sh
sh autogen.sh
./configure --prefix=/install/dir
make -j 8 && make install
```

[快捷键](https://zhuanlan.zhihu.com/p/628396742)

自定义配置

```sh
# ~/.tmux.conf
set -g prefix C-j           # 设置 leader-key(前缀键)
unbind C-b                  # 解除绑定按键
bind C-j send-prefix        # 确保可以向其它程序发送 Ctrl-j

set -sg escape-time 1       # 设定前缀键和命令键之间的延时

set -g base-index 1         # 把窗口的初始索引值从 0 改为 1
setw -g pane-base-index 1   # 把面板的初始索引值从 0 改为 1

# 使用 Prefix r 重新加载配置文件
bind r source-file ~/.tmux.conf \; display "Reloaded!"

# 分割面板
bind O split-window -h
bind o split-window -v

# 在面板之间移动
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# 快速选择面板
bind -r C-h select-window -t :-
bind -r C-l select-window -t :+

# 调整面板大小
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# 设置默认的终端模式为 256 色模式
set -g default-terminal "screen-256color"

# 开启活动通知
setw -g monitor-activity on
set -g visual-activity on

# 设置状态栏的颜色
set -g status-fg white
set -g status-bg black

# 设置状态栏左侧的内容和颜色
set -g status-left-length 40
set -g status-left "#[fg=green]Session: #S #[fg=yellow] #I #[fg=cyan] #P"

# 设置状态栏右侧的内容和颜色
# 15% | 28 Nov 18:15
# set -g status-right "#(~/battery Discharging) | #[fg=cyan]%d %b %R"

set -g status-interval 60           # 每 60 秒更新一次状态栏
# set -g status-justify centre        # 设置窗口列表居中显示

setw -g mode-keys vi                # 开启 vi 按键

# 复制
bind v copy-mode                    # 绑定v键进入复制模式
unbind p                            # 解除原绑定
bind p paste-buffer                 # 绑定p键为粘贴文本
# 复制模式下按v开始选择文本(vi visual模式)
bind -T copy-mode-vi v send-keys -X begin-selection
# 复制模式下按v开始选择文本(vi visual模式)
bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel

# 鼠标支持 - 如果你想使用的话把 off 改为 on
set -g mouse on
set -g mouse-select-pane on
set -g mouse-resize-pane on
set -g mouse-select-window on

# 在相同目录下使用 tmux-panes 脚本开启面板
# unbind v
# unbind n
# bind v send-keys " ~/tmux-panes -h" C-m
# bind n send-keys " ~/tmux-panes -v" C-m

# 临时最大化面板或恢复面板大小
# unbind Up
# bind Up new-window -d -n tmp \; swap-pane -s tmp.1 \; select-window -t tmp
# unbind Down
# bind Down last-window \; swap-pane -s tmp.1 \; kill-window -t tmp

# 把日志输出到指定文件
# bind P pipe-pane -o "cat >>~/#W.log" \; display "Toggled logging to ~/#W.log"
```

```sh
tmux                # 创建会话

# 以下快捷键都需要先输入 leader-key
o           # 横向分屏
O           # 纵向分屏
hjkl        # 窗口跳转
x           # 最大化当前窗口，再次执行恢复原大小
;           # 回到上次使用的窗口
q           # 显示窗口编号，有编号时按对应数字跳转到窗口
x           # 关闭当前窗口
:           # 进入命令模式
d           # 退出 tmux
?           # 列出所有快捷键，q 退出
[           # 进入复制模式，操作同 vi
v           # 进入复制模式，操作同 vi
=           # 在单独的窗口列出粘贴板缓冲区所有内容，使用jk移动，Enter选择后粘贴
```

vim 颜色过深问题，在 ~/.vimrc 中添加

```vim
set background=dark
set t_Co=256
```

## tmux 配置

```sh
# 查看所有配置
tmux show-options -g
# 查看指定配置项值
tmux show-options -g <key>

# 设置
tmux set-option -g <key> <value>
# 取消设置
tmux set-option -gu <key> <value>

# 查看所有快捷键
tmux list-keys
# 查看指定模式下所有快捷键快捷键
tmux list-keys -T <key>
```

```sh
# 设置使用的shell类型
tmux set-option -g default-shell "/bin/bash"
```
