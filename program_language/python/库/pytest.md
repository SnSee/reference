
# pytest

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

## 配置文件

pytest.ini

```text
# pytest.ini
[pytest]

# 注册标签
makers = 
    label1
    label2

# logging日志格式
log_format = %(levelname)s:%(message)s
# 默认日志等级
log_level = INFO
```

## 插件

[自定义插件(conftest.py)](https://zhuanlan.zhihu.com/p/157468224)

生成html结果(pytest-html)

```python
pytest --html=./test.html
```

多进程(pytest-xdist)

```python
pytest -n 进程数
# -n 指定为 auto 时表示使用cpu数目
```

重跑失败用例(pytest-rerunfailures)

```python
pytest --reruns 10  --reruns-delay 1    # case失败则1秒后重跑，最多跑10次
# 只重跑指定的异常
pytest --reruns 10 --only-rerun AssertionError --only-rerun ValueError 

# 通过装饰器设置重跑
@pytest.mark.flaky(reruns=1, reruns_delay=5)
def test_rerun():
    pass
```

## tips

检查是否所有case通过测试

```bash
# 0表示全部通过, 1表示有失败case
pytest; echo $?
```

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

调用conftest.py中定义的普通函数

```python
# test.py
# pytest会自动查找conftest路径，无需额外设置
from conftest import my_func
def test():
    my_func()
```

日志

```bash
# 直接使用logging就可以
# 设置显示的日志等级: DEBUG, INFO, WARNING, ERROR, CRITICAL
pytest --log-cli-level=DEBUG

# 在pytest.ini中设置日志格式
[pytest]
log_format = %(levelname)s:%(message)s
# 默认日志等级
log_level = INFO
```
