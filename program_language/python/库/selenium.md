# selenium

[教程](https://blog.csdn.net/foxizhuixinggirl/article/details/122186242)

## 安装环境

安装selenium

```bash
pip install selenium
```

安装webdriver

[chrome-webdriver下载地址](http://chromedriver.storage.googleapis.com/index.html)

```text
1.打开chrome浏览器->右上角三点->帮助->关于chrome->查看chrome版本
2.打开网站，查找chrome版本对应的driver版本(大版本一致就行)，下载压缩包
3.解压后将可执行程序放到python安装目录的Scripts下
```

## 用法

导入

```python
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
```

查找元素

```python
driver = webdriver.Chrome()
driver.get("https://www.baidu.com/")

# 根据name定位
search = driver.find_element(By.NAME, "wd")
```
