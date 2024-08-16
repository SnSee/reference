
# pytest

[官网](https://docs.pytest.org)

## 基础介绍

命名规则

```text
模块    : 以 test_ 开头或 _test 结尾
函数名  : 以 test 开头
类名    : 以 Test 开头, 不能自定义 __init__ 方法
方法名  : 以 test 开头
```

case执行顺序

```text
模块按文件名ascii码顺序，文件内从上到下依次执行
```

运行

```python
pytest              # 运行当前路径的case
pytest ./cases      # 运行指定路径的case
# 运行指定模块指定类指定方法(类和方法可以不写，表示全运行)
pytest ./cases/test_case1.py::TestCase1::testFunc1

通过main函数运行
import pytest
pytest.main(["./"]) # 运行当前目录下所有测试用例
```

检查是否满足条件

```python
# 直接使用 assert 就可以
condition = False
assert condition
```

mark(配合pytest.ini和-m选项实现只运行指定mark的case效果)

```python
@pytest.mark.label1
def test_case1():
    pass

@pytest.mark.label1
class TestC:
    @pytest.mark.label1
    def test_caseC(self):
        pass

# 多个标签
@pytest.mark.label1
@pytest.mark.label2
def test_case1():
    pass
```

```bash
pytest -m label
pytest -m "label1 or label2"
```

设置环境变量

```text
通过conftest.py进行设置
```

## 命令行参数

```sh
pytest [options] [file_or_dir, ...]

-s          : 不捕获标准输出，即显示 print 等日志信息
-m          : 只运行指定 mark 的 case
--rootdir   : 指定根目录(创建case名称时将使用该参数), NOT PYTHONPATH!!!
```

## 配置文件

pytest.ini

```text
# pytest.ini
# 全局选项
[pytest]

# 注册标签
makers = 
    label1
    label2

# logging日志格式
log_format = %(levelname)s:%(message)s
# 默认日志等级
log_level = INFO

# 设置运行时额外命令行选项
add_opts = -s
```

## 插件

### 自定义插件

[自定义插件(conftest.py)](https://zhuanlan.zhihu.com/p/157468224)

### html

生成html结果(pytest-html)

```python
pytest --html=./test.html
```

### xdist(多进程)

多进程(pytest-xdist)

```python
pytest -n 进程数
# -n 指定为 auto 时表示使用cpu数目
```

```ini
# pytest.ini
addopts = -n 2      # 设置默认进程数
```

### rerunfailures(重跑)

重跑失败用例(pytest-rerunfailures)

```text
# pytest.ini
[pytest]
addopts --reruns 3 --reruns_delay 5
```

```python
pytest --reruns 10  --reruns-delay 1    # case失败则1秒后重跑，最多跑10次
# 只重跑指定的异常
pytest --reruns 10 --only-rerun AssertionError --only-rerun ValueError 

# 通过装饰器设置重跑
@pytest.mark.flaky(reruns=1, reruns_delay=5)
def test_rerun():
    pass
```

### capturelog(日志)

捕获日志(pytest-capturelog)

```python
def test_my_function(caplog):
    my_function()
    assert "Expected log message" in caplog.text
```

### cov(覆盖率)

[coverage命令测试代码覆盖率](../python.md#coverage)

覆盖率(pytest-cov)

```text
pytest --cov=<name> --cov-report=html

<name>: import的包名或模块名
      如果测试代码涵盖了多个Python包，则需要分别为每个包指定--cov参数。
      此外，可以使用--cov-branch参数来启用深度覆盖测试，以检测每个条件语句是否都被执行到。
```

## tips

### 检查是否所有case通过测试

```bash
# 0表示全部通过, 1表示有失败case
pytest; echo $?
```

### fixture + conftest

注册为fixture的函数可以用函数名直接作为test函数的参数，当执行test函数时会自动调用

使用fixture + conftest.py传递命令行参数

```python
# conftest.py
# pytest会自动调用该函数
def pytest_addoption(parser):
    # 注册命令函参数
    parser.addoption("--index", action="store", type=int, default=None, help="set index")

# 注册fixture函数
@pytest.fixture
def get_index(request):
    return request.config.getoption("--index")
```

```python
# test_index.py
def test_index(get_index):
    print("index is:", get_index)
```

```bash
# bash
pytest --index 2
```

### 定义执行test函数之前自动执行的函数

```python
# conftest.py
@pytest.fixture(autouse=True)
def setup_before_test():
    # 在每个测试函数执行之前执行的代码
    print("Setup before test")
```

### fixture 定义 test case 之前之后执行的装饰器

```py
# 需要在指定测试函数手动调用，如需自动调用添加参数 autouse=True
# scope: 指定作用域为 module，即每个 module 调用一次(默认为 function)
@pytest.fixture(scope='module', autouse=True)
def module_scope():
    print('\n***** before module *****')
    # 对于手动指定的 fixture 可以获取 yield 返回值
    yield 'yield-value-of-module_scope'
    print('***** after module *****')

@pytest.fixture(scope='function', autouse=True)
def func_scope():
    print('\n+++ before function +++')
    yield
    print('+++ after function +++')

def test_case1(module_scope):
    print('testcase 1')
    # 获取 yield 返回值
    print('yield value:', module_scope)

def test_case2():
    print('testcase 2')
```

### 调用conftest.py中定义的普通函数

```python
# test.py
# pytest会自动查找conftest路径，无需额外设置
from conftest import my_func
def test():
    my_func()
```

### 日志

#### 日志显示

```bash
# 直接使用logging就可以
# 设置显示的日志等级: DEBUG, INFO, WARNING, ERROR, CRITICAL
pytest --log-cli-level=DEBUG

# 不显示捕获的日志
pytest --show-capture=no
    # print()语句打印的输出
    # 标准输出（sys.stdout）捕获的输出
    # 标准错误输出（sys.stderr）捕获的输出
    # caplog fixture捕获的日志
```

```ini
# 在pytest.ini中设置日志格式
[pytest]
log_format = %(levelname)s: %(message)s
# 日志等级
log_level = INFO

# 开启实时日志(输出到控制台的日志)
log_cli = True
# 实时日志等级
log_cli_level = INFO
# 实时日志格式
log_cli_format = %(levelname)s: %(message)s
```

#### 检查日志内容

**注意:** 不能使用 -s(--show-capture=no) 选项

```py
import logging
# 使用自带日志捕获器，名称固定为 capsys
def test_log(capsys):
    msg = 'log message'
    print(msg)
    assert capsys.readouterr().out.strip() == 'log message'

```

#### 捕获 logging 日志的方式

方式一

```py
def test_log(capsys):
    # 不推荐，多个case可能会乱
    logging.getLogger().addHandler(logging.StreamHandler())
    # 同上
```

方式二

```py
import logging
import pytest

class MyLogHandler(logging.Handler, object):
    def __init__(self):
        logging.Handler.__init__(self)
        self._logs = []
    
    def get_logs(self, clear=True):
        logs = [line for line in self._logs]
        if clear:
            self._logs.clear()
        return logs

    def emit(self, record):
        self._logs.append(self.format(record))

@pytest.fixture
def log_handler():
    handler = MyLogHandler()
    logging.getLogger().addHandler(handler)
    logging.getLogger().setLevel(logging.INFO)
    yield handler
    logging.getLogger().removeHandler(handler)

def test_log(log_handler):
    msg = 'logging info message'
    logging.info(msg)
    assert log_handler.get_logs()[0] == msg
```

### 借助装饰器为 test 传参

```py
@pytest.mark.parametrize('a, b', [(1, 0), (2, 0)])
def test_divide_by_zero(a, b):
    print('check:', a, b)
    assert a + b < 10
```

### 异常

必须抛出指定异常

```py
import pytest

def divide(a, b):
    if b == 0:
        raise ValueError("不能除以零1")
    return a / b

def test_divide_by_zero():
    # match 参数实际匹配时使用的是 re.search
    with pytest.raises(ValueError, match=r"^不能除以零$"):
        divide(1, 0)
```

```py
@pytest.mark.parametrize("a, b", [(1, 0), (2, 0)])
def test_divide_by_zero(a, b):
    with pytest.raises(ZeroDivisionError, match=r"^division by zero$"):
        print(a / b)
```
