
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

合并图片

```python
from PIL import Image

pics = ['test1.jpg', 'test2.png']
images = [Image.open(p) for p in pics]
width = max([i.size[0] for i in images])
heights = [i.size[1] for i in images]
newImg = Image.new('RGB', (width, sum(heights)))
for i, img in enumerate(images):
    newImg.paste(img, (width, sum(heights[:i])))
newImg.save('merged.png')
```
