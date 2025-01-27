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

# 如果出现-Werror=xxx错误可以通过添加编译选项 -Wno-error=xxx 忽略
# 在 config.make 中查找 CFLAGS 进行添加
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

[安装包镜像](https://download.qt.io/official_releases/online_installers/)

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

## pkg-config

[源码](https://github.com/Distrotech/pkg-config)

```sh
./configure --prefix=/install/dir
make && make install
```

## libevent

[下载](https://github.com/libevent/libevent/releases/tag/release-2.1.12-stable)

```sh
./configure --prefix=/install/dir
make && make install
```

## openssl

[下载](https://www.openssl.org/source/)

安装参考 README.md 即可

## xclip

[用法](../命令/linux.md#xclip)

[github](https://github.com/astrand/xclip)

如果已经安装了X11环境，可以直接使用gcc编译，如果系统头文件缺失需要自己下载然后通过 -I 指定，动态库名称不对可以通过软链接改名，如 libXmu.so.6.2.0 -> libXmu.so

```sh
gcc xclib.c xclip.c xcprint.c -lXmu -lX11 -o xclip
```

以下是自己安装 X11 方式(不推荐)

**注意**: 自己安装 X11 可能会导致系统 X11 库混乱而导致很多软件不可用或卡顿

[X11 pacakge 下载地址](https://www.x.org/releases/X11R7.7/src/everything/)

* 安装 xclip 时如果没有 Xmu 环境需要先安装(搜索libXmu)
* 安装 Xmu 时如果没有 xorg-macros 环境需要先安装(搜索macro)
* 安装 Xmu 时如果没有以下package需要先安装(直接搜索)

需要的包（按顺序安装）

* xtrans
* xproto
* xextproto
* ice
* sm
* xcb-proto
* xau
* pthread-stubs
* xcb
* kbproto
* inputproto
* x11

```sh
# 安装 package
./configure --prefix=/where/to/install
make -j8 && make install

# 安装 libXmu
./autogen.sh
./configure --prefix=/where/to/install
```

## xsel

[用法](../命令/linux.md#xsel)

[github](https://github.com/kfish/xsel)

```sh
gcc xsel.c -lX11 -o xsel
```

## 终端类型

settings -> Preferred Applications -> utilities -> Terminal Emulator

选择 GNOME Terminal

## DNS

### DNS 解析问题

```sh
ping www.baidu.com          # 测试能否 ping 通域名
ping 8.8.8.8                # 测试能够 ping 通解析 DNS IP

# 如果能 ping 通 IP 而 ping 不通域名，说明 DNS 解析有问题
# 打开文件并添加如下 nameserver
# nameserver 8.8.8.8
# nameserver 8.8.4.4
sudo vim /etc/resolv.conf

resolvectl flush-caches     # 刷新 DNS
```
