
# python

官方文档: <https://docs.python.org/zh-cn/3/>

## 数据结构

### list

```python
# 排序
list.sort(cmp=None, key=None, reverse=False)
# 使用lambda表达式
l = [[4, 4], [3, 3], [2, 2], [1, 1]]
list.sort(key=lambda x: x[0])
```

## 格式化字符串

```python
# 指定数据类型
d: 整数
f: 浮点数
s: 字符串
e: 科学计数法

val = 1.2345678
# 20表示占20字符宽度, .3f表示保留3位小数(四舍五入)
# 如果不加 f 则只保留3位有效数字
# 默认右对齐
print(f"{i}, {val:20.3f}")

# 左对齐
print(f"{val:<20.3f}")
# 右对齐，不足位数补x
print(f"{val:x>20.3f}")
# 居中对齐
print(f"{val:^20.3f}")

# 用 , 分隔数字
{:,}

# 进制
d: 十进制
b: 二进制
o: 八进制
x: 十六进制
# 将 val 显示位十六进制字符串
val = 1024
print(f"{val:x}")
```

```python
# 进度条(progress bar)
print("\r{i}%", end="")
```

## pip

```python
# 查看pip支持的离线安装包版本
import pip._internal
print(pip._internal.pep425tags.get_supported())
```

```bash
# 安装whl包
pip install xxx.whl
# 默认安装在对应的python安装目录/lib/pythonx.x/site-packages下
# 如果没有写权限，会安装在~/.local/lib/pythonx.x/site-packages下

# 安装tar.gz包
# 解压后会有setup.py文件
python setup.py install --prefix=...    # 会安装
```

## 添加包搜索路径

```text
1.在site-package下新建 *.pth(*可以任意命名)，并写入包路径
2.通过sys.path.append(path)添加
3.添加到环境变量PYTHONPATH中
```

## tips

```text
指定python路径: #!/path/python
设置utf-8文件格式: # -*- coding:utf-8 -*-

获取当前文件绝对路径: __file__
```

## logging

参考: <https://blog.csdn.net/qq_15821487/article/details/118090354>

### 用法

```python
输出日志
    logging.debug(), logging.info(), logging.warning(), logging.error(), logging.critical()
设置日志等级
    logging.getLogger().setLevel(logging.DEBUG)
一次性设置
    logging.basicConfig(level=logging.DEBUG, format="%(levelname)s %(message)s", datefmt="%H:%M:%S", filename="/tmp/test.log", filemode="w")
```

### 自定义Handler

