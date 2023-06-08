
# tabulate

[github](https://github.com/astanin/python-tabulate)

用法示例

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
t = tabulate(df, headers='keys', tablefmt='grid', showindex=False,
             maxcolwidths=[None, None, 5], stralign='right',
             floatfmt=['', '', '', '.2f', '.3f']
             )
# tablefmt='plain' 不显示表格线
print(t)
```
