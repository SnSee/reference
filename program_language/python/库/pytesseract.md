
# pytesseract

[pypi示例](https://pypi.org/project/pytesseract)

```python
# 首先，确保您已经安装了Tesseract OCR引擎和pytesseract模块。
# sudo apt install tesseract-ocr
# pip install pytesseract

# 手动安装需要将tessert所在路径添加到PATH，或者设置tessert
# pytesseract.pytesseract.tesseract_cmd = '/tmp/tesseract'

import pytesseract
from PIL import Image
import pyperclip

# 打开图像文件
image = Image.open('example.png')

# 使用pytesseract将图像转化为文本字符串
text = pytesseract.image_to_string(image)

# 输出识别出的文本
print(text)
# 复制到粘贴板
pyperclip.copy(text)
```

识别粘贴板中的bmp图片(搭配snipaste使用)

```python
from PIL import ImageGrab
import pytesseract

# 获取粘贴板中的bmp图像
image = ImageGrab.grabclipboard()

# 将图像转换为灰度图像
gray_image = image.convert('L')

# 对图像进行OCR识别
text = pytesseract.image_to_string(gray_image, lang='eng')

# 输出识别结果
print(text)
```

识别简体中文

```python
# tesseract默认只支持英文，识别中文需要下载语言包
# 下载链接：https://github.com/tesseract-ocr/tessdata/blob/main/chi_sim.traineddata
# 将下载的语言包放置在Tesseract OCR引擎的tessdata文件夹中，例如：/usr/share/tesseract-ocr/4.0/tessdata/chi_sim.traineddata

text = pytesseract.image_to_string(gray_image, lang='chi_sim')
```

image_to_string方法

```text
pytesseract库中的image_to_string()方法可以接收多种对象类型的图片，主要包括以下几种：

1.PIL(Pillow)图像对象。
2.numpy的ndarray数组，表示一张图片或图片序列。
3.opencv(cv2)读取的图片对象（即numpy的ndarray数组）。
4.文件路径(string类型)。
5.字节流(bytes)。

需要注意的是，对于第1和第2种对象类型，pytesseract会解释为灰度图像，而对于其他类型，需要自行确保输入为灰度图像。
此外，还可以将可选参数传递给image_to_string()函数，以控制OCR的行为，如语言、字符白名单、PSM模式等。
```
