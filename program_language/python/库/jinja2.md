
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

```text
变量用 {{ var }} 包围
python代码用 {% python_code %} 包围
换行需要在包围符号内用-, 如 {{- }}, {%- -%}，每个 - 换一次行，因此一般一组符号内用一个
{# 注释 #}
```

循环及控制结构

```text
{% for person in persons %}
    {% if person.age < 18 %}
        {{- person.name }}
    {% else %}
        {{- person.age }}
    {% endif %}
{%- endfor %}
```

宏(类似于c的宏)

```text
宏内的语句不会跟随调用位置缩进
宏可以嵌套
宏可以写在一行或多行
宏可以递归调用
```

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
