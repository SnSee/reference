
# python

官方文档: <https://docs.python.org/zh-cn/3/>

## 类型

[官方文档](https://docs.python.org/zh-cn/3/library/typing.html)
[类型注解](https://zhuanlan.zhihu.com/p/386237071)

```python
# 普通类型(int, float, str)
def tmp(a: int) -> int: pass
# 列表
def tmp(a: [int]) -> [int]: pass
# 元组
def tmp(a: tuple[int, int]) -> tuple[int, int]: pass
# 字典
def tmp(a: dict[str, int]) -> dict[str, int]: pass

# typing中的类型
# 无返回值
def tmp() -> typing.NoReturn: pass
# 可以是多个类型
def tmp(a: typing.Union[int, float, None]) -> typing.Union[int, float, None]: pass
def tmp(a: int or float) -> int or float: pass
# 可调用类型(函数，方法)
def tmp(a: typing.Callable) -> typing.Callable: pass
# 设置可调用类型参数类型(dict, str)和返回值类型(int)
def tmp(a: typing.Callable[[dict[str, int], str], int]) -> typing.Callable: pass
def tmp(a: typing.Callable[[str, ...], int]) -> typing.Callable: pass   # 设置可变参数
# 可为空类型
def tmp(a: typing.Optional[int]) -> typing.Optional[int]: pass

# 其他类型
typing.Type                                         # 类类型
T = typing.TypeVar('T')                             # 任意类型
S = typing.TypeVar('S', bound=str)                  # str及其子类类型
A = typing.TypeVar('A', str, bytes)                 # 必须str或bytes类型
U = typing.TypeVar('U', bound=str|bytes)            # str,bytes及其子类类型
V = typing.TypeVar('V', bound=typing.SupportsAbs)   # 任意包含__abs__方法的类型

# 使用typing.TypeVar而不是typing.Any可以使多个参数保持类型一致
```

使用注释方式

```python

def operate(x, y, opt='add'):
    """
    Operate two numbers.

    Parameters
    ----------
    x : int
        First number.
    y : int
        Second number.
    opt : str, optional
        Operation type.

    Returns
    -------
    : int, optional
        Result number or None on invalid opt.
    """
    ret = x + y if opt == 'add' else None
    return ret


print(operate(1, 2))
print(operate(1, 2, opt='add') + 1)
print(operate(1, 2, opt='sub'))
print(operate(1, 2, opt=0))
```

## 数据结构

### list

sort (排序)

```python
list.sort(cmp=None, key=None, reverse=False)    # python3没有cmp
# 使用lambda表达式
l = [[4, 4], [3, 3], [2, 2], [1, 1]]
list.sort(key=lambda x: x[0])
# python3指定排序函数
from functools import cmp_to_key
list.sort(key=cmp_to_key(lambda a, b: a - b))
```

```python
# 将bool类型返回值作为排序依据
lst = ['ABC', 'DFFGHI', 'DEF', 'DFFJKL']
# 使用lambda表达式
lst.sort(key=lambda x: 'DFF' in x, reverse=True)
# 使用回调函数
def _sort(name: str) -> bool:
    return "DFF" in name
lst.sort(key=_sort, reverse=True)
print(lst)  # 结果为：['DFFGHI', 'DFFJKL', 'ABC', 'DEF']
```

```python
# 如果需要多级排序，可将返回值设置int类型
def _sort(name: str) -> int:
    if 'DFF' in name:
        return 0
    if 'DEF' in name:
        return 1
    return 2
lst.sort(key=_sort)
print(lst)  # 结果为：['DFFGHI', 'DFFJKL', 'DEF', 'ABC']
```

```python
# 列表元素为序列, 按序列中某个对象的属性排序
class Info:
    def __init__(self, c):
        self.num = c
ltInfo = [(1, 2, Info(2)), (3, 4, Info(1))]
ltInfo.sort(key=lambda x: x[2].num)
```

[sort使用itemgetter,attrgetter](https://docs.python.org/3/howto/sorting.html#sortinghowto)

```python
from operator import attrgetter, itemgetter


class Attr:
    def __init__(self, a, b, c):
        self.a = a
        self.b = b
        self.c = c

    def __repr__(self):
        return f"({self.a}, {self.b}, {self.c})"

    def __str__(self):
        return self.__repr__()


la = []
li = []
for i in range(1, 3):
    for j in range(1, 3):
        for k in range(1, 3):
            la.append(Attr(i, j, k))
            la.append(Attr(j, k, i))
            la.append(Attr(k, i, j))
            li.append((i, j, k))
            li.append((j, k, i))
            li.append((k, i, j))
la.sort(key=attrgetter("a"))
li.sort(key=itemgetter(0))
assert str(la) == str(li)
print(la)
la.sort(key=attrgetter("a", "b"))   # 多级排序
li.sort(key=itemgetter(0, 1))       # 多级排序
assert str(la) == str(li)
print(la)
```

### dict

```python
# 获取长度为1的dict中数据
my_dict = {'key': 'value'}
key, value = next(iter(my_dict.items()))
```

### 枚举

```python
from enum import Enum

class Color(Enum):
    RED = 1
    GREEN = 2
    BLUE = 3
```

### 抽象类

```python
from abc import ABC, abstractmethod

class MyAbstractClass(ABC):
    @abstractmethod
    def my_abstract_method(self):
        pass

class MyConcreteClass(MyAbstractClass):
    def my_abstract_method(self):
        print("Implementation of abstract method in concrete class")

my_object = MyConcreteClass()
my_object.my_abstract_method()
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

使用变量设置格式化宽度

```python
name = "test"
width = 10
print(f"{name:{width}}###")
```

进度条(progress bar)

```python
print("\r{i}%", end="")
```

移除字符串两端指定字符

```python
'*test*'.strip('*')
```

解决浮点数精度问题

```python
from decimal import Decimal

val1 = Decimal("1.234")
val2 = Decimal("2.567")
print(val1 + val2)
print(val1 - val2)
print(val1 * val2)
print(val1 / val2)
```

## pip

```python
# 此命令将显示一些关于你的Python环境的详细信息，
# 包括操作系统、Python版本、CPU架构和编译器等信息，以及与之对应的PEP 425标识符。
pip debug --verbose

# 查看pip支持的离线安装包版本
import pip._internal
print(pip._internal.pep425tags.get_supported())
```

配置pip选项

```text
# ~/.pip/pip.conf
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
[install]
trusted-host = https://pypi.tuna.tsinghua.edu.cn
```

```bash
# 安装线上包
pip install <package-name>
# 选项
-i                   # 指定pip源: -i http://mirrors.aliyun.com/pypi/simple
--trusted-host       # 指定信任ip
--upgrade            # 升级已经安装的包

# 安装whl包
pip install xxx.whl
# 默认安装在对应的python安装目录/lib/pythonx.x/site-packages下
# 如果没有写权限，会安装在~/.local/lib/pythonx.x/site-packages下
# 选项: 
--no-index                          # 禁止从线上下载依赖库
--prefix=/path/to/install           # 指定安装路径，指定路径下目录结构为lib/python3.x/site-packages
--find-links=/path/to/wheel_files   # 如果本地有依赖的whl包，可以指定包路径
--no-deps                           # 不检查依赖

# 安装tar.gz包
# 解压后会有setup.py文件
python setup.py install --prefix=...    # 会安装
```

## 添加包搜索路径

```text
# 如果没设置 PYTHONHOME, 默认为 python 可执行文件上一级
1.在PYTHONHOME的site-packages下新建 *.pth(*可以任意命名)，并写入包路径
2.通过sys.path.append(path)添加
3.添加到环境变量PYTHONPATH中
```

包查找优先级

```text
1. 可执行文件所在路径
2. $PYTHONPATH 中的路径
3. $PYTHONHOME/lib/pythonxx.zip
4. $PYTHONHOME/lib/pythonxx
5. $PYTHONHOME/lib/pythonxx/lib-dynload
6. ~/.local/lib/pythonxx/site-packages
7. $PYTHONHOME/lib/pythonxx/site-packages
8. $PYTHONHOME/lib/pythonxx/site-packages/*.egg
9. .pth文件中路径

这些路径最终都会被添加到sys.path列表中，按列表顺序查找，可以print查看
```

## tips

```text
指定python路径: #!/path/python
设置utf-8文件格式: # -*- coding:utf-8 -*-

获取当前文件绝对路径: __file__
```

查看python安装位置

```python
# 1. which/where python

# 2. 通过sys查看
import sys
print(sys.executable)
```

### 重定向标准输出(重定向stdout)

重定向到文件

```python
import sys
stdout = sys.stdout
with open('out.txt', 'w+') as file:
  sys.stdout = file     # 重定向标准输出

# 恢复标准输出
sys.stdout = stdout
```

重定向到自定义对象

```python
# 原理: python输出时会调用sys.stdout.write("...")
class MyStdout:
    def __init__(self):
        self.contents = []

    def write(self, output: str):
        self.contents.append(output)

stdout = sys.stdout
ms = MyStdout()
sys.stdout = ms     # 重定向标准输出

# 恢复标准输出
sys.stdout = stdout
```

前两种方式只能重定向python自身的输出，如print输出，python中使用的第三方C库的输出无法重定向

通过dup2重定向(类似与 C 的重定向机制)

```C
// 将oldfd应用到newfd上(向newfd的io将被重定向到oldfd)
int dup2(int oldfd, int newfd);
```

```python
import os
import sys

STDOUT = sys.stdout.fileno()
savedFd = os.dup(STDOUT)        # 保存原始fd
readFd, writeFd = os.pipe()

print("before dup2")
os.dup2(writeFd, STDOUT)        # 重定向
print("after dup2")

os.dup2(savedFd, STDOUT)        # 恢复
os.close(writeFd)
print("after recover")

# 获取重定向捕获内容
texts = []
text = os.read(readFd, 4096)
while text:
    texts.append(text.decode('utf-8'))
    text = os.read(readFd, 4096)
text = ''.join(texts)
os.close(readFd)
print(text)
```

## logging

[参考1](https://blog.csdn.net/qq_15821487/article/details/118090354)

[参考2](https://zhuanlan.zhihu.com/p/476549020)

### 用法

```python
# 输出日志
logging.debug(), logging.info(), logging.warning(), logging.error(), logging.critical()
# 设置日志等级
logging.getLogger().setLevel(logging.DEBUG)
# 一次性设置
logging.basicConfig(level=logging.DEBUG, format="%(levelname)s %(message)s", datefmt="%H:%M:%S", filename="/tmp/test.log", filemode="w")

# 日记记录到文件
logPath = "./log"
formatter = logging.Formatter('%(asctime)s-%(levelname)s: %(message)s')
fh = logging.FileHandler(filename=logPath, encoding='utf-8', mode='a')
fh.setLevel(logging.INFO)
fh.setFormatter(formatter)
logging.getLogger().addHandler(fh)
```

```python
# 为文件日志和终端日志设置不同日志等级
import logging
# logging.basicConfig(level = logging.DEBUG,format = '%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger("vnc")
logger.setLevel(logging.DEBUG) # 最低日志等级
log_format = logging.Formatter('%(asctime)s|%(name)s|%(levelname)-8s|%(message)s')

# 输出到文件
log_file = logging.FileHandler("get_video.log")
log_file.setLevel(logging.DEBUG)
log_file.setFormatter(log_format)
logger.addHandler(log_file)

# 直接输出显示
log_stream = logging.StreamHandler()
log_stream.setLevel(logging.INFO)
log_stream.setFormatter(log_format)
logger.addHandler(log_stream)

# 测试
logger.debug('Python debug')
logger.info('Python info')
logger.warning('Python warning')
logger.error('Python Error')
logger.critical('Python critical')
```

注意：

```python
# 有名称的logger需要设置handler后才会输出，如设置StreamHandler输出到流(默认为sys.stderr)
_log = logging.getLogger("test")
# 输出到标准输出
handler = logging.StreamHandler(sys.stdout)
_log.addHandler(handler)
# 需要同时设置logger和handler的日志等级
_log.setLevel(logging.DEBUG)
handler.setLevel(logging.DEBUG)
_log.debug("debug test")
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
parser.add_argument('--three', nargs=3)              # 必须跟三个值
parser.add_argument('--optional', nargs='?')         # 0或1个值
parser.add_argument('--all', nargs='*')              # 所有值(可以没有)
parser.add_argument('--one-or-more', nargs='+')      # 所有值(至少需要一个)

# 同一参数可指定多次
parser.add_argument('--repeated', action="append")

# 支持参数字符串中有空格(需要使用引号包括整个字符串)
parser.add_argument('--with-space', type=str)

# 互斥参数(暂未找到参数组互斥方法)
group = parser.add_mutually_exclusive_group(required=True)
group.add_argument('-r', '--rule')
group.add_argument('-c', '--config')

# 参数不显示在help中(对group无效)
parser.add_argument('--hide', help=argparse.SUPPRESS)

# 解析
args: argparse.Namespace = parser.parse_args()

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

在装饰器中获取被装饰函数所在文件路径

```python
import inspect

def my_decorator(func):
    def wrapper():
        file_path = inspect.getfile(func)
        func()
    return wrapper

@my_decorator
def test_my_test():
    assert True

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

```python
def subprocessRun(cmd: str, cwd: str) -> str:
    sp = subprocess.run(cmd, shell=True, cwd=cwd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if sp.returncode != 0:
        raise Exception(sp.stderr.decode("utf-8"))
    # 如果subprocess.run中指定了encoding='utf-8'，则stdout是str
    return sp.stdout.decode("utf-8").strip()
```

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

```python
# 获取当前时间
datetime.datetime.now()

# 格式化时间戳
time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(time.time()))
```

## 监听 Ctrl-C

```text
对单线程程序而言，正在运行的程序接收到SIGINT信号后会停止执行原有代码，
并执行通过signal.signal设置的回调函数，如果在回调函数中未退出程序，
则回调函数执行结束后会接着执行原有代码
```

```python
import sys
import time
import signal


def _quit(signum, frame):
    print("call quit")
    print("signum:", signum)
    sys.exit(-1)

# 注册监听回调函数
signal.signal(signal.SIGINT, _quit)
while True:
    time.sleep(1)

# 取消监听
signal.signal(signal.SIGINT, signal.SIG_DFL)
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

## 打包工具

[pyinstaller知乎](https://zhuanlan.zhihu.com/p/470301078)

[下载upx](https://github.com/upx/upx/releases)

```bash
# 打包(多个module只需要指定入口文件即可ke)
pyinstaller test.py

# 打包为单个可执行文件
pyinstaller -F test.py

# 隐藏命令行窗口(windows下打开gui程序时会出现命令行窗口)
pyinstaller -w xxx.py

# 创建虚拟环境打包(有助于减小文件体积)(测试发现没用？)
python -m venv D:/pyvenv

# 使用upx减小文件体积
pyinstaller --upx-dir /where/to/install/upx xx.py
```

## 存根文件(pyi)

根据.py生成.pyi

```bash
# 安装mypy
pip install mypy

# 查看是否安装成功
stubgen -h

# 生成存根文件
stubgen py_file_or_dir
```

## Mess

> 可迭代对象与迭代器

* 可迭代对象需要通过迭代器访问其中的元素
* 可迭代对象与迭代器的关系类似于 C 的数组和数组指针？
* 可迭代对象实现了 **\_\_iter\_\_()** 方法，该方法返回一个迭代器对象
* 假设有一个可迭代对象 **seq**, 可以使用 **iter(seq)** 或者 **for** 循环语法将其转换为迭代器对象
* 迭代器实现了 **\_\_iter\_\_()** 和 **\_\_next\_\_()** 方法，__iter__方法返回迭代器自身，__next__方法产生序列下个值，如果达到末尾则抛出StopIteration异常(for循环不会抛出异常)

```python
from collections.abc import Iterable
from collections.abc import Iterator
from typing import Sequence

x = [1, 2, 3]
assert isinstance(x, Iterable)
assert isinstance(x, Sequence)  # Sequence 相当于 Iterable 别名

it = iter(x)
assert isinstance(it, Iterator)

while True:
    try:
        value = next(it)
        print(value)
    except StopIteration:
        print('end')
        break
```

> yield 关键字

* 用于生成器函数中，它的作用是将一个函数变成一个生成器对象(内置 **__generator** 类型)
* generator 可以理解为一种特殊的迭代器
* 函数在 yield 处会立即返回，并在下次迭代时继续向下执行
* 可以通过 **for** 循环对generator自动迭代
* 当主程序退出时，生成器对象会被销毁
* 用 yield 可以实现协程机制?

适用场景

```text
1. 耗时较长的循环
2. 一次性生成所有值很占内存
```

示例

```python
import inspect
import typing

# typing.Generator[YieldType, SendType, ReturnType]
def show() -> typing.Generator[int, int, int]:
    start = 1
    while start < 3:
        print('============')
        print('before yield')
        yield start
        print('after yield')
        start += 1
    print('************')
    print('before return')
    return start

generator = show()
assert isinstance(generator, typing.Generator)
assert inspect.isgenerator(generator)           # 判断一个对象是否是 generator
assert inspect.isgeneratorfunction(show)        # 判断一个函数是否是 generator 函数

for i in generator:
    print('before print')
    print('print: ', i)
    print('after print')
```

向生成器发送值

```python
def show():
    while True:
        num = yield
        if not isinstance(num, int):
            break
        print(num)
    yield None

g = show()
next(g)
g.send(2)
g.send(1)
g.send('')
```

yield from

* 也用于生成器函数中，但其返回值为另一个迭代器(生成器)的所有值
* 会自动迭代被委派的迭代器，每次从中产出一个元素
* 可以手动在 委派生成器 中捕获 被委派迭代器 抛出的异常，或进行其他操作(如日志？)

```python
def sub_generator():
    print('---------')
    print('sub start')
    for index in range(3):
        print('************')
        print('before yield')
        yield index
        print('after yield')
    print('sub end')
    print('---------')


def main_generator():
    print('==========')
    print('main start')
    yield from sub_generator()
    print('main end')
    print('==========')


generator = main_generator()
assert generator.__name__ == 'main_generator'

for i in generator:
    print('before print')
    print('print:', i)
    print('after print')
```
