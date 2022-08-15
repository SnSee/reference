# summary

[pip离线安装](../python.md#pip)

## 1. numpy

[官方手册翻译](https://blog.csdn.net/xiaoxiangzi222/article/details/53084336/)

[菜鸟教程](https://www.runoob.com/numpy/numpy-tutorial.html)

<https://baijiahao.baidu.com/s?id=1725904977525083283&wfr=spider&for=pc>

## 2. pandas

[官方手册](https://pandas.pydata.org/docs/user_guide/index.html#user-guide)

[官方手册: 绘图](https://pandas.pydata.org/docs/user_guide/visualization.html)

[菜鸟教程](https://www.runoob.com/pandas/pandas-tutorial.html)

## 3. Excel

[相关库总结](https://blog.csdn.net/weixin_38037405/article/details/123705853)

### 3.1. xlsxwriter

[官方文档](https://xlsxwriter.readthedocs.io/)

#### 3.1.1. tips

[合并单元格](https://www.freesion.com/article/1593175682/)

### 3.2. openpyxl

[官方文档](https://openpyxl.readthedocs.io/en/stable/)

[用法](https://blog.csdn.net/m0_47170642/article/details/119137885)

#### tips

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

### 3.3. xlwings

[官方文档](https://docs.xlwings.org/en/stable/index.html)

[用法](https://blog.csdn.net/qfxietian/article/details/123822358)

## 4. jinja

[英文文档](https://jinja.palletsprojects.com/en/2.10.x/)

[机翻中文文档](http://doc.yonyoucloud.com/doc/jinja2-docs-cn/index.html)

## 绘图

### matplotlib

[官网](https://matplotlib.org)

[图元素一览](https://matplotlib.org/stable/tutorials/introductory/quick_start.html#sphx-glr-tutorials-introductory-quick-start-py)

[github](https://github.com/matplotlib/matplotlib)

[菜鸟教程](https://www.runoob.com/matplotlib/matplotlib-tutorial.html)

[用法](https://blog.csdn.net/linxi4165/article/details/126086680)

[颜色对照图](https://blog.csdn.net/qq_44901949/article/details/124738392)

```python
import matplotlib.pyplot as plt

# 清空画布
plt.close()
# 自定义画布大小及清晰度
plt.figure(figsize=(10,10), dpi=72)

# 绘制折线图
plt.plot(list, list, color='r', linestyle='-', marker='o', label='test')
# plot可选参数
# color, linestyle(线样式), marker(点样式), label(标签, 调用legend才会显示)

# 设置图片标题
plt.title("test")

# 显示图例
plt.legend()

# 设置x/y轴刻度
plt.xticks(list)
plt.yticks(list)
# 设置x/y轴名称
plt.xlabel("x")
plt.ylabel("y")

# 显示网格
plt.grid()

# 展示图片
plt.show()
# 保存图片
plt.savefig(path)

# 两条y轴
_, ax = plt.subplots()
x = list(range(10))
y = list(reversed(x))
line1 = ax.plot(x, y, marker='o', color='b', label="test1")[0]
ax.set_ylabel("y1", color='b')
ax2 = ax.twinx()
line2 = ax2.plot(x, x, marker='o', color='r', label="test2")[0]
ax2.set_ylabel("y2", color='r')
plt.legend(handles=[line1, line2])
plt.show()
```
