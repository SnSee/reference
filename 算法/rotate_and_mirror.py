import math
import matplotlib.pyplot as plt


def transform_points(points, relPoint=(0, 0), mirror=None, rotation=0):
    # 先镜像再旋转
    # points: list[tuple[float, float]]
    # relPoint: tuple[float, float], 相对哪个坐标点进行旋转或镜像, 默认坐标原点
    # mirror: str, 镜像操作, 可选 X 或 Y
    # rotation: float, 正数逆时针负数顺时针(角度制)
    xs = [p[0] for p in points]
    ys = [p[1] for p in points]
    xc, yc = relPoint
    if mirror == 'X':
        ys = [2 * yc - y for y in ys]
    elif mirror == 'Y':
        xs = [2 * xc - x for x in xs]

    if rotation:
        angle = math.pi * rotation / 180
        nxs = [((x - xc) * math.cos(angle) - (y - yc) * math.sin(angle) + xc) for x, y in zip(xs, ys)]
        nys = [((x - xc) * math.sin(angle) + (y - yc) * math.cos(angle) + yc) for x, y in zip(xs, ys)]
        xs = nxs
        ys = nys
    return xs, ys


def draw_polygon(points, relPoint=(0, 0), mirror=None, rotation=None, color='r'):
    # 设置 x 和 y 轴刻度一致
    xs, ys = transform_points(points, relPoint, mirror, rotation)
    plt.gca().set_aspect('equal', adjustable='box')
    plt.plot(xs, ys, color=color)


triangle = [(0, 0), (2, 0), (2, 1), (0, 0)]
draw_polygon(triangle, color='r')
draw_polygon(triangle, mirror='X', color='g')
draw_polygon(triangle, mirror='Y', color='b')
draw_polygon(triangle, rotation=180, color='y')
draw_polygon(triangle, mirror='X', rotation=90, color='m')
draw_polygon(triangle, relPoint=(2, 2), mirror='X', color='lightgray')
draw_polygon(triangle, relPoint=(2, 2), rotation=-90, color='grey')
draw_polygon(triangle, relPoint=(2, 2), mirror='X', rotation=-90, color='black')
plt.show()
