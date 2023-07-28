
# meson

安装

```sh
pip install meson
sudo apt-get install ninja-build
# 或
sudo apt-get install ninja
# windows 下载链接中的压缩包，解压后将路径添加到PATH
```

[ninja下载链接](https://github.com/ninja-build/ninja/releases)

编译

```sh
mkdir build && cd build
meson .. --prefix=/where/to/install
ninja -j 10
ninja install
```
