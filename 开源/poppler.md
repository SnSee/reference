
# poppler

```text
# 库链接
https://anongit.freedesktop.org/git/poppler/poppler.git
```

依赖库

```text
zlib    : https://github.com/madler/zlib
bzip2   : https://gitlab.com/federicomenaquintero/bzip2.git
libpng  : https://github.com/glennrp/libpng
libjpeg : https://github.com/LuaDist/libjpeg.git
freetype: https://gitlab.freedesktop.org/freetype/freetype
openjpeg: https://github.com/uclouvain/openjpeg.git
cairo   : git://git.cairographics.org/git/cairo
boost   : 可以不使用boost
```

[boost安装](../环境/cpp.md#安装boost)

编译

```sh
# windows 下使用 mingw 编译
mkdir build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/d/lib -G "Unix Makefiles"
# 不使用boost
# cmake .. -DCMAKE_INSTALL_PREFIX=/d/lib -G "Unix Makefiles" -DENABLE_BOOST=OFF
make -j8
make install
```
