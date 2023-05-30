# Linux环境

## make(gmake)

[下载链接](https://ftp.gnu.org/gnu/make/)

```bash
tar xvf make-xxx.tar.gz
cd make-xxx
mkdir build && cd build
../configure --prefix=/where/to/install
make -j8 && make install
```

## glibc

[下载链接](https://ftp.gnu.org/gnu/glibc/)

```bash
tar xvf glibc-xxx.tar.gz
cd glibc-xxx
mkdir build && cd build
# 如果configure报错make版本过低，为最新的make创建一个名为gmake的软链接
../configure --prefix=/where/to/install
make -j8 && make install
```

## rpm

```bash
# 使用rpm安装离线包
rpm -i --nodeps --prefix=/home/test test.rpm
    --prefix 指定安装位置
    --nodeps 不校验包依赖

# 查看rpm包是否可以指定安装位置
rpm -qpi test.rpm
# Relocations 字段
```

## perl

[下载链接](http://search.cpan.org/CPAN/authors/id/S/SH/SHAY/perl-5.26.1.tar.gz)

```bash
# 解压
./Configure -des -Dprefix=/install_dir/perl
make && make test
make install
```

## go {id="go"}

[下载地址](https://golang.google.cn/dl/)

```bash
解压后可直接使用(bin/go)
```

## tcl {id="tcl"}

[下载地址](https://github.com/tcltk/tcl)

```bash
# 参考 unix/README.md 进行安装
./configure --prefix=...
# configure可指定编译选项，使用 --enable-symbols 为debug模式
# 如果需要其他编译选项参考README
make -j8 && make install
```

## Qt {id="Qt"}

[官方安装文档](https://doc.qt.io/qt-5.15/linux-building.html)

[下载地址](http://mirrors.ustc.edu.cn/qtproject/archive/qt/)

源码安装

```bash
# 下载 tar.xz 压缩包
# gunzip qt-everywhere-opensource-src-%VERSION%.tar.gz        # uncompress the archive
tar xvf qt-everywhere-opensource-src-%VERSION%.tar          # unpack it
mkdir build && cd build
./configure --prefix=...
# 选择开源版(o选项)
make -j8 && make install
make docs   # 帮助文档
```

[qtcreator下载地址](http://mirrors.ustc.edu.cn/qtproject/archive/qtcreator/)

安装包安装

```bash
# 下载 xxx.run 安装包
chmod u+x xxx.run
./xxx.run
# 根据步骤安装即可
```

源码编译

```bash
qmake
make -j8
# 如果报错重定义 std::hash<QString>, 把 qtcreator 目录下定义注释掉
# 如果报错未定义 QPainterPath, 加上 #include "qpainterpath.h"
# 如果报错std不包含numeric_limits，加上 #include <limits>
# 导致这些错误的原因是 Qt 和 qtcreator 版本不匹配
```
