cmake_minimum_required(VERSION 3.14)
project(bptest)

set(Boost_DIR D:/work/aip/code/ViewParser/third_party/boost_1_78_0/stage/lib/cmake/Boost-1.78.0)
find_package(Boost REQUIRED COMPONENTS python)

find_package(PythonLibs REQUIRED)

# python 头文件
include_directories(C:/Users/yunchuanduo/AppData/Local/Programs/Python/Python310/include)
# boost 头文件
include_directories(${Boost_INCLUDE_DIRS})
include_directories(${PYTHON_INCLUDE_DIRS})

file(GLOB_RECURSE SRCS ${CMAKE_CURRENT_SOURCE_DIR} *.cpp)

set(Boost_USE_STATIC_LIBS ON)
add_library(${PROJECT_NAME} SHARED ${SRCS})
target_link_libraries(${PROJECT_NAME} PRIVATE Boost::python ${PYTHON_LIBRARIES})
target_compile_definitions(${PROJECT_NAME} PRIVATE BOOST_PYTHON_STATIC_LIB)

execute_process(COMMAND /usr/bin/bash build.sh)
