
# tabulate

[github](https://github.com/astanin/python-tabulate)

依据 **list[list]** 创建

```python
from tabulate import tabulate

data = [['c1', 'c2', 'c3'], [1, 2, 3], [4, 5, 6]]
t = tabulate(data, headers='firstrow', tablefmt='grid', showindex=False, stralign='left')
print(t)
```

依据 **pandas** 创建

```python
from tabulate import tabulate
import pandas as pd

# 创建一个 DataFrame 示例
data = {
    'Name': ['John', 'Emma', 'Peter'],
    'Age': [25, 30, 35],
    'Occupation': ['Engineer', 'Teacher', 'Doctor'],
    'Salary': [1024.4311, 5555, 2233.4399],
    'Cost': [24.4311, 555, 233.4399],
}
df = pd.DataFrame(data)

# 使用 tabulate 输出 DataFrame
# 如果不设置maxcolwidths，单元格宽度取决于最长的字符串宽度
t = tabulate(df, headers='keys', tablefmt='grid', showindex=False,
             maxcolwidths=[None, None, 5], stralign='right',
             floatfmt=['', '', '', '.2f', '.3f']
             )
# tablefmt='plain' 不显示表格线
print(t)
```
