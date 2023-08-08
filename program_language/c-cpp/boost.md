
# boost

[代码示例](../../templates/code/boost-python/python-lib/README.md)

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

注意事项

* boost::python::list 如果未与python对象绑定, 作为成员变量时不能直接使用？否则析构时会引发段错误，需要使用指针形式

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

### 数据类型

```cpp
auto a = bp::object(1);         // 对应 python int
int ia = bp::extract<int>(a);   // 一般情况下无需转换, boost对象重载了int类型的运算符
```

bp::list

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

for (int i = 0; i < bp::len(bl); ++i) {
    auto tmp = bl[i];
    // int value = bp::extract<int>(tmp);
}
```

tuple

```cpp
bp::make_tuple("test", 1);
```

bp::dict

```cpp
bp::dict d;
d['a'] = 1;
bool ha = d.has_key('a');
```

遍历

```cpp
#include <boost/python.hpp>
#include <iostream>

namespace bp = boost::python;

int main() {
    bp::dict dict;
    dict["key1"] = "value1";
    dict["key2"] = 42;
    dict["key3"] = true;

    for (bp::dict::iterator iter = dict.begin(); iter != dict.end(); ++iter) {
        bp::object key_obj = iter->first;
        bp::object value_obj = iter->second;

        string key = bp::extract<string>(key_obj);

        if (PyBool_Check(value_obj.ptr())) {
            bool value = bp::extract<bool>(value_obj);
        } else if (PyInt_Check(value_obj.ptr())) {
            int value = bp::extract<int>(value_obj);
        } else if (PyString_Check(value_obj.ptr())) {
            string value = bp::extract<string>(value_obj);
        }
    }

    for (const bp::object& item : bp::object(dict.items())) {
        bp::object key_obj = item[0];
        bp::object value_obj = item[1];
    }

    return 0;
}
```
