
# PyQt5

[官网用户手册](https://doc.qt.io/qtforpython/modules.html)

[api查询](https://www.riverbankcomputing.com/static/Docs/PyQt5/sip-classes.html)

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


if __name__ == '__main__':
    app = QApplication(sys.argv)
    main = FirstMainWin()
    main.show()
    sys.exit(app.exec_())
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

### QTreeView

[QTreeView](https://blog.csdn.net/zyhse/article/details/105893656)

### QDirModel

[QDirModel + QTreeView](https://www.w3cschool.cn/learnroadqt/emq31j4k.html)

### QAbstractItemModel

[QAbstractItemModel](https://blog.csdn.net/kenfan1647/article/details/119268945)
