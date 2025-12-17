
# cpp环境

## 1. 安装cpp环境

### 1.1. 安装gcc

#### 1.1.1. 下载

[cmake](https://cmake.org/download)
[gcc源码官方镜像](https://gcc.gnu.org/mirrors.html)
[gcc nju](http://mirrors.nju.edu.cn/gnu/gcc)
[gcc ustc](http://mirrors.ustc.edu.cn/gnu/gcc)
[gcc 清华](https://mirrors.tuna.tsinghua.edu.cn/gnu/gcc)
[mingw镜像](http://files.1f0.de/mingw)

#### 1.1.2. 源码安装

```bash
version_num=12.1.0
install_dir="./gcc-{version_num}"

tar xvf gcc-${version_num}.tar.gz
cd gcc-{version_num}
# ./contrib/download_prerequisites
./configure --prefix=${install_dir}
# ./bootstrap
make -j8 && make install
```

如果遇到错误提示：configure: error: Building GCC requires GMP 4.2+, MPFR 2.4.0+ and MPC 0.8.0+.

<https://blog.csdn.net/banyu0052/article/details/101946349>

[ftp下载地址](ftp://gcc.gnu.org/pub/gcc/infrastructure)

```bash
# 如果GMP没安装在系统路径，安装 MPFR 和 MPC 时指定GMP路径
./configure --prefix=/test --with-gmp-include=/test/include --with-gmp-lib=/test/lib
```

安装脚本(MPFR, MPC, gcc都适用)

```bash
#!/bin/bash
target_dir=/install/dir
./configure --prefix=${target_dir} --with-gmp-include=${target_dir}/include --with-gmp-lib=${target_dir}/lib
make -j8 && make install
```

[动态库路径](#33-设置动态库路径)

[切换gcc版本](https://blog.csdn.net/u014421520/article/details/119445020)

### 1.2. 安装bison

#### 1.2.1. 源码安装

<https://mirrors.tuna.tsinghua.edu.cn/gnu/bison/?C=S&O=D>

```bash
target_dir=/install/dir
./configure --prefix=${target_dir}
make -j8 && make install
```

### 1.3. 安装flex

<http://flex.sourceforge.net>

#### 1.3.1. 依赖(安装方法同bison)

bison

<https://mirrors.tuna.tsinghua.edu.cn/gnu/libtool/>

<https://mirrors.tuna.tsinghua.edu.cn/gnu/gettext/>

<https://mirrors.tuna.tsinghua.edu.cn/gnu/texinfo/>

<https://mirrors.tuna.tsinghua.edu.cn/gnu/help2man/>

<https://mirrors.tuna.tsinghua.edu.cn/gnu/autoconf/>

<https://mirrors.tuna.tsinghua.edu.cn/gnu/automake/>

```text
注意事项:
1.安装flex时可能要求automake是指定版本
2.安装automake-1.15时如果报错
    help2man: can't get '--help' info from automake-1.15
    打开Makefile: 找到
        doc/automake-$(APIVERSION).1: $(automake_script) lib/Automake/Config.pm
            $(update_mans) automake-$(APIVERSION) --no-discard-stderr
    最后加上 --no-discard-stderr
3.automake --version如果提示
    Can't locate Thread/Queue.rpm
    安装: <http://vault.centos.org/7.9.2009/os/Source/SPackages/perl-Thread-Queue-3.02-2.el7.src.rpm>
    如果没有权限，可以先源码安装perl, 然后rpm -ivh --nodeps xxx.rpm
    设置perl模块路径：export PERL5LIB=/myperl/lib/site_perl/5.26.1 (在该路径下有moduel名，如 Thread)
```

#### 1.3.2. 源码安装

```bash
./autogen.sh
# 然后同bison
```

## 2. 编译环境

## 3. 运行时环境

### 3.1. 运行时动态库加载顺序

```text
可执行程序所在目录
-Wl,-rpath指定路径
LD_LIBRARY_PATH
/etc/ld.so.conf中的路径
/lib:/lib64
/usr/lib:/usr/lib64
```

### 3.2. 查看

```bash
# 查看程序依赖库
ldd app_name
readelf -d app_name
```

### 3.3. 设置动态库路径

注意: 程序要使用的是32位还是64位版本动态库

```bash
# 方式一
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/your/lib/path
# 使用 sudo 时由于切换了用户，需要再次设置
sudo LD_LIBRARY_PATH=/your/lib/path command

# 方式二
在 /etc/ld.so.conf 增加一行 /your/lib/path

# 方式三
编译时指定
-Wl,-rpath=/your/lib/path
```

## 安装gdb {id="gdb"}

[ftp下载地址](ftp://ftp.gnu.org/gnu/gdb/)

```bash
# 解压
./configure --prefix=...
# 如果报错: C compiler cannot create executables
# 打开 config.log 搜索error，找到对应行号<line>
# 打开 configure, 在<line>上方删除 -V 和 -qversion
make -j8 && make install
```

## 安装boost

[下载地址](https://www.boost.org/users/download/)

[更多编译选项](../program_language/c-cpp/boost.md#编译)

```sh
# 解压
./bootstrap.sh              # 编译 b2
./b2                        # 编译所有模块
./b2 --with-<module_name>   # 编译指定模块
# 安装
sudo ./b2 install --prefix=/where/to/install
```
