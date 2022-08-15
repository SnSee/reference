
# boost

## 编译

windows下使用 git-bash + msys2 编译

```text
--toolset=msvc-11.0: 指编译器为vc110的
--with-python: 只编译python库了
link: 静态链接库(=static), 动态链接库(=shared)
runtime-link: 动态/静态链接C++运行库，有shared和static两种方式
threading=multi: 单/多线程编译，一般写多线程，直接指定为multi
--build-type=complete: 编译所有版本
```

### 编译python

如果提示找不到pyconfig.sh: export CPLUS_INCLUDE_PATH=/test/msys64/mingw64/include/python3.9

[编译python](https://blog.csdn.net/NarutoInspire/article/details/116306260)

## 使用boost::python

### 在其他项目中使用

```text
# 在windows下建议使用boost::python静态库，编译项目时需要指定编译参数宏
-DBOOST_PYTHON_STATIC_LIB
对于cmake项目，可以使用命令: add_definitions(-DBOOST_PYTHON_STATIC_LIB)
对setup.py，可以设置Extension参数: extra_compile_args = ["-DBOOST_PYTHON_STATIC_LIB"]
```

### 获取python对象

```cpp
namespace bp = boost::python;
// 获取module对象
bp::object py_module = import("module_name");
// 获取module命名空间(一个dict对象)
bp::object module_namespace = py_module.attr("__dict__");
// 获取对象, attr_name可以是任意module中的名称，如类名，函数名，全局变量名等，返回值也是对应类型的对象
bp::object tmp = module_namespace["attr_name"]

// 创建bp对象, 参数和tmp对应的python对象传参一致, 如传入 int 和 str
bp::object obj = tmp(1, "test");
```

### bp::list

```cpp
// bp::list可以添加任意bp::object类型的对象
bp::list bl;
bp.append(1);
bp.append('a');
bp.append("test");
bp.append(tmp(1, "test"));
```

```cpp
// 遍历
boost::python::stl_input_iterator<int> begin(mAllMacros), end;
for (auto i = begin; i != end; ++i) {
    int value = *i;
    std::cout << value << std::endl;
}
```
