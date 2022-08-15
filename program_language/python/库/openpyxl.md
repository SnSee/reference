
# openpyxl

[官方文档](https://openpyxl.readthedocs.io/en/stable/)

[用法](https://blog.csdn.net/m0_47170642/article/details/119137885)

## tips

[字体,列宽,对齐,边框,填充](https://blog.csdn.net/qq_39147299/article/details/123378749)

```python
# 获取cell
# 方式一
for row in worksheet.rows:
    for cell in row:
        print(cell.value)

# 方式二
for i in range(1, worksheet.max_row + 1):
    for j in range(1, worksheet.max_col + 1):
        worksheet.cell(i, j)

# 方式三
worksheet["A1"]

# 方式四
worksheet["A1:A3"]  # 获取多个cell，tuple类型
```

```python
# 判断cell是否被merge
def cell_merged(self, cell, worksheet):
    for merged_range in worksheet.merged_cells.ranges:
        if cell.coordinate in merged_range:
            return True
    return False
```

```python
# 自动适配单元格宽度
from openpyxl.utils import get_column_letter
def adjust_width(worksheet):
    for row in worksheet.rows:
        for cell in row:
            if cell.value:
                cell_len = CELL_WITH_MULTIPLE * len(str(cell.value))
                widths[cell.column] = max((widths.get(cell.column, MIN_CELL_WIDTH), cell_len))
    for col, value in widths.items():
        worksheet.column_dimensions[get_column_letter(col)].width = min(value, MAX_CELL_WIDTH)
```

```python
# 加粗字体
ws['B3'].font = Font(bold=True)
# 设置背景色
ws['B3'].fill = Font("solid", fgColor="00ffff")
```
