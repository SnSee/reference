
# pdb

## 启动

```python
python3 -m pdb test.py -- arg1 arg2
```

## 调试命令

<!-- markdownlint-disable-next-line no-emphasis-as-heading -->
**h: 查看帮助**

```pdb
b <line>        # 断点
l [line]        # 查看代码，不指定行号再次查询时会自动调到下个10行
                # 指定 . 查看当前断点附近代码
ll              # 查看当前整个函数代码
bt              # 堆栈
p <var>         # 打印变量
pp <var>        # 打印变量(优化显示效果)
a               # 打印函数参数
n               # 下一行
s               # 进入当前行函数
c               # 下一个断点
r               # 执行代码直到当前函数返回
u               # 上一级堆栈
d               # 下一级堆栈
q               # 退出
设置变量         # 直接使用python语法即可，变量不要和命令重名
调用函数         # 直接使用python语法即可
source <file>   # 批量加载命令
```

### break(b)

```txt
b(reak) [ ([filename:]lineno | function) [, condition] ]
```

```sh
# 显示所有断点
b

# 删除指定编号断点
cl 1

# 为函数设置断点
b func_name
b module_name.func_name

# 指定具体文件的断点(加不加 .py 都行)
b module_name:<line>
b module_name.py:<line>

# 指定条件
b func_name, i > 1
```

### up/down

```sh
u 3         # 向上跳转 3 级函数栈
d 3         # 向下跳转 3 级函数栈
```
