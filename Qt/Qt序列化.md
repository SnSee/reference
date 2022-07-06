
# 1.概述

Qt采用QDataStream来实现序列化。对Qt原生数据类型用户不用进行额外操作，对自定义数据类型，需要重载 << 和 >>.

一些重要接口：

```cpp
class QDataStream {
public:
    QDataStream(QByteArray *, QIODevice::OpenMode);

    void setVersion(int v);
    int version() const;

    QDataStream &operator<<(DataType);
    QDataStream &operator<<(DataType);
};
```

# 2.基础使用流程

## 2.1 Qt原生数据类型

### 2.1.1 序列化

以QMap为例:

```cpp
QMap<QString, QString> data = {
    {"Apple", "apple"},
    {"Orange", "orange"}
};

QFile file("test.dat");
file.open(QIODevice::WriteOnly);
QDataStream out(&file);

out << data;

QMap<QString, int> data2 = {
    {"index1", 1},
    {"index2", 2}
};
out << data2;

file.close();
```

### 2.1.2 反序列化

以QMap为例:

```cpp
QFile file("test.dat");
file.open(QIODevice::ReadOnly);
QDataStream in(&file);
QMap<QString, QString> data;

in >> data;
qDebug() << data;

QMap<QString, int> data2;
in >> data2;
qDebug() << data2;

file.close();
```

## 2.2 自定义数据类型

### 2.2.1 自定义类型

```cpp
class MyData {
private:
    friend QDataStream& operator>>(QDataStream&, MyData&);
    friend QDataStream& operator<<(QDataStream&, MyData&);

    int type;
    QString name;
};
```

重载 >> 和 <<

```cpp
QDataStream& operator>>(QDataStream& in, MyData& data) {
    in >> data.type >> data.name;
    return in;
}

QDataStream& operator<<(QDataStream& out, MyData& data) {
    out << data.type << data.name;
    return out;
}
```

### 2.2.2 序列化

