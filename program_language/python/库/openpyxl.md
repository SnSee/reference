
# openpyxl

[官方文档](https://openpyxl.readthedocs.io/en/stable/)

## 注意事项

```text
1. 行的编号从 1 开始计数，如 ws.iter_rows的min_row参数最小值为 1
```

## 基础用法

读取 xlsx 文档

```python
import openpyxl
from openpyxl.workbook.workbook import Workbook
from openpyxl.worksheet.worksheet import Worksheet
from openpyxl.cell.cell import Cell

def print_excel_data(file_path):
    # 加载表格文件
    wb: Workbook = openpyxl.load_workbook(file_path)
    # 选择第一个工作表
    ws: Worksheet = wb.active

    # 按行遍历
    # min_row可以指定起始行号，最小为 1
    # values_only 为 True 表示只返回值，否则返回 Cell 对象
    for row in ws.iter_rows(min_row=1, values_only=True):
        cols = []
        for i in range(ws.max_column):
            # 直接获取到的数据可能是int, float等类型
            # 空白单元格和被合并的单元格(除左上角那个格子)返回 None
            cols.append(str(row[i]))
        print(" | ".join(cols))
```

写入 xlsx 文档

```python
import openpyxl

data = [['This is a test', 'Hello world', 'Python openpyxl'], ['Goodbye', 'World', 'Excel']]
wb = openpyxl.Workbook()
ws = wb.active
for row in data:
    ws.append(row)
wb.save("test.xlsx")
```

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

判断cell是否被 merge

```python
def cell_merged(self, cell, worksheet):
    for merged_range in worksheet.merged_cells.ranges:
        if cell.coordinate in merged_range:
            return True
    return False

def print_excel_data(file_path):
    wb: Workbook = openpyxl.load_workbook(file_path)
    ws: Worksheet = wb.active
    for row in ws.iter_rows(min_row=1):
        for i in range(ws.max_column):
            cell: Cell = row[i]
            if cell_merged(cell, ws):
                print(f"merged: ({cell.row}, {cell.column})")
                print(cell.coordinate)      # A1, A2这种形式
```

自动适配单元格宽度
如果字体在tkinter字体库中，可以使用 [tkinter](../%E5%B8%B8%E7%94%A8%E6%A8%A1%E5%9D%97.md#tkinter) 中的方法获取字符串宽度
如果有 **ttf** 字体文件，可以使用 [pillow](./PIL.md#get_text_width) 库获取字符串宽度

```python
from openpyxl.utils import get_column_letter
def adjust_width(worksheet):
    # 平均字符宽度系数（获取实际字符宽度需要加载字体库，不好确定字体库位置）
    CELL_WITH_MULTIPLE = 1.2    
    MIN_CELL_WIDTH = 5          # 最小宽度
    MAX_CELL_WIDTH = 50         # 最大宽度
    widths = {}
    for row in worksheet.rows:
        for cell in row:
            if cell.value:
                cell_len = CELL_WITH_MULTIPLE * len(str(cell.value))
                widths[cell.column] = max((widths.get(cell.column, MIN_CELL_WIDTH), cell_len))
    for col, value in widths.items():
        worksheet.column_dimensions[get_column_letter(col)].width = min(value, MAX_CELL_WIDTH)
```

单元格格式

```python
# 加粗字体
ws['B3'].font = Font(bold=True)
# 设置背景色
ws['B3'].fill = Font("solid", fgColor="00ffff")
```
