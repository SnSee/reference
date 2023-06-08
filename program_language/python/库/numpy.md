
# numpy

[官方手册翻译](https://blog.csdn.net/xiaoxiangzi222/article/details/53084336/)

[菜鸟教程](https://www.runoob.com/numpy/numpy-tutorial.html)

[教程](https://baijiahao.baidu.com/s?id=1725904977525083283&wfr=spider&for=pc)

基础用法

```python
import numpy as np

a: np.ndarray = np.array([1, 2, 3])     # 一维数组
print('a[0]     :', a[0])               # 1
print('a[-1]    :', a[-1])              # 3

b: np.ndarray = np.array([[1, 2, 3],    # 二维数组
                          [4, 5, 6],
                          [7, 8, 9]])
print('b[:, 0]  :', b[:, 0])            # [1 4 7]
print('b[1][1]  :', b[1][1])            # 5

e = np.mean(b)                          # 平均值
print('b平均值   :', e)                 # 5.0

c = a + b
print('矩阵相加:')
print(c)

# 乘矩阵列数要和被乘矩阵行数一样, 结果矩阵和乘矩阵行列一致
d = np.dot(a, b)
print('矩阵相乘:')
print(d)

# 行列坐标互换(b[i][j] 元素移动到 b[j][i])
f = np.transpose(b)
print('转置矩阵:')
print(f)
```

三维矩阵(切片与矩阵访问)

```python
import numpy as np

c: np.ndarray = np.array([          # 三维矩阵
                            [
                                [111, 112, 113],
                                [121, 122, 123],
                                [131, 132, 133],
                            ],
                            [
                                [211, 212, 213],
                                [221, 222, 223],
                                [231, 232, 233],
                            ],
                            [
                                [311, 312, 313],
                                [321, 322, 323],
                                [331, 332, 333],
                            ]
                        ])

# ndarray可以对每一维单独切片或指定索引，维数间用逗号隔开

# 第一维和第二维全部，第三维除首尾 (结果仍然是三维矩阵)
print(c[:, :, 1:-1])

# 第一位和第二维全部，第三维索引为 2 (结果是二维矩阵)
print(c[:, :, 2])

# 按维度访问数据
print(c[1][1])          # [221 222 223]
print(c[1][1][1])       # 222
```

指定元素类型

```python
# 2.1 会被转换为 int 类型，相当于 int(2.1)
a: np.ndarray = np.array([1, 2.1, 3], dtype=int)

# 如果非法使用 int() 转换则抛出异常 ValueError
a: np.ndarray = np.array([1, 'a', 3], dtype=int)
```

修改数组维数

```python
import numpy as np

data_list = [i for i in range(20)]

# 将 data_list 转换为 4 行 5 列的二维数组
a: np.ndarray = np.array(data_list).reshape((4, 5))
print(a)

a = a.reshape((2, 5, 2))
print(a)

# 如果元素总数对不上会抛出异常 ValueError
a = a.reshape((3, 5, 2))
```

零数组

```python
import numpy as np

# 创建一个4行3列的全为0的数组
data = np.zeros((4, 3))

# 打印数组对象
print(data)
```

合并数组

```python
import numpy as np

data = np.array([[1, 2, 3],
                 [4, 5, 6],
                 [7, 8, 9],
                 [10, 11, 12]])

# 添加表头信息
header = ['A', 'B', 'C']

# 将表头信息与数据数组合并
table = np.vstack((header, data))

print(table)
```

运算符

```python
```

数学函数

```python
import numpy as np
from decimal import Decimal
from functools import partial

a = np.arange(10)

print('sum  :', np.sum(a))                          # 求和
print('std  :', np.std(a))                          # 标准差
print('mean :', np.mean(a))                         # 平均值
print('abs  :', np.abs([-1, -2]))                   # 绝对值
print('max  :', np.max(a))                          # 最大值
print('maximum:', np.maximum(a, np.flip(a)))        # 取两个数组中相同位置元素大的那一个
print('around:', np.around(a + 0.015, decimals=2))  # 四舍五入，由于浮点数不精准性，小数位为 5 可能无法进1
print('around:', np.vectorize(partial(round, ndigits=2))(a + Decimal('0.015')))
# print('around:', np.around(a + Decimal('0.015'), decimals=2))   # 不能对 Decimal 使用 np.around

print('square:', np.square(a))                      # 平方
print('sqrt :', np.sqrt(a))                         # 对所有数据开方
# print(np.sqrt(np.array([-1, -2])))                # 负数开方为 float('nan') 并报错
print('sin   :', np.sin(a))                         # 三角函数
print('log  :', np.log(a[1:]))                      # 取对数, e 为底
print('log10:', np.log10(a[1:]))                    # 取对数
print('log2 :', np.log2(a[1:]))                     # 取对数
print('log1p:', np.log1p(a))                        # 取对数, 相当于 log(1 + a)
```

其他函数

```python
import numpy as np

a = np.arange(10)

print('sort:', np.sort(a))                          # 排序
print('flip:', np.flip(a))                          # 翻转

print('split:', np.split(a, 2))                     # 平均拆分成两部分, 无法平均分配会抛异常
print(np.split(a, [2, 3]))                          # 按索引拆分成多个部分
print(np.split(a, [2, -1]))                         # 按索引拆分成多个部分
```
