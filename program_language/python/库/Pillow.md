
# Pillow

<a id="get_text_width"></a>

获取字体宽度

```python
from PIL import ImageFont

ttf = "C:/Windows/Fonts/Arial.ttf"
font = ImageFont.truetype(ttf, size=12)
width = font.getlength('test')      # 像素
print(width)
```
