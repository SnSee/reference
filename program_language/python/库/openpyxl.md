
# openpyxl

[官方文档](https://openpyxl.readthedocs.io/en/stable/)

## 注意事项

```text
1. 行的编号从 1 开始计数，如 ws.iter_rows的min_row参数最小值为 1
```

## 基础用法

查看版本

```python
import openpyxl
print(openpyxl.__version__)
```

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

sheet页

```python
ws = wb.create_sheet('sheet_name')      # 创建sheet页
ws.title = 'new_name'                   # 重命名sheet页
```

合并单元格

```python
# 合并 A1 到 C3 的单元格
ws.merge_cells('A1:C3')
ws.merge_cells(start_row=1, start_column=1, end_row=3, end_column=3)
```

从指定行列位置插入数据

```python
data = ['Data 1', 'Data 2', 'Data 3']

# 将数据插入到第二列开始的单元格
for index, value in enumerate(data, start=2):
    ws.cell(row=1, column=index, value=value)
```

获取cell坐标

```python
cell.row
cell.column
cell.column_letter
```

设置数字格式

```python
from openpyxl.styles import numbers
# 设置为百分比格式
cell.number_format = numbers.FORMAT_PERCENTAGE_00

# 保留两位小数
cell.number_format = numbers.FORMAT_NUMBER_00

# 保留10位小数(小数位后面会自动补0到10位)
cell.number_format = '0.' + '0' * 10
```

设置边框

```python
from openpyxl.styles import Border, Side
style = Side(style="thin", color="000000")
cell.border = Border(top=style, right=style, bottom=style, left=style)
```

[设置条件格式(Conditional Formatting)](https://openpyxl.readthedocs.io/en/stable/formatting.html)

```python
# 根据数值所在区间设置背景颜色
# 如果打开已有条件格式的表格则无法应用新的条件格式
import openpyxl
from openpyxl.styles import PatternFill
from openpyxl.formatting.rule import CellIsRule

redFill = PatternFill(start_color='ffc7ce', end_color='ffc7ce', fill_type='solid')
greFill = PatternFill(start_color='c6efce', end_color='c6efce', fill_type='solid')

rule1 = CellIsRule(operator='<', formula=['30'], stopIfTrue=True, fill=redFill)
rule2 = CellIsRule(operator='between', formula=['30', '50'], stopIfTrue=True, fill=greFill)
rule3 = CellIsRule(operator='>', formula=['50'], stopIfTrue=True, fill=redFill)

wb = openpyxl.Workbook()
ws = wb.active
data = [[10, 20], [30, 40], [50, 60]]
for row in data:
    ws.append(row)

ws.conditional_formatting.add('A1:B3', rule1)
ws.conditional_formatting.add('A1:B3', rule2)
ws.conditional_formatting.add('A1:B3', rule3)

wb.save('test.xlsx')
```

根据坐标获取表格范围

```python
def getCellRange(startRow: int, startCol: int, endRow: int, endCol: int) -> str:
    # 应用单元格包括 endRow 和 endCol
    # return: like A1:B3
    startColStr = get_column_letter(startCol)
    endColStr = get_column_letter(endCol)
    return f'{startColStr}{startRow}:{endColStr}{endRow}'
```

## tips

[字体,列宽,对齐,边框,填充](https://blog.csdn.net/qq_39147299/article/details/123378749)

将单元格的值设为表达式

```python
ws['C2'] = '=A2+B2'
```

获取cell/访问cell

```python
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
def cell_merged(cell, worksheet):
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

自动适配单元格宽度及高度
如果字体在tkinter字体库中，可以使用 [tkinter](../%E5%B8%B8%E7%94%A8%E6%A8%A1%E5%9D%97.md#tkinter) 中的方法获取字符串宽度
如果有 **ttf** 字体文件，可以使用 [pillow](./PIL.md#get_text_width) 库获取字符串宽度

```python
from openpyxl.utils import get_column_letter
def adjust_width(ws: Worksheet):
    # 平均字符宽度系数（获取实际字符宽度需要加载字体库，不好确定字体库位置）
    CELL_WITH_MULTIPLE = 1.2    
    CELL_HEIGHT_MULTIPLE = 16
    MIN_CELL_WIDTH = 5          # 最小宽度
    MAX_CELL_WIDTH = 50         # 最大宽度
    widths = {}
    for row in ws.rows:
        for cell in row:
            if cell.value:
                cell_len = CELL_WITH_MULTIPLE * len(str(cell.value))
                widths[cell.column] = max((widths.get(cell.column, MIN_CELL_WIDTH), cell_len))
    for col, value in widths.items():
        ws.column_dimensions[get_column_letter(col)].width = min(value, MAX_CELL_WIDTH)
    
    # 适配宽度后适配高度
    for row in ws.rows:
        lineCnt = 1
        for cell in row:
            if cell.value and not cell_merged(cell, ws):
                value = str(cell.value)
                lineCnt = max(len(str(value)) // MAX_CELL_WIDTH + 1, lineCnt, value.count('\n') + 1)
        ws.row_dimensions[row[0].row].height = CELL_HEIGHT_MULTIPLE * lineCnt
```

单元格格式

```python
# 加粗字体
ws['B3'].font = Font(bold=True)
# 设置背景色
ws['B3'].fill = Font("solid", fgColor="00ffff")

# 修改行高
ws.row_dimensions[2].height = 20
# 修改列宽
ws.column_dimensions['A'].width = 50

# 对齐
from openpyxl.styles import Alignment
ws['B2'].alignment = Alignment(
    horizontal='left',      # 可选general、left、center、right、fill、justify、centerContinuous、distributed
    vertical='top',         # 可选top、center、bottom、justify、distributed
    text_rotation=0,        # 字体旋转，0~180整数
    wrap_text=False,        # 是否自动换行
    shrink_to_fit=False,    # 是否缩小字体填充
    indent=0,               # 缩进值
)
```
