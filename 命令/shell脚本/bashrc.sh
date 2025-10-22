PS1='[\u@\h \W]$ '

# 如果命令行参数是目录则进入，否则进入文件所在目录
alias d='function _mycd(){ [ -d $1 ] && cd $1 || cd `dirname $1`; ls; };_mycd'
# 使用粘贴板内容创建/覆盖指定文件
function cf() {
    xsel -b > $1
}
alias c='tr -d "\n" | xsel -b'

bind -f /etc/inputrc
# 根据实际的 key 重新映射(可能借助Ctrl-V)
bind '^?:backward-kill-word'       # Ctrl-backspace 删除前一个单词

# 使用 vi 方式编辑命令行
set -o vi
bind -m vi-insert '"\C-p": previous-history'
bind -m vi-insert '"\C-n": next-history'
# 设置 vi 模式下光标样式(部分终端不支持)
bind 'set show-mode-in-prompt off'
bind 'set vi-ins-mode-string \1\e[5 q\2'    # insert 模式下为闪烁竖线
bind 'set vi-cmd-mode-string \1\e[2 q\2'    # normal 模式下为静止方块
