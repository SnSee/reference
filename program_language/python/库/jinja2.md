
# jinja

[英文文档](https://jinja.palletsprojects.com/en/2.10.x/)

[机翻中文文档](http://doc.yonyoucloud.com/doc/jinja2-docs-cn/index.html)

## 用法

加载模板方式一

```python
from jinja2 import Environment, FileSystemLoader

def getTemplate():
    fileLoader = FileSystemLoader('templates')
    env = Environment(loader=fileLoader)
    template = env.get_template('test.txt')
    content = template.render(myvar=123)
```

[更多Loader类型](https://www.jianshu.com/p/b01b692a181e)

加载模板方式二

```python
from jinja2 import Template
template = Template('Hello {{ name }}!')
template.render(name='John Doe')

with open('test.txt') as fp:
    template = Template(fp.read())
template.render(name='Tom')
```

传递变量

```python
# var_name 是模板中使用的变量名称
template.render(var_name=var_value)
```

添加函数

```python
fileLoader = FileSystemLoader('templates')
env = Environment(loader=fileLoader)
env.globals.update(isinstance=isinstance)
# 或
env.globals["isinstance"] = isinstance
```

使用字典及自定义变量

```python
from jinja2 import Template

class Person:
    def __init__(self, name, age):
        self.name = name
        self.age = age

context = {'person': Person("Tom", 18)}
template = Template('{{ person.name }}: {{ person.age }}')
output = template.render(**context)
print(output)
```

## 模板

* 变量用 {{ var }} 包围
* python代码用 {% python_code %} 包围
* 撤销换行(strip)需要在包围符号内用 -，如：
    {{- test }} 取消test之前的换行
    {{ test -}} 取消test之后的换行
    把 - 换成 + 保留换行
* {# 注释 #}

### 循环及控制结构

```text
{% for person in persons %}
    {% if person.age < 18 %}
        {{- person.name }}
    {% else %}
        {{- person.age }}
    {% endif %}
{%- endfor %}
```

### filter 修改变量

[内置filter函数](https://jinja.palletsprojects.com/en/2.10.x/templates/#builtin-filters)

用法示例

```text
{% set s = ['a', 'b', 'c'] -%}
{{ s | join('-') }}             {# 结果为: a-b-c #}
```

### 宏(类似于c的宏)

* 宏可以写在一行或多行
* 宏可以嵌套及递归
* 宏参数可以设置默认值
* 宏内的语句除第一行外其他行默认不会跟随调用位置缩进，可以使用indent设置

```text
{# 定义宏 #}
{% macro macroName(arg) %}
    {% if isinstance(arg, str) %}
        {{- arg }}
    {% else %}
        invalid arg type
    {% endif %}
{% endmacro %}

{# 宏可以写在一行 #}
{% macro getColor(name) %}color:{{ "#ff0000" if name == "red" else "invalid" }}{% endmacro %}

{# 引用宏 #}
COLOR: {{ getColor(colorName) }}; something.
{# 展开后相当于 #}
COLOR: color:{{ "#ff0000" if colorName == "red" else "invalid" }}; something.
```

换行及缩进

```text
{# 宏内第一行不换行，跟随前方字符, 如何要换行，将 -%} 改为 %} #}
{% macro test(arg) -%}
    1
        1.1
    2
{%- endmacro %}
BEFORE
ABCDE: {{ test(myVar) }}
{# 对新行使用4个空格缩进 #}
ABCDE: {{ test(myVar)|indent(4) }}
AFTER
```

### block 继承模板

* 通过关键字 extends 继承模板
* 不能继承多个模板
* 需要使用 FileSystemLoader 方式加载模板

base.txt

```text
BEFORE A
{%- block block_a %}
    in base.txt block_a
{%- endblock %}
AFTER A
```

derive.txt

```text
BEFORE EXTEND                       {# extends之前的语句会正常输出 #}
{% extends "./base.txt" %}             {# 继承模板 #}
AFTER EXTEND                        {# extends 之后的语句都不会输出 #}
{# 在extends之后重写block #}
{% block block_a -%}                {# 重写block #}
    {{ super() }}                   {# 通过super引用原block #}
    in derive.txt block_a
{%- endblock %}
```

### include 包含模板

* 通过关键字 include 关键字导入模板
* 可导入多次

使用 block 的 base.txt 即可

derive.txt

```text
BEFORE B
{% include "base.txt" %}
AFTER B
{% include "base.txt" %}
```

### import 导入模板

* import 语法和 python 一致: import .. as .. 或 from .. import ..

base.txt

```text
BEFORE A
{% macro macro1() %}in base.txt macro1{% endmacro %}
{% macro macro2() %}in base.txt macro2{% endmacro %}
AFTER A
```

derive.txt

```text
{% import "base.txt" as base -%}
{% from "base.txt" import macro2 -%}
BEFORE B
{{ base.macro1() }}
{{ macro2() }}
AFTER B
```
