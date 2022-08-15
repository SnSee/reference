
# jinja

加载模板方式一

```python
from jinja2 import Environment, FileSystemLoader

def getTemplate():
    fileLoader = FileSystemLoader('templates')
    env = Environment(loader=fileLoader)
    template = env.get_template('test.txt')
    content = template.render(myvar=123)
```

加载模板方式二

```python
from jinja2 import Template
template = Template('Hello {{ name }}!')
template.render(name='John Doe')
```
