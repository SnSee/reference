
# gvim

## 窗口

### geometry(geom) 选项

在指定位置打开指定尺寸窗口

```sh
# width/height 为整个窗口的宽度/高度
# 单位为字符宽度/高度
gvim <width> x <height> + <x_offset> + <y_offset>

# 如在 (50, 50) 位置打开窗口，尺寸为 100 * 20
gvim -geometry 100x20+50+50
```
