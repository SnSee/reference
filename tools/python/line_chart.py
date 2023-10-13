#!/bin/env python
# 功能：根据命令行输入的多个数字绘制折线图，展示走势
# 输入：多个由空格分隔的整数或浮点数，程序通过search查找每个部分第一个有效整数/浮点数
# 示例：line_chart.py 1.9 2 3.4 5.6
import matplotlib.pyplot as plt
import sys
import re

num_pat = re.compile(r'\d+(?:\.\d+)?(?:[eE][-+]?\d+)?')
data = [float(num_pat.search(x).group(0)) for x in sys.argv[1:]]
print("numbers:", data)
plt.plot(data, marker='d')
plt.show()
