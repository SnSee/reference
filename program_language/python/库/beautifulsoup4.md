
# beautifulsoup

解析html文件

```python
from bs4 import BeautifulSoup

# 打开本地HTML文件
with open('example.html', 'r', encoding='utf-8') as f:
    html_content = f.read()

# 解析HTML文件
soup = BeautifulSoup(html_content, 'html.parser')

# 可以使用下面的代码来查看解析结果
print(soup.prettify())
```

获取class为detail_level的元素列表

```python
elements1: list[bs4.element.Tag] = soup1.find_all(class_='detail_level')
```

递归比较两个元素的内容是否相同

```python
def elementsSame(e1: bs4.element.Tag, e2: bs4.element.Tag, levels: list[str]) -> bool:
    if e1.name != e2.name or e1.text != e2.text or len(e1.contents) != len(e2.contents):
        print(levels)
        print(f'name: {e1.name:20} vs {e2.name}')
        print(f'text: {e1.text:20} vs {e2.text}')
        print(f'size: {len(e1.contents):20} vs {len(e2.contents)}')
        return False
    for se1, se2 in zip(e1.contents, e2.contents):
        if type(se1) != type(se2):
            assert isinstance(se2, bs4.element.NavigableString) or isinstance(se1, bs4.element.NavigableString)
            assert isinstance(se1, bs4.element.NavigableString) or isinstance(se2, bs4.element.NavigableString)
            desc1 = se1.name if isinstance(se1, bs4.element.Tag) else se1.strip()
            desc2 = se2.name if isinstance(se2, bs4.element.Tag) else se2.strip()
            print(levels)
            print(f'type: {type(se1):20} vs {type(se2)}')
            print(f'desc: {desc1:20} vs {desc2}')
            return False
        if hasattr(se1, 'name'):
            assert isinstance(se1, bs4.element.Tag)
            assert isinstance(se2, bs4.element.Tag)
            levels.append(se1.name)
            if not elementsSame(se1, se2, levels):
                return False
            levels.pop()
        else:
            assert isinstance(se1, bs4.element.NavigableString)
            assert isinstance(se2, bs4.element.NavigableString)
            if se1.strip() != se2.strip():
                print(levels)
                print(f'desc: {se1.strip():20} vs {se2.strip()}')
                return False
    return True
```
