
# Qt

[安装](../../../%E7%8E%AF%E5%A2%83/linux.md#Qt)

[下载模块](https://download.qt.io/archive/qt/5.15/5.15.0/submodules/)

以PyQt5或c++为例

PyQt5模块路径

```text
PyQt5.QtCore.Qt
PyQt5.QtGui
PyQt5.QWidgets.QWidget
```

注意

```text
1.anaconda下的Qt可能会影响系统安装的Qt的使用，如camke find_package时找到anaconda下的Qt
```

## pro 文件

```qt
QMAKE_CC = /usr/bin/gcc         # 设置 gcc 路径
QMAKE_CXX = /usr/bin/g++        # 设置 g++ 路径
```

## 控件

### QWidget

设备背景色

```cpp
方式一：
setAutoFillBackground(True)
setBackgroundRole(QPalette.Base)

方式二：
p = palette()
p.setColor(self.backgroundRole(), QtGui.QColor(200, 200, 200))
setPalette(p)
```

设置鼠标穿透

```cpp
setAttribute(Qt.WA_TransparentForMouseEvents, True)
但是使用该方法后QWidget自身不再处理鼠标事件
```

### QPushButton

点击回调

```cpp
button.clicked.connect(func)
```

按键背景和窗口背景一致

```cpp
setFlat(True)
```

### QTextEdit

设置提示信息

```cpp
setPlaceholderText(text)
```

QTextEdit, QLineEdit, QTextBrowser关闭右键菜单

```cpp
setContextMenuPolicy(Qt::ContextMenuPolicy::NoContextMenu)
```

设置字符颜色, [Qt颜色对照表](https://blog.csdn.net/caridle/article/details/105693773)

```cpp
self.setAcceptRichText(true)
// 富文本
self.append("<font style='font-size:14px' color=red>message to show</font>")
```

### QTableWidget

设置行数

```cpp
setRowCount(int)
```

设置列数

```cpp
setColumnCount(int)
```

指定位置新增行

```cpp
insertRow(row)
```

设置表头

```cpp
setHorizontalHeader(QHeaderView)
```

设置表头内容

```cpp
setHorizontalHeaderLabels(QStringList)
```

隐藏表头

```cpp
horizontalHeader().hide()
```

设置列宽

```cpp
setColumnWidth(index, width)
```

设置最后一列宽度自适应

```cpp
horizontalHeader().setStretchLastSection(True)
```

插入数据

```cpp
setItem(row, column, QTableWidgetItem)
```

设置下拉列表

```cpp
setCellWidget(row, column, QCombBox)
```

设置单元格不可编辑

```cpp
it = item(row, col); it.setFlags(it.flags() & ~Qt.ItemIsEditable)
```

### QComboBox(下拉框)

添加下拉选项

```cpp
addItems(const QStringList &)
```

获取选项个数

```cpp
count()
```

当前显示序号

```cpp
currentIndex()
```

当前显示内容

```cpp
currentText()
```

设置当前内容

```cpp
setCurrentText(const QString &)
```

插入选项

```cpp
insertItem(int index, const QString &, const QVariant &data=QVariant())
insertItem(int index, const QStringList &)
```

插入分割线

```cpp
insertSeparator(int index)
```

改变序号内容

```cpp
setItemText(int index, const QString &)
```

### QTreeView

获取选中的行号

```python
self.currentIndex().row()
```

选中指定行(QTreeView)

```python
# 需要知道逐级行号
rows = [3, 2, 1]
index = self.itemModel.index(rows[0], 0)    # 最顶层节点, index需要在ItemModel中通过createIndex创建
for row in rows[1:]:    # 从父节点逐级查找子节点
    index = index.child(row, 0)
selectModel = QItemSelectionModel(self._mResultModel)
selectModel.select(index, QItemSelectionModel.Select)
self.setSelectionModel(selectModel)
```

在选中item时做自定义操作(QTreeView)

```python
def selectionChanged(self, itemSelection: QItemSelection, oldSelection: QItemSelection):
    """重写选中行为"""
    rows = []
    index = self.currentIndex()
    while index.isValid():  # 逐级添加节点行号
        row = self.currentIndex().row()
        rows.append(row)
        index = index.parent()
    if rows:
        rows.reverse()
        self.sigItemSelected.emit(rows)
    super().selectionChanged(itemSelection, oldSelection)
```

获取当前屏幕中可见的第一个节点

```python
QTreeView.indexAt(QPoint(1, 1))     # return: QModelIndex
```

### QLineEdit

设置不可编辑且背景为disable颜色(直接用QLineEdit.setEnabled(False)时字体不清楚)

```python
def _setLineEditReadOnly(edit: QLineEdit):
    assert isinstance(edit, QLineEdit)
    edit.setReadOnly(True)
    palette = edit.palette()
    palette.setBrush(QPalette.Base, palette.brush(QPalette.Disabled, QPalette.Base))
    edit.setPalette(palette)
```

## 数据模型

### QModelIndex

[QModelIndex + QTreeView示例](../../python/pyqt5/QTreeView-QAbstractItemModel.py)

```text
QModelIndex通过isValid()函数来判断有效性，
通过默认构造函数创建的对象是无效的，
通过QAbstractItemModel::createIndex(row, col, ptr)创建的是有效的，
无效index在View中没有对应的节点
```

```text
通过internalPointer()获取QAbstractItemModel::createIndex(row, col, ptr)创建该index时传入的指针ptr，
一般该指针指向一个对象，通过强转还原后便可访问
```

### QAbstractItemModel

model只提供获取数据的接口，需要另外维护一个数据结构在接口中返回数据(对于QTreeView来说可以是树，对于QTableView来说可以是二维数组等)

需要重写的纯虚函数

```cpp
// 返回父节点下有多少行
int rowCount(const QModelIndex &parent = QModelIndex()) const;

// 返回列数，一般是固定值
int columnCount(const QModelIndex &parent = QModelIndex()) const;

// 根据行列号及父节点创建index
QModelIndex index(int row, int column, const QModelIndex &parent = QModelIndex()) const;

// 返回index的父节点index
QModelIndex parent(const QModelIndex &index) const;

// 返回数据(供View显示)，index是位置，role是类型(如文字，颜色，背景色等)
QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
```

刷新模型

```cpp
// 开始重置
beginResetModel();
// 调用刷新model对应数据结构的函数
updateData();
// 完成重置
endResetModel();
```

## 事件

注意事项

```text
closeEvent: 只有最顶层窗口关闭时才会触发
```

重写事件

```text
直接重写相关事件的函数/方法即可
```

事件过滤器

```text
在需要事件过滤器的类中通过installEventFilter(对象)安装，对象需要有eventFilter(QObject, QEvent)函数
```

## 其他

使用自带图标

```cpp
QIcon: QApplication.style().standardIcon(QStyle.SP_TrashIcon)
```

自定义信号槽

```cpp
from PyQt5.QtCore import pyqtSignal
sig = pyqtSignal()
sig.connect(func)
sig.emit([args...])
```

设置默认字体

```text
QApplication::setFont()
```
