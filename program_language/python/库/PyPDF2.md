
# PyPDF2

读取 pdf

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

从 pdf 中查找

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
