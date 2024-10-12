
# cmake

[官方文档](https://cmake.org/cmake/help/latest/index.html)

[commands](https://cmake.org/cmake/help/latest/manual/cmake-commands.7.html)

## 环境设置

### 环境变量

```cmake
# 引用系统环境变量
$ENV{PATH}

# 在if中不需要使用 $

# 创建环境变量
set(ENV{name} value)
```

### 注意事项

```sh
# 如果更改CMakeLists.txt后错误没解决，可能是缓存问题，删除 build/CMakeCache.txt
```

### 指定编译选项

```sh
# 配置
cd build && cmake ..

# 编译
cmake --build . -j 10
# linux下可以 make -j10

-j          : 进程数
-S          : 指定 CMakeLists.txt 所在路径，默认当前
-B          : 指定编译路径，默认当前
--target    : 编译指定目标
--build     : 编译配置好的 cmake project

# 安装
cmake --build . --target install
```

指定gcc路径

```bash
export CC=/usr/local/bin/gcc
export CXX=/usr/local/bin/g++
```

或者在执行cmake时指定

```bash
cmake -D CMAKE_C_COMPILER=/gcc_path/bin/gcc -D CMAKE_CXX_COMPILER=/gcc_path/bin/g++ .
```

指定编译器及安装路径

```sh
# 使用 mingw 编译器
cmake -G "MinGW Makefiles" ..  -DCMAKE_INSTALL_PREFIX=/path/to/install
```

vscode编译命令示例

```sh
cmake -DCMAKE_BUILD_TYPE:STRING=Debug -DCMAKE_C_COMPILER:FILEPATH=/bin/gcc -DCMAKE_CXX_COMPILER:FILEPATH=/bin/g++ -S/my/project -B/my/project/build -G "Unix Makefiles"
```

#### 宏选项

|宏 |值
|- |-
|CMAKE_PREFIX_PATH      |包、库等搜索路径
|CMAKE_BUILD_TYPE       |编译类型，Debug/Release

## 语法

命令文档: <https://cmake.org/cmake/help/latest/manual/cmake-commands.7.html>

### commands

#### find_library

```cmake
find_library(MYLIB_PATH mylib PATHS /usr/local/lib)
# 检查是否找到库
if(NOT MYLIB_PATH)
    message(FATAL_ERROR "mylib not found")
else()
    message(STATUS "mylib found at ${MYLIB_PATH}")
endif()
```

### 版本

```cmake
检查最低版本
    cmake_minimum_required(VERSION "3.14.2")
比较版本
    if("${CMAKE_VERSION}" VERSION_LESS "MY_VERSION")
    ${CMAKE_VERSION}为cmake自定义变量
```

### 条件语句

* 在 if 中不需要使用 $

```cmake
if(<condition>)
    ...
elseif(<condition>)
    ...
else()
    ...
endif()

condition可取值
    常量
        表示真: ON, YES, TRUE, Y, 非0数字
        表示假: OFF, NO, FALSE, N, 0, IGNORE, NOTFOUND, 空字符串, -NOTFOUND结尾字符串
    变量(变量名不需要使用${})
        变量值为常量里表示假的值时为假，否则为真
        环境变量不可作为条件

逻辑运算
    NOT, AND, OR, 可以有括号，优先级最高

存在性判断
    if(COMMAND command-name) 给定参数是否是可调用的命令，宏或函数
    if(POLICY policy-id) 给定的策略是否存在
    if(TARGET target-name) 给定的目标参数是否是通过add_executable，add_library或add_custom_target创建的
    if(TEST test-name) 给定参数是否是通过add_test创建并存在的
    if(DEFINED name) 变量是否存在(ENV{name}表示环境变量，既可以是系统环境变量，也可以通过set(ENV{name} var)创建)
    if(a IN_LIST b) a是否存在于列表b中

文件判断
    if(EXISTS path) 路径是否存在
    if(file1 IS_NEWER_THAN file2) file1是否比file2新
    if(IS_DIRECTORY path)
    if(IS_SYMLINK path)
    if(IS_ABSOLUTE path)

比较
    if(字符串 MATCHES regex) 是否匹配正则表达式
    if(数字 LESS 数字) 数字可以是字符串形式的
        LESS GREATER EQUAL LESS_EQUAL GREATER_EQUAL
    if(字符串 STRLESS 字符串)
        STRLESS STRGREATER STREQUAL STRLESS_EQUAL STRGREATER_EQUAL
    if(版本号1 VERSION_LESS 版本号2)  版本号形式如 3.14.2
        VERSION_LESS VERSION_GREATER VERSION_EQUAL VERSION_LESS_EQUAL VERSION_GREATER_EQUAL
```

操作系统

```cmake
if(CMAKE_HOST_SYSTEM_NAME MATCHES "Linux")
elseif(CMAKE_HOST_SYSTEM_NAME MATCHES "Windows")
else()
endif()

# 在 Linux 平台
CMAKE_HOST_SYSTEM_NAME = "Linux"
CMAKE_HOST_UNIX = 1
CMAKE_HOST_WIN32 = 空
UNIX = 1
WIN32 = 空
 
# 在 Windows 平台
CMAKE_HOST_SYSTEM_NAME = "Windows"
CMAKE_HOST_UNIX = 空
CMAKE_HOST_WIN32 = 1
UNIX = 空
WIN32 = 1
```

### 循环

```cmake
foreach(loop_var ${list_name})
    ...
endforeach()

foreach(loop_var RANGE start stop [step])
foreach(loop_var RANGE stop) start为0

while(<condition>)
    ...
endwhile()
```

### 列表

```cmake
## 列表是由;分隔的字符串
# 通过set定义列表
set(var a b c) 得到列表var, 值为"a;b;c"

# 获取列表长度
list(LENGTH list_name list_len) 将列表长度赋值给list_len

# 获取元素
list(GET index1 [index2..] ele) # 将元素赋值给ele, 索引可为负数，表示从后数

# 添加元素
list(APPEND CMAKE_PREFIX_PATH path/to/directory)

# 将列表连接成字符串
list(JOIN list_name <连接符> str_var)

# 截取列表(切片)
list(SUBLIST list_name start_index 元素个数 sub_list) # 元素个数为-1时表示到末尾，必须>=-1
```

### 设置debug/release

```cmake
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE
      "Release"
      CACHE STRING "Build type (Release/Debug/RelWithDebInfo/MinSizeRel)" FORCE)
endif()

if(CMAKE_BUILD_TYPE MATCHES "Debug")
  add_compile_options(-DDEBUG)
endif()
```

### 生成

```cmake
# 设置c++标准
set(CMAKE_CXX_STANDARD 11)

# 添加包搜索路径
list(APPEND CMAKE_PREFIX_PATH /path/to/directory)

# 禁止使用其他标准
set(CMAKE_CXX_EXTENSION OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 添加头文件路径
include_directories(..)
target_include_directories(<target> PRIVATE/PUBLIC ..)
# 添加源文件
aux_source_directory(path SRCS)    # 将path下所有源文件append到变量SRCS中，不会递归目录

# 添加编译选项
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ...")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ...")
# 添加链接选项
set(CMAKE_C_LINK_FLAGS "${CMAKE_C_LINK_FLAGS} ...")
set(CMAKE_CXX_LINK_FLAGS "${CMAKE_CXX_LINK_FLAGS} ...")

# 添加子项目
add_subdirectory(..)

# 设置输出路径
set(EXECUTABLE_OUTPUT_PATH path) 可执行文件
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY path) 静态库
set_target_properties(so_name PROPERTIES RUNTIME_OUTPUT_DIRECTORY path) 动态库

# 生成可执行文件
add_executable(exe_name main.cpp 1.cpp 2.cpp ${SRCS})
# 生成动态库
add_library(so_name SHARED 1.cpp 2.cpp ${SRCS})
# 生成静态库
add_library(so_name STATIC 1.cpp 2.cpp ${SRCS})

# 添加宏
target_compile_definitions(exe_name PRIVATE MACRO_NAME)
add_compile_definitions(MACRO_NAME)
# 添加编译选项
add_compile_options(-Wall)

# 设置依赖项目(编译该项目前会先编译依赖项目)
add_dependencies(exe_name need_lib_project1 need_lib_project2)
# 设置链接动态库路径，注意要在 add_executable 之前
link_directories(path)
# 链接动态库(库名为libtest1.so, libtest2.so)
target_link_libraries(exe_name test1 test2 ...)
# 链接静态库
target_link_libraries(exe_name /lib/dir/libtest.a ...)
# windows下链接
target_link_libraries(exe_name D:/test/libtest.dll.a)

# 设置运行时动态库路径(rpath)
set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE) 
set(CMAKE_INSTALL_RPATH "\${ORIGIN}/../lib")

# 设置生成路径
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ../lib)    # 静态库
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ../lib)    # 动态库
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ../bin)    # 可执行文件
# 或者只对目标设置路径
set_target_properties(${target} PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY "../lib"
    LIBRARY_OUTPUT_DIRECTORY "../lib"
    RUNTIME_OUTPUT_DIRECTORY "../bin"
)

# 设置安装路径
install(TARGETS so_name
        EXPORT so_name2
        LIBRARY DESTINATION lib # 可选，动态库安装路径
        ARCHIVE DESTINATION lib # 可选，静态库安装路径
        RUNTIME DESTINATION bin # 可选，可执行文件安装路径
        PUBLIC_HEADER DESTINATION include # 可选，头文件安装路径
)

# 设置 *.cmake 安装路径
configure_file(example.cmake.in ${CMAKE_INSTALL_PREFIX}/lib/example.cmake)
```

注意

```cmake
# 被链接的库要放在目标库后面，如 可执行程序 a 要链接 b 库，b 库要链接 c 库，则链接顺序为
target_link_libraries(a b c)
target_link_libraries(a b)
target_link_libraries(a b)
```

### cmake预定义变量

```cmake
CMAKE_SOURCE_DIR    : 工程根目录，即最顶层CMakeLists.txt所在路径
PROJECT_SOURCE_DIR  : 最近的使用了project命令的CMakeList.txt所在路径，如未使用同CMAKE_SOURCE_DIR
PROJECT_BINARY_DIR  : 运行cmake命令的目录
PROJECT_NAME        : project定义的项目名称
CMAKE_PREFIX_PATH   : 默认包搜索路径
CMAKE_CURRENT_SOURCE_DIR: 当前CMakeLists.txt所在路径
```

推荐变量

```cmake
CMAKE_INSTALL_PREFIX: 安装路径
```

### 使用Qt

```cmake
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
# 查找包
find_package(Qt5 REQUIRED COMPONENTS Core Widgets)
# 指定Qt5路径
set(Qt5_DIR E:/Applications/Qt/5.12.8/mingw73_32/lib/cmake/Qt5)
# 添加图片资源
qt5_add_resources(QRC_FILES ./resource.qrc)
    add_library(${PROJECT_NAME} SHARED ${QRC_FILES})
# 链接
target_link_libraries(${PROJECT_NAME} Qt5::Core Qt5::Widgets)
```

### 使用 boost

```cmake
set(Boost_DIR ${CMAKE_SOURCE_DIR}/third_party/boost_1_78_0/stage/lib/cmake/Boost-1.78.0)
find_package(Boost REQUIRED COMPONENTS Python)

include_directories(${Boost_INCLUDE_DIRS})
include_directories(${PYTHON_INCLUDE_DIRS})
```

### 执行系统/shell命令

<https://zhuanlan.zhihu.com/p/488312020>

示例

```cmake
# 复制文件
if(CMAKE_HOST_SYSTEM_NAME MATCHES "Windows")
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        WORKING_DIRECTORY "/root"
        COMMAND del "\"${CMAKE_SOURCE_DIR}\\build\\bin\\a.txt\""
        COMMAND copy "\"${CMAKE_CURRENT_SOURCE_DIR}\\a.txt\"" "\"${CMAKE_SOURCE_DIR}\\build\\bin\""
        COMMAND rd /s/q ".\\build"
    )
else()
    add_custom_command(TARGET ${PROJECT_NAME}
        POST_BUILD
        WORKING_DIRECTORY "/root"
        COMMAND rm "${CMAKE_SOURCE_DIR}/build/bin/a.txt"
        COMMAND cp "${CMAKE_CURRENT_SOURCE_DIR}/a.txt" "${CMAKE_SOURCE_DIR}/build/bin"
    )
endif()
```

## 命令

<https://cmake.org/cmake/help/v3.20/manual/cmake-commands.7.html>

### file

```cmake
# 不递归
file(GLOB <variable>
    [LIST_DIRECTORIES true|false] [RELATIVE <path>]
    [<globbing-expressions>...]
)
# 递归目录
file(GLOB_RECURSE <variable> [FOLLOW_SYMLINKS]
    [LIST_DIRECTORIES true|false] [RELATIVE <path>]
    [<globbing-expressions>...]
)
```

示例

```cmake
# file(GLOB_RECURSE SRCS ${CMAKE_CURRENT_SOURCE_DIR} *.cpp) 会向上递归
file(GLOB_RECURSE SRCS "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp")
```

### find_package

```cmake
# 如查找qt
find_package(Qt5 COMPONENTS Core Gui Widgets REQUIRED)
```

### message

```cmake
# 用法
message(STATUS "debug information")

# 日志等级
FATAL_ERROR: 会终止编译
WARNING
AUTHOR_WARNING
STATUS: 相当于DEBUG
VERBOSE
```

### option

### string

#### 检查子串

```cmake
set(my_string "Hello, World!")
set(my_sub_string "World")

string(FIND "${my_string}" "${my_sub_string}" found_index)

if(found_index GREATER -1)
    message("The string contains the substring at position ${found_index}")
else()
    message("The string does not contain the substring")
endif()
```

### 路径操作

```cmake
# 提取文件名（不带路径和扩展名）
get_filename_component(basename ${full_path} NAME_WE)
# 提取路径
get_filename_component(path ${full_path} DIRECTORY)
```

## 代码片段

### 为所有源文件创建可执行程序

```cmake
file(GLOB_RECURSE SRCS ${CMAKE_CURRENT_SOURCE_DIR} *.cpp)

foreach(source_file IN LISTS SRCS)
    get_filename_component(exec_name ${source_file} NAME_WE)
    add_executable(${exec_name} ${source_file})
    target_link_libraries(${exec_name} lib_name1 lib_name2)
endforeach()
```
