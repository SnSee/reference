
# 如果命令行参数是目录则进入，否则进入文件所在目录
alias d 'test -d \!* && cd \!* || cd `dirname \!*`; ls'
# 使用粘贴板内容创建/覆盖指定文件
alias cf xsel -b > !*
