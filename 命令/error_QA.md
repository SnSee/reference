
# ERROR QA

> csh创建新的终端时提示Can't load history: $< line too long

清空~/.history或手动编辑，删除过长行

> xxx.so: undefined reference to __func()@CXXABI_1.3.13 表示什么意思

1. xxx.so : 用户通过 xxx.so 中的某个函数间接调用了 \__func 函数
2. 后面的部分表示在链接时从标准库 libstdc++.so 中未找到指定版本的 \__func 函数
