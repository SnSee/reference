
# python

官方文档: <https://docs.python.org/zh-cn/3/>

[库函数文档](https://docs.python.org/3.9/library/index.html)

[命令行参数](https://docs.python.org/3/using/cmdline.html#using-on-general)

```sh
python -c 'print("Hello World!")'   # 执行字符串中的代码
# 相当于python test.py? 会自动搜索sys.path中的module?
python -m test                      
```

## 关键字

### with ... as

```txt
原理：
    通过with调用函数/类时:
        进入作用域调用 __enter__()
        退出作用域调用 __exit__()，因此可以进行清理操作
    as 后的对象即是 __enter__ 返回的对象
```

创建可以通过 with 调用的结构

```python
class Scope:
    def __init__(self, num: int):
        self.num = num
        print('init:', self.num)

    def show(self):
        print('num:', self.num)

    def __enter__(self):
        print("enter:", self.num)
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        print("exit before clear:", hasattr(self, 'num'))
        del self.num        # 清理数据
        print("exit before clear:", hasattr(self, 'num'))

def scope_wrapper(num: int):
    print("scope wrapper")
    return Scope(num)

# 通过类对象直接调用
with Scope(1) as s:
    s.show()
# 通过函数接口调用
with scope_wrapper(2) as s:
    s.show()
```

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

列表推导

```python
# 一维列表
line = [1, 2, 3]
print([num for num in line if num > 1])

# 二维列表
matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
# 二维转一维
print([num for row in matrix for num in row])
# 保持二维
print([[num for num in row] for row in matrix])
```

切片

```python
line = [1, 2, 3, 4, 5]
# m 不写表示从头开始，n 不写表示到末尾
l2 = line[m:n]              # 创建新列表，元素为原list中 [m, n)
line[m:n] = Iterable        # [m, n) 替换为新序列内元素
line[m:n] = []              # 移除 [m, n) 元素
```

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

### 嵌套dict

遇到不存在key时自动插入数据

```python
class NestedDict(dict):
    def __missing__(self, key):
        self[key] = NestedDict()
        return self[key]
```

### set

#### 交集

```python
s1 = {1, 2}
s2 = {1, 3}

# 不修改源 set
s3 = s1.intersection(s2)    # {1}
```

#### 并集

```python
s1 = {1}
s2 = {2}

s3 = s2
# 修改源 set
s3.update(s1)       # {1, 2}

# 不修改源 set
s4 = s1.union(s2)   # {1, 2}
```

#### 差集

```python
s1 = {1, 2}
s2 = {1, 3}

# 不修改源 set
s3 = s1.difference(s2)      # {2}
s4 = s1 - s2                # {2}
```

### 枚举

```python
from enum import Enum

class Color(Enum):
    RED = 1
    GREEN = 2
    BLUE = 3

# 转换为 int 值
print(Color.RED.value, type(Color.RED.value))
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

## 序列操作

### 切片

基本语法: **seq[start:stop:step]**
**start:** 默认为 0，负数表示从后往前数索引，如 -1 表示最后一位
**stop:** 默认为序列尾部，不可取到，负数同 start
**step:** 默认为 1，索引递增值，可以为负数，表示从后往前遍历

```py
seq = [0, 1, 2, 3, 4]

print('1:', seq[:])           # 0, 1, 2, 3, 4
print('2:', seq[::-1])        # 4, 3, 2, 1, 0
print('3:', seq[1:3])         # 1, 2
print('4:', seq[1:3:-1])      # 空
print('5:', seq[-3:-1])       # 2, 3
print('6:', seq[-3:-1:-1])    # 空
print('7:', seq[-1:-3:-1])    # 4, 3
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

```sh
# 安装
sudo apt update
sudo apt install pip
```

[pip源](../../website.md#编程)

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

在线安装脚本

```sh
#!/bin/bash
pip install $1 -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
```

```sh
# 查看指定库的版本
pip show package_name
# 查看所有已安装包
pip list
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
logging.basicConfig(level=logging.DEBUG, format="%(levelname)s %(message)s", datefmt="%Y-%m-%d %H:%M:%S", filename="/tmp/test.log", filemode="w")

logging.getLogger().addHandler(handler)         # 添加 handler
logging.getLogger().removeHandler(handler)      # 移除 handler

# 日记记录到文件
logPath = "./log"
open(logPath, 'w').close()
formatter = logging.Formatter('%(asctime)s-%(levelname)s: %(message)s', datefmt="%Y-%m-%d %H:%M:%S")
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
# 指定为False，不指定为True
parser.add_argument("--all", action="store_false")

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

# 指定存储的变量名称
group.add_argument('-v', dest='var_name')   # args.var_name 获取参数值

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

## 闭包

* 闭包内变量(count)是绑定在outer返回的对象上的，而不是绑定在outer函数上的
* 闭包方式实现的装饰器内部变量可以看作是绑定在被outer装饰的函数上的

简单示例

```py
def outer():
    count = 0
    def inner():
        nonlocal count
        count += 1
        print('call count:', count)

    return inner

if __name__ == '__main__':
    func1 = outer()
    func1()          # count: 1
    func1()          # count: 2
    func2 = outer()
    func2()          # count: 1
    func2()          # count: 2
```

装饰器

```py
def outer(func):
    count = 0
    def inner(*args, **kwargs):
        nonlocal count
        count += 1
        print(f'{func.__name__} call count:', count)
        return func(*args, **kwargs)

    return inner

@outer
def tmp1():
    pass

@outer
def tmp2():
    pass

if __name__ == '__main__':
    tmp1()       # count: 1
    tmp1()       # count: 2
    tmp2()       # count: 1
    tmp2()       # count: 2
```

## 装饰器

### 装饰器函数

#### 装饰器无额外参数

```txt
functools.wraps 能够保留被装饰后函数的元信息，如 函数名称(__name__) 等
```

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

核心原理：在定义的最外层装饰器函数中添加参数，该参数会将调用装饰器时指定的参数拿走，而后python会自动将函数对象传递给装饰器返回的函数，从而完成调用。

不使用 functools.wraps

```python
def decorator(arg):
    def real_decorator(func):
        def wrapper(*args, **kwargs):
            print(f"Decorator argument: {arg}")
            return func(*args, **kwargs)
        return wrapper
    return real_decorator


@decorator("test")
def decorated_func():
    print(f"in decorated_func")
```

使用 functools.wraps

```python
from functools import wraps


# 装饰器函数
def decorator(arg1):    # 如果有多个参数直接添加
    def real_decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            # 调用函数前做一些操作
            # ...
            print(func.__name__, arg1)
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

#### 装饰器实现 override

```python
import functools

def override(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs) -> object:
        func_name = func.__name__
        assert len(args) > 0 and hasattr(args[0], func_name), f'{func_name} is not class method'
        self = args[0]
        for _parent in self.__class__.__bases__:
            if hasattr(_parent, func_name):
                return func(*args, **kwargs)
        raise ValueError(f"Method {func_name} is not overridden from parent class.")
    return wrapper

class P1:
    def m1(self, num: int):
        print("P1 m1:", num)

    @classmethod
    def c1(cls):
        print("P1 c1")

class P2:
    def m2(self):
        print("P2 m2")

class Child(P1, P2):
    @override
    def m1(self, num: int):
        print("Child m1:", num)

    @override
    def m2(self):
        print("Child m2")

    @classmethod
    @override
    def c1(cls):
        print("Child c1")

    @override
    def m3(self):
        pass

obj = Child()
obj.m1(1)       # 只能对成员方法使用 @override
obj.m2()
# obj.c1()
# obj.m3()
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

## 子进程 subprocess

[官网](https://docs.python.org/3/library/subprocess.html?highlight=subprocess#module-subprocess)

[run,call,Popen介绍](https://www.cnblogs.com/hanfe1/p/12885200.html)

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

### 不等待命令结束

```python
print('before')
subprocess.Popen([command], shell=True, start_new_session=True)
print('after')
```

### 超时退出

```python
import subprocess

try:
    subprocess.run('sleep 5', shell=True, timeout=1)
except subprocess.TimeoutExpired:
    print("subprocess timeout")
```

### 子进程 tips

```python
# 以下两个写法等效
subprocess.Popen("ls", shell=True)
subprocess.Popen(["/bin/sh", "-c", "ls"])

#  获取子进程输出
sp = subprocess.Popen("ls", shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, encoding="utf-8")
outptu = sp.stdout.read()
error = sp.stderr.read()
```

### 实时显示子进程日志

```python
# 方式一: 需要子进程刷新缓冲后才能输出: 1. 缓冲区满刷新；2.使用 sys.stdout.flush() 手动刷新；3.子进程退出刷新
import subprocess

process = subprocess.Popen(['command', 'arg1', 'arg2'], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
for line in iter(process.stdout.readline, ''):
    print(line.strip())
process.wait()

# 方式二：直接将子进程输出刷新到当前标准输出
process = subprocess.Popen(['command', 'arg1', 'arg2'], stdout=sys.stdout, stderr=sys.stderr, text=True)
process.wait()

# 方式三：输出到文件，同样有方式一的刷新问题
with open('tmp', 'w') as fp:
    process = subprocess.Popen(['command', 'arg1', 'arg2'], stdout=fp, stderr=fp, text=True)
    process.wait()
```

## 调用c++

[用法示例](./cpython/cpython.md)

## 继承

```python
class A:
    def __init__(self):
        print('init A')

    def name(self):
        print('A')

class B(A):
    def __init__(self):
        super().__init__()
        print('init B')

    def name(self):
        print('B')

class C(A):
    def __init__(self):
        super().__init__()
        print('init C')

    def name(self):
        print('C')

class D(B, C):
    def __init__(self):
        super().__init__()
        print('init D')

    def name(self):
        super().name()          # B
        super(B, self).name()   # C
        super(C, self).name()   # A

        # 推荐使用这种方式调用
        A.name(self)            # A
        B.name(self)            # B
        C.name(self)            # C

D().name()
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

partial 用于绑定普通函数，partialmethod 用于绑定类方法

```python
from functools import partial

def print_three(a, b, c):
    print(a, b, c)

# 3 被绑定给了print_three的第一个参数，即 a
print_bound = partial(print_three, 3)
print_bound(1, 2)

# 绑定给指定形参
print_bound = partial(print_three, c=3)
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

## 提升性能技巧

### 数学运算

使用 a += b 替代 a = a + b

```python
a = 1
b = 2
b += a      # 替代 b = b + a
```

多次运算放在一个表达式中

```python
a = 1
b = 2
c = 3
c += (a + b)    # 替代 c += a; c += b
```

不要使用临时变量

```python
a = 2
c = 0
c += pow(a, 2)  # 替代 b = pow(a, 2); c += b
```

### 内存优化

[知乎](https://zhuanlan.zhihu.com/p/678036511)

查看内存占用

```python
# 查看对象实际占用字节数
print(sys.getsizeof(1))

# 查看进程当前占用内存字节数
print(psutil.Process().memory_info().rss)
```

#### 使用 slots 明确规定类成员变量名

类成员属性必须是 \_\_slots\_\_ 中包含的字符串，方法名称可以是其他的。

```python
class Person:
    __slots__ = ('name', 'age')

    def __init__(self):
        self.name = ''

    def job(self): pass

p = Person()
p.age = 10          # 允许
# setattr(p, 'age', 10)
# p.height = ''       # 不允许, 无法插入不在 slots 中的属性
```

#### 使用生成器(Generator)

```python
def gen() -> typing.Generator:
    for i in range(10):
        yield i
for n in gen():
    print(n)
```

将列表推到的 [] 换成 () 即是生成器

```python
for n in (i for i in range(10)):
    print(n)
```

#### 内存映射(mmap)

测试发现当文件过小(<1k?)或过大(>500M?)时速度区别不明显

```python
import mmap

with open('a', 'r') as fp:
    with mmap.mmap(fp.fileno(), 0, access=mmap.ACCESS_READ) as mm:
        while True:
            line = mm.readline()
            if not line:
                break
            print(line.decode('utf-8'), end='')
```

## 注意事项

### 静态变量

#### 使用 self 引用int/float 等不可变类型静态变量可能存在的问题

对于不可变类型，改变其值时内存地址也会跟着改变，导致通过 self 操作的修改实际作用是创建了新的变量，而原静态变量地址不变，即静态变量值未被修改，可以直接通过类引用进行修改

```python
class T:
    _i = 0

    def __init__(self):
        self.i = self._i
        print('T', id(T._i))
        self._i += 1                # 修改不可变类型，内存地址改变，相当与创建了成员变量(覆盖类变量)
        print('T', id(T._i))        # 地址不变
        print('S', id(self._i))     # 地址和 T 不一致
        T._i += 1                   #
        print('T', id(T._i))        # 地址改变，但是可能和 S 一致，因为内部复用了整型变量地址
        T._i += 1                   # 修改不可变类型，内存地址改变，又将该地址绑定到了类变量
        print('T', id(T._i))        # 地址改变

t = T()
```

## coverage

[coverage文档](https://coverage.readthedocs.io)

### 文件覆盖率

#### 测试命令

```sh
# 覆盖旧覆盖率
coverage run test.py
-a/--append : 重新运行时保留原有覆盖率
--branch    : 分支覆盖率
--source=SRC1,SRC2,...      指定要计算覆盖率的源码路径

# pattern 匹配方式: 文件名(basename) match 或 完整路径 match
--include=PAT1,PAT2,...     只计算指定pattern文件路径(使用通配符需要放在双引号内)
--omit=PAT1,PAT2,...        忽略指定pattern文件路径(使用通配符需要放在双引号内)
--rcfile=RCFILE             配置文件(搜索 configuration file 查看用法，sample file 查看示例)


# 增量式(在旧覆盖率基础上新增覆盖率)
coverage run --append test.py 1
coverage run --append test.py 2
coverage run --append test.py 3

# 生成测试报告
coverage html
--skip_covered              不显示覆盖率 100% 的文件

# 合并测试报告
coverage combine --keep -a dir1/.coverage dir2/.coverage dir3/.coverage ...
```

使用 pytest

```sh
coverage run [options...] -m pytest [args...]
```

测试文件

```py
# test.py
import sys

def test():
    if len(sys.argv) < 2:
        print('no arg')
    elif sys.argv[1] == '1':
        print(1)
    elif sys.argv[1] == '2':
        print(2)
    else:
        print('other')

if __name__ == '__main__':
    test()
```

rcfile 示例

[文档](https://coverage.readthedocs.io/en/7.5.4/config.html#configuration-reference)

```txt
[run]
branch = False
; 指定测试覆盖率路径
source = 
    /tmp/src1
    /tmp/src2

; 指定只测试哪些文件
include = 
    /tmp/*/*.py

; 忽略的文件
omit =
    # omit anything in a .local directory anywhere
    */.local/*
    # omit everything in /usr
    /usr/*
    # omit this single file
    utils/tirefire.py

[report]
; Regexes for lines to exclude from consideration
exclude_also =
    ; Don't complain about missing debug-only code:
    def __repr__
    if self\.debug

    ; Don't complain if tests don't hit defensive assertion code:
    raise AssertionError
    raise NotImplementedError

    ; Don't complain if non-runnable code isn't run:
    if 0:
    if __name__ == .__main__.:

    ; Don't complain about abstract methods, they aren't run:
    @(abc\.)?abstractmethod

ignore_errors = True

[html]
directory = coverage_html_report
skil_covered = False
```

## 设计模式

### 单例模式

```py
def singleton(cls):
    instances = {}

    def get_instance(*args, **kwargs):
        if cls not in instances:
            instances[cls] = cls(*args, **kwargs)
        return instances[cls]

    return get_instance


@singleton
class Test1:
    def __init__(self, val: int):
        self.val = val
        print('Test1 init:', val)


@singleton
class Test2:
    def __init__(self, val: int):
        self.val = val
        print('Test2 init:', val)


t11 = Test1(11)
t12 = Test1(12)     # 不会创建新对象
t2 = Test2(2)
print(t11 is t12)
print(t11 is t2)
```

## 调用 tcl

```py
import tkinter

tcl = tkinter.Tcl()
tcl.eval("puts {Hello, Tcl!}")
result = tcl.eval("set abc 123")
print("abc1 =", result)
print("abc2 =", tcl.eval("set abc"))
try:
    print(tcl.eval("set not_exist"))
except tkinter.TclError as e:
    print('Error:', str(e))
```
