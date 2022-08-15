:: 作用: 使用ftp上传单个文件
:: 用法一: ftp_upload.bat file_path
:: 用法二: 添加到右键菜单(参考 reference/os/windows/设置/鼠标相关.md)

@echo off
:: 服务器信息，需要设置 user, code, target_dir
set ip=192.168.10.65
set user=ic
set code=Microbt.com
set target_dir=/yinchuanduo


set upload_file=%1
set tmp_cmds=.ftp_upload_cmds.txt

:: 在临时文件中创建ftp命令
echo %user%> %tmp_cmds%
echo %code%>> %tmp_cmds%
echo cd %target_dir%>> %tmp_cmds%
echo put %upload_file%>> %tmp_cmds%
echo bye>> %tmp_cmds%


:: 登录服务器并执行临时文件中的ftp命令
ftp -s:%tmp_cmds% %ip%


:: 删除临时文件
del %tmp_cmds%
