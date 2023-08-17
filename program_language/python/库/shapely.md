
# shapely

Polygon

```python
# 创建
points = [(0, 0), (0, 10), (10, 10), (10, 0)]
p = Polygon(points)

p.length                # 周长
p.area                  # 面积
```

展示polygon图形

```python
import typing
import matplotlib.pyplot as plt
import numpy as np
from shapely.geometry import Polygon, Point
from shapely.geometry.multipolygon import MultiPolygon


def plot_polygons(polygons: list, title: str):
    fig, ax = plt.subplots()
    if polygons:
        if not isinstance(polygons[0], list):
            polygons = [polygons]
        for polygon in polygons:
            poly_array = np.array(polygon)
            ax.fill(poly_array[:, 0], poly_array[:, 1], alpha=0.5)

    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_title(title)

    plt.grid(True)
    plt.show()
```

将polygon对象转换为点列表

```python
def polygon_to_list(polygon: typing.Union[Polygon, MultiPolygon]) -> list[list[tuple[float, float]]]:
    parts = []
    if isinstance(polygon, MultiPolygon):
        for part in polygon.geoms:
            parts.append(list(part.exterior.coords))
    else:
        assert isinstance(polygon, Polygon)
        if not polygon.is_empty:    # 空对象，内部没有多边形
            parts.append(list(polygon.exterior.coords))
    return parts
```

判断点是否在polygon内或边缘

```python
def in_polygon(x: float, y: float, polygon: typing.Union[Polygon, MultiPolygon]) -> bool:
    if isinstance(polygon, Polygon):
        if polygon.is_empty:
            return False
        p = Point(x, y)
        # 在内部或边界上
        return polygon.contains(p) or polygon.touches(p)

    for part in polygon.geoms:
        if in_polygon(x, y, part):
            return True
    return False
```

剪切及分割多边形测试

```python
# 从a中减去b部分，剩下的多边形可能有多个
def cut_test():
    main_polygon = [(0, 0), (0, 10), (10, 10), (10, 0)]
    # 没有交集，不起作用
    cutter1 = [(11, -1), (11, 11), (12, 11), (12, -1)]
    # 剩余单个多边形
    cutter2 = [(3, -1), (3, 5), (7, 5), (7, -1)]
    # 分割成两个子多边形
    cutter3 = [(3, -1), (3, 11), (7, 11), (7, -1)]

    # 分割多边形
    no_cut = Polygon(main_polygon).difference(Polygon(cutter1))
    part_cut = Polygon(main_polygon).difference(Polygon(cutter2))
    two_cut = Polygon(main_polygon).difference(Polygon(cutter3))

    plot_polygons(main_polygon, "original")
    plot_polygons(polygon_to_list(no_cut), "no cut")
    plot_polygons(polygon_to_list(part_cut), "cut part")
    plot_polygons(polygon_to_list(two_cut), "cut to two parts")
```

多边形交集测试

```python
def intersect_test():
    main_polygon = [(0, 0), (0, 10), (10, 10), (10, 0)]
    # 没有交集
    inter1 = [(11, 0), (11, 10), (12, 10), (12, 0)]
    # 有交集
    inter2 = [(5, 0), (5, 5), (10, 5), (10, 0)]

    no_inter = Polygon(main_polygon).intersection(Polygon(inter1))
    has_inter = Polygon(main_polygon).intersection(Polygon(inter2))

    # 绘制分割前后的多边形
    plot_polygons(main_polygon, "original")
    plot_polygons(polygon_to_list(no_inter), "no intersection")
    plot_polygons(polygon_to_list(has_inter), "has intersection")
```

多边形并集测试

```python
def union_test():
    main_polygon = [(0, 0), (0, 10), (10, 10), (10, 0)]
    # 没有交集
    union1 = [(11, 0), (11, 10), (12, 10), (12, 0)]
    # 有交集
    union2 = [(5, -5), (5, 5), (15, 5), (15, -5)]

    two_parts = Polygon(main_polygon).union(Polygon(union1))
    one_part = Polygon(main_polygon).union(Polygon(union2))

    # 绘制分割前后的多边形
    plot_polygons(main_polygon, "original")
    plot_polygons(polygon_to_list(two_parts), "two parts")
    plot_polygons(polygon_to_list(one_part), "one part")
```

多边形异或测试（并集减去交集）

```python
def xor_test():
    main_polygon = [(0, 0), (0, 10), (10, 10), (10, 0)]
    # 没有交集
    union1 = [(11, 0), (11, 10), (12, 10), (12, 0)]
    # 有交集
    union2 = [(5, -5), (5, 5), (15, 5), (15, -5)]

    no_inter = Polygon(main_polygon).symmetric_difference(Polygon(union1))
    has_inter = Polygon(main_polygon).symmetric_difference(Polygon(union2))

    # 绘制分割前后的多边形
    plot_polygons(main_polygon, "original")
    plot_polygons(polygon_to_list(no_inter), "no intersection")
    plot_polygons(polygon_to_list(has_inter), "has intersection")
```
