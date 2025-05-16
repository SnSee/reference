
# 如果命令行参数是目录则进入，否则进入文件所在目录
alias d 'test -d \!* && cd \!* || cd `dirname \!*`; ls'
# 使用粘贴板内容创建/覆盖指定文件
alias cf 'xsel -b > \!*'
alias c 'tr -d "\n" | xsel -b'

set prompt="[%n@%m %c]$ "


# 根据实际的 key 重新映射(可能借助Ctrl-V)
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5c" forward-word
bindkey "^W"      delete-word
bindkey "^H"      backward-delete-word
bindkey "^U"      backward-kill-line
