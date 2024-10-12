
# xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<employees>
  <employee id="101">
    <name>John Doe</name>
    <age>30</age>
    <department>IT</department>
  </employee>
  <employee id="102">
    <name>Jane Smith</name>
    <age>35</age>
    <department>HR</department>
  </employee>
</employees>
```

```python
import xml.etree.ElementTree as ET


def traverse(ele: ET.Element, level=0) -> None:
    print(' ' * level * 4, ele.tag, ele.attrib, ele.text)
    for child in ele:
        traverse(child, level + 1)


def find(ele: ET.Element) -> None:
    # 遍历XML并打印信息
    for employee in ele.findall('employee'):
        # 查找指定tag
        name = employee.find('name').text
        age = employee.find('age').text
        department = employee.find('department').text
        print(name, age, department)


# 解析XML文件
tree = ET.parse('test.xml')
root = tree.getroot()
root.find('employee/name')     # 非递归查找，需要手动指定层级
traverse(root)
```

## 格式化

```py
import xml.etree.ElementTree as ET
import xml.dom.minidom

tree = ET.parse('test.xml')
root = tree.getroot()
xml_bytes = ET.tostring(root, encoding='utf-8')
# 使用 minidom 格式化字符串
parsed_xml = xml.dom.minidom.parseString(xml_bytes)
print(parsed_xml.toprettyxml(indent="  "))
```
