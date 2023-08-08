
# README

通过cmake编译检查是否有语法错误，然后执行 build.sh 编译出python包

export DISTUTILS_DEBUG=1 来显示更多的日志信息

设置gcc路径时要用unix格式

```sh
export CC=/bin/gcc
export CXX=/bin/g++
```

msys2的python可能有bug，需要修改 $MSYS2/mingw64/lib/python3.9/site-packages/setuptools/_distutils/cygwinccompiler.py

```python
# Additional libraries
if self.dll_libraries:  # 添加这句
    libraries.extend(self.dll_libraries)
```
