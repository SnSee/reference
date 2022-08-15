
# cpython

demo: <https://docs.python.org/zh-cn/3/extending/index.html#extending-index>

 API: <https://docs.python.org/zh-cn/3/c-api/index.html>

## 环境

windows

[msys2安装指引](../../环境/windows.md#安装msys2)

```text
安装msys2后
将Python.h所在路径添加到头文件搜索路径(可以通过创建PYTHON_INCLUDE环境变量实现)
    Python.h路径: /安装位置/msys64/mingw64/include/python3.9/Python.h
将python库添加到库搜索路径(可以通过创建PYTHON_LIB环境变量实现)
    库路径: /安装位置/msys64/mingw64/lib/libpython3.9.dll.a
```

## cpp源文件

[自定义扩展类型](https://docs.python.org/zh-cn/3/extending/newtypes_tutorial.html)

### 主要流程

```cpp
#define PY_SSIZE_T_CLEAN
#include "Python.h"

PyObject *demoError;

PyObject *demo_system(PyObject *self, PyObject *args) {
    const char *command;
    int sts;

    if (!PyArg_ParseTuple(args, "s", &command)) return NULL;
    sts = system(command);
    if (sts < 0) {
        PyErr_SetString(demoError, "System command failed");
        return NULL;
    }
    return PyLong_FromLong(sts);
}

PyMethodDef demoMethods[] = {
    {"system", demo_system, METH_VARARGS, "Execute a shell command."},
    {NULL, NULL, 0, NULL} /* Sentinel */
};

struct PyModuleDef demomodule = {PyModuleDef_HEAD_INIT, "demo", NULL, -1,
                                        demoMethods};


extern "C" PyMODINIT_FUNC PyInit_demo(void) {
    PyObject *m;

    m = PyModule_Create(&demomodule);
    if (m == NULL) return NULL;

    demoError = PyErr_NewException("demo.error", NULL, NULL);
    Py_XINCREF(demoError);
    if (PyModule_AddObject(m, "error", demoError) < 0) {
        Py_XDECREF(demoError);
        Py_CLEAR(demoError);
        Py_DECREF(m);
        return NULL;
    }

    return m;
}
```

### 向module中添加class

#### 创建class类型

```cpp
struct Macro {

};

static PyObject *Macro_test(PyObject *self, PyObject *args) {
    std::cout << "Macro_test: " << std::endl
              << "\t"
              << "args: " << std::endl;
    for (int i = 0; i < PyTuple_Size(args); ++i) {
        auto item = PyTuple_GetItem(args, i);
        std::cout << "\t\t" << Py_TYPE(item)->tp_name << std::endl;
    }
    return self;
}

static PyMethodDef macroMethods[] = {
    {"test", Macro_test, METH_VARARGS, "macro test."},
    {NULL, NULL, 0, NULL} /* Sentinel */
};

static PyTypeObject pyMacro = {
    PyVarObject_HEAD_INIT(NULL, 0)
    .tp_name = "Macro",             // 类名
    .tp_basicsize = sizeof(Macro),  // 创建对象时申请内存大小
    .tp_itemsize = 0,               // 非0为变长对象，表示创建对象时应额外申请内存大小
    .tp_flags = Py_TPFLAGS_DEFAULT,
    .tp_methods = macroMethods,     // 方法
    .tp_new = PyType_GenericNew,
};
```

#### 添加class

```cpp
bool registerClass(PyObject *module, PyTypeObject &obj) {
    Py_INCREF(&obj);
    if (PyModule_AddType(module, &obj) < 0) {
        Py_DECREF(&pyMacro);
        Py_DECREF(module);
        std::stringstream ss;
        ss << "Register class " << obj.tp_name << " failed.";
        PyErr_SetString(PyErr_Occurred(), ss.str().c_str());
        return false;
    }
    return true;
}
```

## setup.py

```python
import os
from distutils.core import setup, Extension

curPath = os.path.dirname(os.path.abspath(__file__))
srcDir = os.path.dirname(os.path.dirname(curPath))


module1 = Extension('demo',
                    include_dirs=[srcDir],
                    library_dirs=[],
                    libraries=[],   # 注意：如果库之间也有依赖，如: a依赖b，b依赖c，则顺序必须为 [a, b, c]
                    extra_compile_args=[],
                    extra_link_args=[],
                    sources=['pylef.cpp']
                    )

setup(name='pylef',
      version='1.0',
      description='This is a demo package',
      ext_modules=[module1]
      )
```

## 编译

```shell
python setup.py build
# 安装到指定路径
python setup.py install --prefix=/path/to/install
```

build/lib.xxx/demo.cp39-xxx.pyd即为python模块

## 使用

```python
import demo
demo.system("ls")
```

## 内置类型对应关系

[对象层](https://docs.python.org/zh-cn/3/c-api/)

```text
bool        - Py_False, Py_True
int         - PyLongObject
float       - PyFloatObject
bytes       - PyBytesObject
str         - 可能是PyASCIIObject, PyCompactUnicodeObject, PyUnicodeObject?
list        - PyListObject
tuple       - PyTupleObject
set         - PySetObject
dict        - PyDictObject
```

## 一些函数

创建str

```text
PyUnicode_FromString
```

创建对象

```text
TYPE* PyObject_New(TYPE, PyTypeObject *type)
    返回的对象可以强转成PyObject*
    不会调用构造函数
```

获取属性

```text
PyObject *(*getattrfunc)(PyObject *self, char *attr);
```
