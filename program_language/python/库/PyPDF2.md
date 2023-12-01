
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
