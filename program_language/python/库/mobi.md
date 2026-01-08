
# mobi

mobi 文件转换为普通文本

```py
import sys
import mobi
import html2text

def mobi2txt(mobi_path: str):
    temp_dir, html_path = mobi.extract(mobi_path)
    with open(html_path) as f:
        print(html2text.HTML2Text().handle(f.read()))

mobi2txt(sys.argv[1])
```
