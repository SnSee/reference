from PyQt5.QtWidgets import QTreeView
from PyQt5.QtCore import Qt
from PyQt5.QtCore import QAbstractItemModel, QModelIndex


class _TreeItem:
    def __init__(self, value="", row: int = 0, parent: "_TreeItem" = None):
        """parent: _TreeNode"""
        self._mParent = parent
        self._mRow = row
        self._mValue = value
        self._mChildren = []

    @property
    def row(self) -> int:
        return self._mRow

    @property
    def value(self) -> str:
        return self._mValue

    @property
    def parent(self) -> "_TreeItem":
        return self._mParent

    def childCount(self) -> int:
        return len(self._mChildren)

    def child(self, row: int) -> "_TreeItem":
        return self._mChildren[row]

    def addChild(self, value: str) -> "_TreeItem":
        child = _TreeItem(value, self.childCount(), self)
        self._mChildren.append(child)
        return child


class DictModel(QAbstractItemModel):
    def __init__(self):
        super(DictModel, self).__init__()
        self._mRootItem = _TreeItem()

    @classmethod
    def _buildTree(cls, parentItem: _TreeItem, value):
        if isinstance(value, dict):
            for key, val in value.items():
                childItem = parentItem.addChild(key)
                cls._buildTree(childItem, val)
        elif isinstance(value, list):
            for val in value:
                cls._buildTree(parentItem, val)
        else:
            parentItem.addChild(value)

    def update(self, results: dict):
        self.beginResetModel()
        self._mRootItem = _TreeItem()
        self._buildTree(self._mRootItem, results)
        self.endResetModel()

    def updateItem(self, names: [str]):
        """通过名称找到item，并刷新item"""
        pass

    def index(self, row: int, column: int, parent: QModelIndex = None, *args, **kwargs) -> QModelIndex:
        if not self.hasIndex(row, column, parent):
            return QModelIndex()
        if not parent.isValid():
            parentItem = self._mRootItem
        else:
            parentItem = parent.internalPointer()
        childItem = parentItem.child(row)
        if childItem:
            return self.createIndex(row, column, childItem)
        return QModelIndex()

    def parent(self, index: QModelIndex = None):
        if not index.isValid():
            return QModelIndex()
        childItem = index.internalPointer()
        parentItem = childItem.parent
        if parentItem is self._mRootItem:
            return QModelIndex()
        return self.createIndex(parentItem.row, 0, parentItem)

    def rowCount(self, parent: QModelIndex = None, *args, **kwargs):
        if not parent.isValid():
            parentItem = self._mRootItem
        else:
            parentItem = parent.internalPointer()
        return parentItem.childCount()

    def columnCount(self, parent: QModelIndex = None, *args, **kwargs):
        return 1

    def data(self, index: QModelIndex, role: Qt.ItemDataRole = None):
        if not index.isValid():
            return None
        item = index.internalPointer()
        if role == Qt.DisplayRole:
            return item.value
        return None


if __name__ == "__main__":
    import sys
    from PyQt5.QtWidgets import QApplication
    app = QApplication(sys.argv)
    view = QTreeView()
    view.header().setVisible(False)
    model = DictModel()
    view.setModel(model)
    data = {"a1": {"a2": {"a3": ["b", "c", "d"]}}, "b1": [{"b2": "b3"}, "b4", "b5"]}
    model.update(data)
    view.show()
    view.resize(500, 300)
    app.exec()