和[原生数据类型](#211-序列化)用法一样.

### 2.2.3 反序列化

和[原生数据类型](#212-反序列化)用法一样.

# 3.版本控制与兼容性

## 3.1 设置版本号

通过setVersion可以设置Qt版本，以读取使用更早版本Qt存储的数据，或者将数据存储为更早版本Qt可以读取的数据。

如果存取数据的版本不一致可能无法取出数据。

因此使用Qt版本控制需要知道存储文件中数据的版本。

```cpp
void QDataStream::setVersion(int v);

int QDataStream::version() const;
```

示例：

```cpp
QDataStream out(file);
out.setVersion(QDataStream::Qt_4_0);
```

枚举类型QDataStream::Version中定义了所有当前Qt支持的版本。在 << 和 >> 中如果数据和版本相关，需要根据版本号进行不同操作。

暂时没有找到有新增或删减成员属性的原生数据类型。

## 3.2 不同版本中成员属性数量或顺序发生变化

```text
需要保证存取数据时版本一致，相同版本条件下存取数量及顺序一致。
新版本如果读取旧版本数据，需要设置版本号，根据版本号按旧版本方式读取。
新版本的数据如果需要旧版本也能读取，需要设置版本号，根据版本号按旧版本方式写入。
```

# 4.原理及源码分析

QDataStream的存取是基于字节流的，通过存储文件本身无法识别数据类型，数据类型取决于接收数据的类型，因此需要使用者自己保证存取一致性。

## 4.1 原生数据类型

### 4.1.1 整型

Qt使用typedef为C整型创建了别名：

```cpp
typedef signed char qint8;         /* 8 bit signed */
typedef unsigned char quint8;      /* 8 bit unsigned */
typedef short qint16;              /* 16 bit signed */
typedef unsigned short quint16;    /* 16 bit unsigned */
typedef int qint32;                /* 32 bit signed */
typedef unsigned int quint32;      /* 32 bit unsigned */

// qint64和quint64的定义涉及一些预处理判断，为方便显示只列出一种。
typedef long long qint64;           /* 64 bit signed */
typedef unsigned long long quint64; /* 64 bit unsigned */
```

只有64位整型涉及版本问题

源码路径：qtbase\src\corelib\serialization\qdatastream.cpp

```cpp
QDataStream &QDataStream::operator<<(qint64 i) {
    CHECK_STREAM_WRITE_PRECOND(*this)
    if (version() < 6) {
        quint32 i1 = i & 0xffffffff;
        quint32 i2 = i >> 32;
        *this << i2 << i1;
    } else {
        if (!noswap) {
            i = qbswap(i);
        }
        if (dev->write((char *)&i, sizeof(qint64)) != sizeof(qint64))
            q_status = WriteFailed;
    }
    return *this;
}
```

其他整型都是直接调用QIODevice的函数输出(putChar, write等)。bool类型输出时会转换成qint8。

存储文件大小为 $\sum_{i=0}^{n} x_i$ 字节，其中$x_i$为存储时整型字节数。用16进制打开文件，内容正是数字的16进制表示形式.

### 4.1.2 浮点型

在4.6及以上版本会进行float/double的精度判断.

源码路径：qtbase\src\corelib\serialization\qdatastream.cpp

```cpp
QDataStream &QDataStream::operator<<(float f) {
    if (version() >= QDataStream::Qt_4_6
        && floatingPointPrecision() == QDataStream::DoublePrecision) {
        *this << double(f);
        return *this;
    }
    ...
}

QDataStream &QDataStream::operator<<(double f) {
    if (version() >= QDataStream::Qt_4_6
        && floatingPointPrecision() == QDataStream::SinglePrecision) {
        *this << float(f);
        return *this;
    }
    ...
}
```

浮点型数据存储文件大小和整型公式一致。

### 4.1.3 const char *

源码路径：qtbase\src\corelib\serialization\qdatastream.cpp

```cpp
QDataStream &QDataStream::operator<<(const char *s) {
    if (!s) {
        *this << (quint32)0;
        return *this;
    }
    uint len = qstrlen(s) + 1;                        // also write null terminator
    *this << (quint32)len;                        // write length specifier
    writeRawData(s, len);
    return *this;
}

int QDataStream::writeRawData(const char *s, int len) {
    CHECK_STREAM_WRITE_PRECOND(-1)
    int ret = dev->write(s, len);
    if (ret != len)
        q_status = WriteFailed;
    return ret;
}
```

char*类型存储结构由 4字节头 + 实际字符串(每个字符一字节) + 0x00结尾 构成。4字节头表示字符串字节数，包括结尾的0.

### 4.1.4 QString

QString重载了 << 和 >>，在其中根据设置的版本进行不同的存取操作.

源码路径：qtbase\src\corelib\text\qstring.cpp

```cpp
QDataStream &operator<<(QDataStream &out, const QString &str) {
    if (out.version() == 1) {
        out << str.toLatin1();
    } else {
        if (!str.isNull() || out.version() < 3) {
            if ((out.byteOrder() == QDataStream::BigEndian) == (QSysInfo::ByteOrder == QSysInfo::BigEndian)) {
                out.writeBytes(reinterpret_cast<const char *>(str.unicode()), sizeof(QChar) * str.length());
            } else {
                QVarLengthArray<ushort> buffer(str.length());
                qbswap<sizeof(ushort)>(str.constData(), str.length(), buffer.data());
                out.writeBytes(reinterpret_cast<const char *>(buffer.data()), sizeof(ushort) * buffer.size());
            }
        } else {
            // write null marker
            out << (quint32)0xffffffff;
        }
    }
    return out;
}

QDataStream &operator>>(QDataStream &in, QString &str) {
    if (in.version() == 1) {
        QByteArray l;
        in >> l;
        str = QString::fromLatin1(l);
    } else {
        ...
    }
    return in;
}
```

QString存储结构由 4字节头 + 实际字符串(每个字符两字节) 组成。4字节表示字符串总字节数。

部分早期版本的QString字符串中每个字符是一个字节。

### 4.1.5 QMap

源码路径：qtbase\src\corelib\tools\qmap.cpp

QMap需要key和value都重载了 << 和 >>.

源码路径: qtbase\src\corelib\serialization\qdatastream.h

```cpp
template <class Key, class T>
inline QDataStream &operator>>(QDataStream &s, QMap<Key, T> &map) {
    return QtPrivate::readAssociativeContainer(s, map);
}

template <class Key, class T>
inline QDataStream &operator<<(QDataStream &s, const QMap<Key, T> &map) {
    return QtPrivate::writeAssociativeContainer(s, map);
}
```

QMap<Key, Value>存储结构依赖于Key和Value, 由 4字节头 + 重复的{Key，Value} 组成，4字节头表示元素对数。

## 4.2 自定义数据类型

自定义数据类型中的所有成员属性需要重载了 << 和 >>，然后自身也重载 << 和 >>，在重载函数中调用成员在重载函数即可，需要保证存取顺序一致.
具体重载方式可参考[自定义数据类型](#221-自定义类型)中的用法.
