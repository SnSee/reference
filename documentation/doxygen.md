
# doxygen

```sh
sudo apt install doxygen
sudo apt install graphviz
```

## 用法

```sh
# 找一个空目录
doxygen -g $doc_name
# 修改生成的文件选项
doxygen $doc_name
```

## 选项

### 基础选项

|option |desc
|- |-
|PROJECT_NAME           |项目名称
|OUTPUT_LANGUAGE        |生成文档语言，默认英语即可
|OUTPUT_DIRECTORY       |输出目录，默认当前
|INPUT                  |源文件或目录，默认当前
|FILE_PATTERNS          |查找文件格式，一般默认即可
|RECURSIVE              |递归目录，默认否

### 类图相关

|option |desc
|- |-
|CLASS_DIAGRAMS         |生成类图，默认是
|HAVE_DOT               |使用 graphviz 生成类图，默认是
|DOT_PATH               |指定 dot 程序路径，默认空，表示在 PATH 中
|UML_LOOK               |生成 UML 格式的类图，默认否
|DOT_UML_DETAILS        |类图中包含属性类型和函数形参，默认否
|DOT_WRAP_THRESHOLD     |文本超过该长度会被折叠，默认17
|DOT_MULTI_TARGETS      |多进程调用 dot，默认否
|DOT_CLEANUP            |删除中间文件，默认是