[csdn介绍](https://blog.csdn.net/qq_45534118/article/details/116804639)

极简示例

```python
import logging


class MyLogHandler(logging.Handler, object):
    def __init__(self):
        logging.Handler.__init__(self)

    def emit(self, record):
        msg = self.format(record)
        print(msg)


if __name__ == "__main__":
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)
    logger.addHandler(MyLogHandler())
    logging.info("this is a test")
```

## windll

```python
# 查看是否具有管理员权限
from ctypes import windll
windll.shell32.IsUserAnAdmin()

# 加载动态库
windll.LoadLibrary(dll_path)

# 申请以管理员方式运行脚本
windll.shell32.ShellExecuteW(None, "runas", sys.executable, <script_path>, None, 1)

# 申请以管理员方式运行当前脚本
windll.shell32.ShellExecuteW(None, "runas", sys.executable, __file__, None, 1)
!!!注意!!! 代码中一定要在判断不具有管理员权限之后再申请，否则会无限运行当前脚本
管理员权限是通过ShellExecutedW启动的程序具有的，而不是申请之前的原脚本具有的
```

## 解析命令行参数

### argparse

[官网](https://docs.python.org/3/library/argparse.html)

[知乎](https://zhuanlan.zhihu.com/p/552954487)

```python
import argparse
# 创建解析器
parser = argparse.ArgumentParser(
    prog="app name",
    usage="用法说明",
    formatter_class=argparse.RawDescriptionHelpFormatter,
    description="app description",
    epilog=""
)

# 注册可选参数
parser.add_argument("-o", "--output", required=True, help="specify output directory.")
parser.add_argument("-gf", "--girlfriend", choices=["Lucy", "Nancy"])
parser.add_argument("--gf_age", type=int, default=18)

# 指定为True，不指定为False
parser.add_argument("--all", action="store_true")

# 指定可选值
parser.add_argument("--gender", choices=["male", "female"])

# 注册位置参数
# 不可指定 - 和 --
parser.add_argument("name")
parser.add_argument("age", type=int)

# 变长参数
parser.add_argument('--three',nargs=3)              # 必须跟三个值
parser.add_argument('--optional',nargs='?')         # 0或1个值
parser.add_argument('--all',nargs='*',dest='all')   # 所有值(可以没有)
parser.add_argument('--one-or-more',nargs='+')      # 所有值(至少需要一个)

# 解析
args = parser.parse_args()

# 获取参数
# 方式一
output_dir = args.output
# 方式二 转换成字典
args = vars(args)
output_dir = args["output"]
```

```bash
parser.py -o ./test -gf Lucy --gf_age 20 Jack 20
# 解析结果
args.output = "./test"
args.girlfriend = "Lucy"
args.gf_age = 20
args.name = "Jack"
args.age = 20
```

### getopt

<https://docs.python.org/3/library/getopt.html>

```python
```

## 装饰器

### 装饰器函数

#### 装饰器无额外参数

```python
from functools import wraps


# 装饰器函数
def decorator(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        # 调用函数前做一些操作
        # ...
        print(func.__name__)
        ret = func(*args, **kwargs)
        # 调用函数后做一些操作
        # ...
        return ret
    return wrapper


# 被装饰的函数
@decorator
def decorated_func():
    pass
```

#### 装饰器有额外参数

```python
from functools import wraps


# 装饰器函数
def decorator(arg1, arg2="test"):
    def real_decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            # 调用函数前做一些操作
            # ...
            print(func.__name__, arg1, arg2)
            ret = func(*args, **kwargs)
            # 调用函数后做一些操作
            # ...
            return ret
        return wrapper
    return real_decorator


# 被装饰的函数
@decorator("decorated")
def decorated_func():
    pass
```

### 装饰器类

## 调用系统命令

```python
# 方式一, ret是str
ret = os.system("ls")

# 方式二
ret = os.popen("ls")
lines = ret.readlines()

# 方式三
sp = subprocess.run("ls", stdout=subprocess.PIPE, shell=True)
sp.returncode   # 0表示执行成功，1表示失败
output = sp.stdout  # 字符串
#sp = subprocess.call()
```

## 子进程

[官网](https://docs.python.org/3/library/subprocess.html?highlight=subprocess#module-subprocess)

[run,call,Popen介绍](https://www.cnblogs.com/hanfe1/p/12885200.html)

### subprocess.Popen

[subprocess.Popen和os.popen区别](https://blog.csdn.net/Ls4034/article/details/89386857)

[介绍](https://blog.csdn.net/super_he_pi/article/details/99713374)

tips

```python
# 以下两个写法等效
subprocess.Popen("ls", shell=True)
subprocess.Popen(["/bin/sh", "-c", "ls"])

#  获取子进程输出
sp = subprocess.Popen("ls", shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, encoding="utf-8")
outptu = sp.stdout.read()
error = sp.stderr.read()
```

## 调用c++

[用法示例](./cpython/cpython.md)

## 常用函数

[当前时间(time/datetime)](https://blog.csdn.net/qq_34321590/article/details/119601285)

## 定时器

```python
import threading

lock = threading.Lock()

def keep_run():
    print("keep run")
    lock.acquire()
    _timer = threading.Timer(1, keep_run)
    _timer.start()
    lock.release()


def once_run():
    print("once run")


if __name__ == '__main__':
    timer = threading.Timer(1, function=once_run)
    # timer = threading.Timer(1, function=keep_run)
    timer.start()
    # timer.cancel()
```

## 监听 Ctrl-C

```python
import sys
import time
import signal


def _quit(signum, frame):
    print("call quit")
    print("signum:", signum)
    sys.exit(-1)


signal.signal(signal.SIGINT, _quit)
while True:
    time.sleep(1)
```

## 函数绑定参数

类似于c++的, bind1st

```python
from functools import partial

def print_three(a, b, c):
    print(a, b, c)

# 3 被绑定给了print_three的第一个参数，即 a
print_bound = partial(print_three, 3)
print_bound(1, 2)
```
