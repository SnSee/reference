PS1='[\u@\h \W]$ '

# 如果命令行参数是目录则进入，否则进入文件所在目录
alias d='function _mycd(){ [ -d $1 ] && cd $1 || cd `dirname $1`; ls; };_mycd'
# 使用粘贴板内容创建/覆盖指定文件
function cf() {
    xsel -b > $1
}
alias c='tr -d "\n" | xsel -b'
