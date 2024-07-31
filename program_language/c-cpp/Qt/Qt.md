
# Qt

[安装](../../../%E7%8E%AF%E5%A2%83/linux.md#Qt)

[下载模块](https://download.qt.io/archive/qt/5.15/5.15.0/submodules/)

[官网用户手册](https://doc.qt.io/qtforpython/modules.html)

[api查询](https://www.riverbankcomputing.com/static/Docs/PyQt5/sip-classes.html)

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

## QtCore

### QApplication

#### 屏幕尺寸

```py
app = QApplication(sys.argv)
screen = app.primaryScreen()
size = screen.size()
width = size.width()
height = size.height()
```

### QThread

```py
from PyQt5.QtCore import QThread

class MyThread(QThread):
    def __init__(self, parent):
        super().__init__(parent)
    
    def run():
        print("run")

def on_finished():
    print("finished")

th = MyThread()
th.finished.connect(on_finished)
th.start()
```

### QProcess

```py
from PyQt5.QtCore import QProcess

p = QProcess()
p.start('ls', ['/tmp', '/tmp2'])
p.waitForFinished()
print('stdout:', p.readAllStandardOutput())
if p.error() != QProcess.ProcessError.UnknownError:
    # 程序执行出错，如无效命令，程序崩溃等
    print('exec error:', p.errorString())
if p.exitCode() != 0:
    print('stderr:', p.readAllStandardError())
```

## 控件

### QWidget

|function | desc
|- |-
|setDisabled            | 设置不可交互
|setStyleSheet          | 设置 style
|setContentsMargins     | 设置到子控件边缘到自身边缘距离

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
// 转义 <
escaped_text = text.replace('<', '&lt;')
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

### QCheckBox(勾选框)

```py
from PyQt5.QtWidgets import QCheckBox

box = QCheckBox('name', parent)
box.setChecked(True)                # 是否勾选
box.clicked.connect(_on_clicked)    # 点击时回调

def _on_clicked():
    if box.isChecked():             # 自动取消勾选
        box.setChecked(False)
```

### QComboBox(下拉框)

```cpp
// 添加下拉选项
addItems(const QStringList &)
// 获取选项个数
count()
// 当前显示序号
currentIndex()
// 当前显示内容
currentText()
// 设置当前内容
setCurrentText(const QString &)
// 插入选项
insertItem(int index, const QString &, const QVariant &data=QVariant())
insertItem(int index, const QStringList &)
// 插入分割线
insertSeparator(int index)
// 改变序号内容
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

### QTabWidget

#### 设置tab页方向

```python
tab = QTabWidget()
tab.setTabPosition(QTabWidget.West)     # tab 页在左侧
tab.addTab(QWidget(), '')
# 设置第一个tab页文字
tab.tabBar().setTabButton(0, QTabBar.ButtonPosition.RightSide, QLabel('line1\nline2', tab))
```

#### 添加与关闭按钮

```py
import sys
from PyQt5.QtWidgets import QApplication, QMainWindow, QTabWidget, QWidget, QTabBar, QLabel
from PyQt5.QtCore import Qt

class TabWid(QTabWidget):
    def __init__(self):
        super().__init__()
        self._idx = 1
        self._last_current_idx = 0

        # 设置 tab 可关闭
        self.tab_bar = QTabBar()
        self.tab_bar.setTabsClosable(True)
        self.tab_bar.tabCloseRequested.connect(self._close_tab)
        self.setTabBar(self.tab_bar)

        # 创建添加按钮
        add_lbl = QLabel('+')
        add_lbl.setFixedSize(20, 20)
        add_lbl.setAlignment(Qt.AlignHCenter | Qt.AlignVCenter)
        add_lbl.setStyleSheet('font: normal bold 20px "Times New Roman"; border: none; align: center')

        self.addTab(QWidget(), '')
        self.tab_bar.setTabButton(0, QTabBar.RightSide, add_lbl)
        self.tab_bar.currentChanged.connect(self._on_click_tab)

        self._new_tab()
        self._new_tab()

    def _new_tab(self):
        insert_pos = self.count() - 1
        self.insertTab(insert_pos, QWidget(), f'tab {self._idx}')         # 在 + 前方插入
        self.setCurrentIndex(insert_pos)
        self._idx += 1

    def _close_tab(self, index: int):
        cur_idx = self.currentIndex()
        self.tab_bar.removeTab(index)
        if cur_idx == index:
            self.setCurrentIndex(index - 1)

    def _on_click_tab(self, index: int):
        if index == self.count() - 1:
            self._new_tab()
        else:
            self._last_current_idx = index

if __name__ == '__main__':
    app = QApplication(sys.argv)
    win = QMainWindow()
    win.setCentralWidget(TabWid())
    win.setGeometry(100, 100, 800, 600)
    win.show()
    sys.exit(app.exec_())
```

### QRadioButton单选框

[参考](https://zhuanlan.zhihu.com/p/680675691)

```py
btn_0 = QRadioButton('off')
btn_1 = QRadioButton('on')
btn_0.setChecked(True)
btn_0.toggled.connect(callback)
btn_1.toggled.connect(callback)

# group 可以让指定RadioButton为一组，防止和其他RadioButton混在一起
group = QButtonGroup()
group.addButton(btn_0)
group.addButton(btn_1)

lay = QHBoxLayout()
lay.addWidget(btn_0)
lay.addWidget(btn_1)
```

### QFrame

#### 凸起/凹陷效果

```python
frame = QFrame()
frame.setFrameStyle(QFrame.Panel | QFrame.Sunken)
```

#### 分隔线

水平分隔线/分割线

```python
from PyQt5.QtWidgets import QWidget, QFrame, QVBoxLayout, QSizePolicy

class HLine(QWidget):
    def __init__(self, parent):
        super().__init__(parent)
        frame = QFrame(self)
        frame.setFrameShape(QFrame.HLine)
        frame.setFrameShadow(QFrame.Sunken)
        frame.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
        frame_lay = QVBoxLayout()
        frame_lay.addWidget(frame)
        # 左右贴边，上下各 5
        frame_lay.setContentsMargins(0, 5, 0, 5)
        self.setLayout(frame_lay)
```

竖直分隔线

```py
v_line = QFrame()
v_line.setFrameShape(QFrame.VLine)
v_line.setFrameShadow(QFrame.Sunken)
```

### QFileDialog 文件浏览框

选择文件

```py
from PyQt5.QtWidgets import QFileDialog

options = QFileDialog.Options()
fileName, _ = QFileDialog.getOpenFileName(self, "选择文件", "", "All Files (*);;Python Files (*.py)", options=options)
if fileName:
    print("选择的文件路径:", fileName)
```

选择文件夹

```py
folderName = QFileDialog.getExistingDirectory(self, "选择文件夹", options=QFileDialog.ShowDirsOnly)
if folderName:
    print("选择的文件夹路径:", folderName)
```

自定义打开文件/文件夹

```py
import os
from PyQt5.QtWidgets import QFileDialog

class FileDialog(QFileDialog):
    def __init__(self, cwd: str = None):
        super().__init__()
        self._cwd = cwd if cwd else os.getcwd()

    def open(self, only_dir: bool = False, title='', cwd='', name_filter=''):
        if not cwd:
            cwd = self._cwd
        self.setWindowTitle(title)
        self.setDirectory(cwd)
        self.setNameFilter(name_filter)
        self.setFileMode(QFileDialog.Directory if only_dir else QFileDialog.FileMode.ExistingFile)
        self.setOptions(QFileDialog.DontResolveSymlinks)

        if self.exec_() == QFileDialog.Accepted:
            sel_file = self.selectedFiles()[0]
            self._cwd = sel_file if only_dir else os.path.dirname(sel_file)
            return sel_file
        return ''
```

### QSplitter 滑动窗口

遇到拖不动的情况使用 [QScrollArea](#qscrollarea--qsplitter)

```py
from PyQt5.QtWidgets import Splitter

sp = QSplitter(PyQt5.QtCore.Qt.Vertical)
sp.addWidget(QTextEdit())
sp.addWidget(QTextEdit())
lay = QVBoxLayout()
lay.addWidget(sp)
```

### QScrollArea 滚动窗口

#### QScrollArea + QSplitter

```py
from PyQt5.QtCore import Qt
from PyQt5.QtWidgets import QApplication, QMainWindow, QTabWidget, QWidget, QVBoxLayout, QScrollArea, QLabel, QSplitter, QPushButton

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()

        tabs = QTabWidget()
        for i in range(3):
            layout = QVBoxLayout()
            for j in range(20):
                layout.addWidget(QLabel(f"Item {i}-{j}"))
            tab_widget = QWidget()
            tab_widget.setLayout(layout)
            sa = QScrollArea()
            sa.setWidget(tab_widget)
            sa.setWidgetResizable(True)
            tabs.addTab(sa, f"Tab {i}")

        sp = QSplitter(Qt.Vertical)
        sp.addWidget(tabs)
        sp.addWidget(QPushButton('TEST'))
        self.setCentralWidget(sp)

if __name__ == "__main__":
    app = QApplication([])
    win = MainWindow()
    win.show()
    app.exec_()
```

## 布局

### QBoxLayout

```py
# 使控件不要填充到整个 widget
lay = QVBoxLayout()
lay.addWidget(QPushButton('test'))
lay.addStretch()        # 添加自动伸缩空白区域，使其他控件布局合理
lay.addSpacing(20)      # 添加高度为 20 像素的空白区域
```

## style

Qt帮助文档搜索：**Qt Style Sheets**

```py
wid = QWidget()
wid.setStyleSheet('color: red')
```

### Qt Style Sheets Reference

帮助文档搜索标题查看所有格式

|name | desc
|- |-
|color              |颜色
|background-color   |背景颜色
|font               |字体，如: 'font: bold italic 20px "Times New Roman"
|text-align         |文字对齐方式
|border             |边框，none 为无边框

### Style Rules & Selector Types

```py
# 批量设置多种控件
wid.setStyleSheet('QPushButton,QLineEdit{color: red; background-color: white} QComboBox{color: black}')

# 根据objectName 设置筛分同类型控件
wid.setObjectName('my_obj_name')
print(wid.objectName())
wid.setStyleSheet('QPushButton#my_obj_name {color: red}')

# 设置控件子属性
QComboBox::drop-down { image: url(dropdown.png) }
QComboBox {
    margin-right: 20px;
}
QComboBox::drop-down {
    subcontrol-origin: margin;
}
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

### 使用自带图标

```cpp
QIcon: QApplication.style().standardIcon(QStyle.SP_TrashIcon)
```

[图标展示](https://zhuanlan.zhihu.com/p/654246600)

查看图标和枚举值对应关系

```py
from PyQt5.QtWidgets import QApplication, QMainWindow, QStyle, QLabel, QVBoxLayout, QHBoxLayout, QWidget
from PyQt5.QtCore import QSize

class IconViewer(QMainWindow):
    def __init__(self):
        super().__init__()
        layout = QVBoxLayout()
        central_widget = QWidget()
        central_widget.setLayout(layout)
        self.setCentralWidget(central_widget)

        enums = [attr for attr in dir(QStyle) if attr.startswith('SP_')]
        style = QApplication.style()
        step = 5
        width = 32
        for i in range(0, len(enums), step):
            row_lay = QHBoxLayout()
            for j in range(step):
                if i + j >= len(enums):
                    continue
                name = enums[i + j]
                pixmap = style.standardPixmap(getattr(QStyle, name))
                pic_label = QLabel()
                txt_lbl = QLabel(name)
                pic_label.setPixmap(pixmap.scaled(QSize(width, width)))
                pic_label.setFixedWidth(width)
                txt_lbl.setFixedWidth(width * 5)
                row_lay.addWidget(pic_label)
                row_lay.addWidget(txt_lbl)
                row_lay.addStretch()
            layout.addLayout(row_lay)

if __name__ == "__main__":
    app = QApplication([])
    icon_viewer = IconViewer()
    icon_viewer.show()
    app.exec_()
```

### 自定义信号槽

```cpp
from PyQt5.QtCore import pyqtSignal
sig = pyqtSignal()
sig.connect(func)
sig.emit([args...])
```

### 设置默认字体

```text
QApplication::setFont()
```

### 窗口置灰不可操作

```py
wid = QWidget()
wid.setDisabled(True)
wid.setStyleSheet('color: grey')
# 恢复
wid.setDisabled(False)
wid.setStyleSheet('')
```

## 代码示例

### 创建主窗口

```python
import sys
from PyQt5.QtWidgets import QMainWindow, QApplication
from PyQt5.QtGui import QIcon


class FirstMainWin(QMainWindow):
    def __init__(self):
        super(FirstMainWin, self).__init__()
        # 设置主窗口的标题
        self.setWindowTitle('第一个窗口应用')
        # 设置窗口的尺寸
        self.setGeometry(300, 600, 400, 200)
        self.resize(400, 300)
        # 这里的图标无法显示，个人问题
        # 在QApplication方法中设置的图标可以应用与应用程序和主窗口图标，但在QMainWindow中的图标设置就只能在窗口中使用了
        self.setWindowIcon(QIcon(r'.images\3.ico'))
        self.setWindowIcon(QIcon(r'.images\2.jpg'))
        self.status = self.statusBar()
        self.status.showMessage('只存在5秒的消息', 5000)

    def closeEvent(self, event):
        print('FirstMainWin close event')


if __name__ == '__main__':
    app = QApplication(sys.argv)
    main = FirstMainWin()
    main.show()
    sys.exit(app.exec_())
```

### logging 日志窗口

```py
import logging
from PyQt5.QtCore import pyqtSignal, QObject
from PyQt5.QtWidgets import QApplication, QFrame, QPushButton, QTextEdit, QVBoxLayout, QHBoxLayout


class GuiLogHandler(QObject, logging.Handler):
    on_msg = pyqtSignal(int, str)

    def __init__(self, parent):
        super(QObject, self).__init__(parent)
        super(logging.Handler, self).__init__()

    def emit(self, record):
        msg = self.format(record)
        self.on_msg.emit(record.levelno, msg)


class LogWidget(QFrame):
    _COLOR_MAP = {logging.WARNING: 'blue', logging.ERROR: 'red'}
    _DEF_COLOR = 'black'

    def __init__(self, parent):
        super().__init__(parent)
        handler = GuiLogHandler(self)
        handler.on_msg.connect(self._append)
        logging.getLogger().addHandler(handler)
        self._init_ui()

    def _init_ui(self):
        btn_clear = QPushButton('clear', self)
        btn_clear.clicked.connect(self._clear)
        btn_lay = QHBoxLayout()
        btn_lay.addStretch()
        btn_lay.addWidget(btn_clear)

        self._text = QTextEdit(self)
        self._text.setReadOnly(True)

        lay = QVBoxLayout()
        lay.addLayout(btn_lay)
        lay.addWidget(self._text)
        self.setLayout(lay)
        self.setFrameStyle(QFrame.StyledPanel | QFrame.Sunken)

    def _clear(self):
        self._text.clear()

    def _append(self, level: int, text: str):
        color = self._COLOR_MAP.get(level, self._DEF_COLOR)
        text = text.replace('<', '&lt;')
        self._text.append(f'<font color={color}>{text}')


def show_log():
    logging.info('info')
    logging.warning('warning')
    logging.error('error')


def main():
    logging.getLogger().setLevel(logging.INFO)
    app = QApplication([])
    mw = QFrame()
    lay = QVBoxLayout()
    btn = QPushButton('show log', mw)
    btn.clicked.connect(show_log)
    lay.addWidget(btn)
    lay.addWidget(LogWidget(mw))

    mw.setLayout(lay)
    mw.show()
    app.exec_()
```

### 使用信号槽(pyqtSignal)

```python
from PyQt5.QtCore import pyqtSignal, QObject

# 自定义类型必须继承QObject
class SignalTest(QObject):
    # 定义信号，和槽函数参数数量与类型必须一致
    sigShow = pyqtSignal(str) # 发送/接收一个字符串类型参数
    def show(self):
        # 发送信号
        self.sigShow.emit("message from SignalTest")

class SlotTest(QObject):
    def slotShow(self, msg: str):
        print("SlotTest:", msg)

if __name__ == "__main__":
    sigObj = SignalTest()
    slotObj = SlotTest()
    # 连接信号槽
    sigObj.sigShow.connect(slotObj.slotShow)
    sigObj.show()
```

### QTreeView demo

[QTreeView](https://blog.csdn.net/zyhse/article/details/105893656)

### QDirModel demo

[QDirModel + QTreeView](https://www.w3cschool.cn/learnroadqt/emq31j4k.html)

### QAbstractItemModel demo

[QAbstractItemModel](https://blog.csdn.net/kenfan1647/article/details/119268945)
