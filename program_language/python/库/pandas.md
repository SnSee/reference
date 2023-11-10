
# pandas

[官方手册](https://pandas.pydata.org/docs/user_guide/index.html#user-guide)

[官方手册: 绘图](https://pandas.pydata.org/docs/user_guide/visualization.html)

[菜鸟教程](https://www.runoob.com/pandas/pandas-tutorial.html)

```python
# 查看版本
print(pandas.__version__)
```

## DataFrame

创建

```python
import pandas as pd

# 从列表创建
data = [['Tom', 18], ['Jerry', 20], ['Dog', 22]]
df = pd.DataFrame(data, columns=['Name', 'Age'])
print(df)

# 从字典创建
data = {'Name': ['Tom', 'Jerry', 'Dog'], 'Age': [18, 20, 22]}
df = pd.DataFrame(data)
print(df)

# 从字典创建方式二
data = [{'Name': 'Tom', 'Age': 18}, {'Name': 'Jerry', 'Age': 20}, {'Name': 'Dog', 'Age': 22}]
df = pd.DataFrame(data)
print(df)
```

第一行/列作为列名

```python
import pandas as pd
import numpy as np

# 第一行做列名
data = [['c1', 'c2', 'c3'], [1, 2, 3], [4, 5, 6]]
print(pd.DataFrame(data[1:], columns=data[0]).to_string(index=False))

# 第一列做列名
data = np.array([['c1', 1, 2, 3], ['c2', 4, 5, 6], ['c3', 7, 8, 9]])
columns = data[:, 0]
data = data[:, 1:]
assert len(columns) == len(data[0])
print(pd.DataFrame(data, columns=columns).to_string(index=False))
```

插入新行

```python
df = pd.DataFrame([], columns=['c1', 'c2', 'c3'])
# 方式一
df.loc[len(df)] = [1, 2, 3]
df.loc[len(df)] = [4, 5, 6]
df.loc['row_name'] = [4, 5, 6]      # 同时设置行名
# 方式二
newLine = {key: val for key, val in zip(cs, [7, 8, 9])}
df = pd.concat([df, pd.DataFrame([newLine])], ignore_index=True)
print(df.to_string(index=False))
```

插入新列

```python
# 从已有列创建
df['Weight'] = df['Height'] / 2

# Series 整行/列四则运算
df['H/W'] = df['Height'] / df['Weight']

# 直接添加
df['Boss'] = ['Big-Tom', 'Big-Jerry', 'Big-Tom']
```

基础属性/方法

```python
rowCnt: int = df.shape[0]           # 行数
colCnt: int = df.shape[1]           # 列数
df.columns.values                   # 表头名称

df['Age'].mean()                    # 平均值
df.groupby('Boss').groups           # 分组

# 排序
df = df.sort_values(by=['Height', 'Age'], ascending=False)
```

随机访问

```python
row: Series = df.loc[0]             # 获取第一行数据
values: np.ndarray = row.values     # 获取实际值
col: Series = df['Name']            # 根据列名获取列数据
col: Series = df[['Name', 'Age']]   # 根据列名获取多列数据

df.loc[0][0]                        # 获取第一行第一列元素
df.iloc[0, 0]                       # 获取第一行第一列元素
df.values[0][0]                     # 获取第一行第一列元素
```

过滤行

```python
df[df['Age'] > 18]                  # 只保留Age大于18的行
df.loc[df['Age'] > 18]              # 只保留Age大于18的行
df[df['Age'].notna()]               # 过滤空白单元格

df.loc[df['Age'] > 18, 'Name']      # 过滤同时获取列
```

切片

```python
df.iloc[0, 0]                       # 获取单个元素
df.iloc[0:2, 1:2]                   # 分别对行列切片获取子表
```

指定行名称

```python
# 创建时指定行名，index长度要和表格行数一致
df = pd.DataFrame(data, index=['First', 'Second', 'Third'])

# 插入行时指定行名称
df.loc['row_name'] = [1, 2, 3]

# 指定已有列为行名
df.set_index('Name', inplace=True)

# 指定行名称(默认为从0开始的索引)
rowCount = df.shape[0]    # 不包括表头
df = df.rename(index={i: f'row_{i + 1}' for i in range(rowCount)})

print(df)
```

遍历

```python
# 使用 items 或 iteritems 遍历
for colNames, colValues in df.iteritems():
    for cell in colValues.iteritems():
        rowIndex = cell[0]
        value = cell[1]
        print(value)

# 使用迭代器遍历
for rowIndex, row in df.iterrows():
    for colIndex in range(df.shape[1]):
        print(row.values[colIndex])

# 使用索引遍历
for rowIndex in range(df.shape[0]):
    for colIndex in range(df.shape[1]):
        print(df.values[rowIndex][colIndex])
        print(df.iloc[rowIndex, colIndex])
        print(df.loc[rowIndex][colIndex])

# 按列遍历方式一，将表格转置后按行遍历
transposed_df = df.transpose()

# 按列遍历方式二，调换行列遍历顺序
for colIndex in range(df.shape[1]):
    for rowIndex in range(df.shape[0]):
        print(df.values[rowIndex][colIndex])
```

排序

```python
data = {'Name': ['Tom', 'Jerry', 'Dog'], 'Age': [18, 20, 22]}
df = pd.DataFrame(data, index=[1, 2, 3])

# ascending: 按升序排序，默认 True
#            如果有多个行/列名可指定多个(list[bool])
# inplace  : 是否修改当前DataFrame，默认 False

# 按行名排序
df.sort_index(ascending=True, inplace=True)

# 按列名排序
df.sort_values(by='Age', ascending=False, inplace=True)
# 多级排序
df.sort_values(by=['Age', 'Name'], ascending=[False, True], inplace=True)
```

多级表头

```python
import pandas as pd

d = {
    ('row1', 'sub1'): [11, 11, 11],
    ('row1', 'sub2'): [12, 12, 12],
    ('row2', 'sub1'): [21, 21, 21],
    ('row2', 'sub2'): [22, 22, 22],
}
df = pd.DataFrame(d)
# [('row1', 'sub1') ('row1', 'sub2') ('row2', 'sub1') ('row2', 'sub2')]
print(df.columns.values)

for colNames, colCells in df.items():
    print(colNames)             # tuple: (rowi, subj)
    print(colCells.values)      # list : [ij, ij, ij]
    for cell in colCells.items():
        rowName = cell[0]
        value = cell[1]
        print(value)
```

打印 DataFrame 时的一些设置

```python
# 不显示行名和列名
df.to_string(index=False, header=False)

# 设置最大行宽
df.to_string(max_colwidth=10)

# 格式化字符串
df = pd.DataFrame({'A': [1.234567, 2.345678], 'B': [3.456789, 4.567890]})
formatters = {'A': '{:.2f}'.format, 'B': '{:.3f}'.format}
print(df.to_string(formatters=formatters))

# 设置浮点数输出位数
df.to_string(float_format='%.2f')


df.to_string()
df.to_string()
```

注意

> 1. 表头不占用索引

## Excel(xlsx)

读取xlsx表格(依赖 openpyxl)

```python
import pandas as pd

# 读取xlsx文件，并将其转换为DataFrame对象
df: pd.DataFrame = pd.read_excel('test.xlsx', sheet_name=0)
print(df)
```

read_excel 可选参数 [官方文档](https://pandas.pydata.org/docs/reference/api/pandas.read_excel.html#pandas.read_excel)

```text
sheet_name  : 一般指定数字(第几张sheet)或字符串(sheet名称)，默认第一张表
header      : 指定表头(列名)所在行索引，默认为 0
              int           : 表头只有一行
              Sequence[int] : 表头有多行，如 header=[0,1]表示前两行都是表头
                              表头单元格被合并时可以自动处理(参考多级表头)
              None          : 没有表头(所有单元格都认为是数据)
index_col   : 指定行名所在列索引，默认为 None
              int           : 行名只有一列
              Sequence[int] : 行名有多列
              None          : 没有行名，采用行索引作为行名
```

注意

> 1. 单元格内容如果能转换为数字( **int / float** )会自动转换
> 2. 空白单元格和被合并单元格为 float('nan')，显示为 NaN

to_excel

```python
df.to_excel('test.xlsx')
```
