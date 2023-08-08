#!/bin/bash -f
export CC=/d/software/msys64/mingw64/bin/gcc.exe
export CXX=/d/software/msys64/mingw64/bin/g++.exe

export BOOST_DIR=/d/work/aip/code/ViewParser/third_party/boost_1_78_0
# boost::python 库
export BOOST_PYTHON_LIB_DIR=/d/lib/lib
export BOOST_PYTHON_LIB_NAME=boost_python39

export PYTHON_LIB_NAME=python39     # windows
# export PYTHON_LIB_NAME=python3.9    # linux


# export DISTUTILS_DEBUG=1

python setup.py build --compiler=mingw32
python setup.py install --prefix=./build/lib
