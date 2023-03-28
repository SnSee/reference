
# 软件

## tesseract

[github](https://github.com/tesseract-ocr/tesseract)

[windows安装包](https://digi.bib.uni-mannheim.de/tesseract/)

测试图片

![example](./pics/example.png)

用法示例

```bash
tesseract <example.png> <output_file>
```

使用python调用

```python
# 首先，确保您已经安装了Tesseract OCR引擎和pytesseract模块。
# sudo apt install tesseract-ocr
# pip install pytesseract

import pytesseract
from PIL import Image

# 打开图像文件
image = Image.open('example.png')

# 使用pytesseract将图像转化为文本字符串
text = pytesseract.image_to_string(image)

# 输出识别出的文本
print(text)
```
