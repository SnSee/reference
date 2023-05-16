
# rich

[github](https://github.com/Textualize/rich)

[官方文档](https://rich.readthedocs.io/en/latest/index.html)

[颜色](https://rich.readthedocs.io/en/latest/appendix/colors.html)

## 简单输出

```python
from rich.console import Console

console = Console()
# 输出两侧有横线的标题
console.rule('test name', characters='=', style='bold green')
# 输出普通行
console.print('line1', style='green')
# 输出空行
console.print()
console.print('line2', style='green')
```

## table

[可选单元格线格式](https://rich.readthedocs.io/en/latest/appendix/box.html)

```python
from rich.console import Console
from rich.table import Table
from rich import box

table = Table(show_header=True, show_lines=True, header_style='bold green', box=box.ASCII)
table.add_column('col1', justify='left', vertical='top')
table.add_column('col2', justify='center', vertical='middle')
table.add_row('row1_col1', 'row1_col2', style='green')
table.add_row('row2_col1', 'row2_col2', style='yellow')
Console().print(table)
```
