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
