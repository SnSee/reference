
# python

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
# 进度条
print("{i}%", end="")
```

## pip

```python
# 查看pip支持的离线安装包
import pip._internal
print(pip._internal.pep425tags.get_supported())
```

## 添加包搜索路径

```python
1.在site-package下新建 *.pth(*可以任意命名)，并写入包路径
2.通过sys.path.append(path)添加
3.添加到环境变量PYTHONPATH中

指定python路径: #!/path/python
设置utf-8文件格式: # -*- coding:utf-8 -*-

获取当前文件绝对路径: __file__
```

## logging

参考: <https://blog.csdn.net/qq_15821487/article/details/118090354>

```python
输出日志
    logging.debug(), logging.info(), logging.warning(), logging.error(), logging.critical()
设置日志等级
    logging.getLogger().setLevel(logging.DEBUG)
一次性设置
    logging.basicConfig(level=logging.DEBUG, format="%(levelname)s %(message)s", datefmt="%H:%M:%S", filename="/tmp/test.log", filemode="w")
自定义Handler
    https://blog.csdn.net/qq_45534118/article/details/116804639
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

<https://docs.python.org/3/library/argparse.html>

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
# 注册位置参数
# 不可指定 - 和 --
parser.add_argument("name")
parser.add_argument("age", type=int)

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
