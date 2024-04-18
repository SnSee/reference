
# PyPDF2

[官网](https://pypdf2.readthedocs.io)

## 读取 pdf

```python
import PyPDF2

with open('test.pdf', 'rb') as fp:
    reader = PyPDF2.PdfReader(fp)
    for num in range(len(reader.pages)):
        page = reader.pages[num]
        text: str = page.extract_text()
        print(text)
        print('----------------------')
```

## 从 pdf 中查找

```python
#!/bin/env python3
import os.path
import sys
import PyPDF2
import re


def grepPdf(pdfFile: str, word: str):
    pat = re.compile(word, re.IGNORECASE)
    fileShowed = False
    with open(pdfFile, 'rb') as file:
        reader = PyPDF2.PdfReader(file)
        for num in range(len(reader.pages)):
            page = reader.pages[num]
            text = page.extract_text()
            for line in text.split('\n'):
                if pat.search(line):
                    if not fileShowed:
                        print(f'file: {pdfFile}')
                        fileShowed = True
                    print(f'{num + 1}: {line}')


def grepDir(sd: str, word: str):
    for root, _, files in os.walk(sd):
        for file in files:
            if file.endswith('.pdf'):
                grepPdf(os.path.join(root, file), word)


if __name__ == '__main__':
    if os.path.isfile(sys.argv[2]):
        grepPdf(sys.argv[2], sys.argv[1])
    else:
        grepDir(sys.argv[2], sys.argv[1])
```

## 为 pdf 目录添加跳转链接

```python
def add_bookmarks(input_pdf_path, output_pdf_path, _table_of_contents):
    with open(input_pdf_path, 'rb') as input_file:
        pdf_reader = PyPDF2.PdfReader(input_file)
        pdf_writer = PyPDF2.PdfWriter()

        # 复制原始 PDF 的内容到新的 PDF 文件
        for page_num in range(len(pdf_reader.pages)):
            pdf_writer.add_page(pdf_reader.pages[page_num])

        # 添加书签
        for title, page_num in _table_of_contents:
            pdf_writer.add_outline_item(title, page_num - 1)

        # 保存新的 PDF 文件
        with open(output_pdf_path, 'wb') as output_file:
            pdf_writer.write(output_file)
```
