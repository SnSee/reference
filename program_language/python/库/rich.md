
# rich

[github](https://github.com/Textualize/rich)

[官方文档](https://rich.readthedocs.io/en/latest/index.html)

[颜色](https://rich.readthedocs.io/en/latest/appendix/colors.html)

## 简单输出

输出到命令行

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

输出到文本文件

```python
# 将表格渲染为字符串并写入文本文件
with open('table.txt', 'w') as fp:
    console = Console(file=fp)
    console.print(table)    # table参考下面的写法
```

## table

[可选单元格线格式](https://rich.readthedocs.io/en/latest/appendix/box.html)

```python
from rich.console import Console
from rich.table import Table
from rich import box

table = Table(show_header=True, show_lines=True, header_style='bold green', box=box.ASCII)
table.add_column('col1', justify='left', vertical='top', width=10)
table.add_column('col2', justify='center', vertical='middle')
table.add_row('row1_col1', 'row1_col2', style='green')
table.add_row('row2_col1', 'row2_col2', style='yellow')
Console().print(table)
```

注意

```text
1. 长字符串会自动显示为多行(多个单词间有空格), 长单词如果超出单元格宽度最后会显示为 ...
2. add_column 时指定的 width 不包括表格线和前后空格
3. 当列名中出现 单词 宽度大于列宽时会出现乱码
4. 当表格宽度过长时后面的部分无法显示，设置了Table的 width 也不行，最长为79个字符或当前terminal宽度？
```
