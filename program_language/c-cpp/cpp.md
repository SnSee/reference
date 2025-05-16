
# c-cpp

## 概念

### 预编译指令

* 布尔值表示真只能用 **true** (大小写敏感)，也可以用 int 表示

```c
#define MACRO                   // 定义宏
#define MACRO VALUE             // 定义宏
#undef MACRO                    // 取消宏

#ifdef MACRO                    // 只检查是否定义了宏，不管其值是什么
#else
#endif

#ifndef MACRO                   // 参考 ifdef
#endif

#if MACRO                       // 检查宏表达式是否为真，相当于普通代码的 if
#elif
#else
#endif
```

宏函数

* 使用 # 将宏函数参数转换为字符串
* 使用 ## 连接参数

```c
#define PRINT(var) printf("%s=%d", #var, var);  // 使用 # 打印变量名
int a = 1; PRINT(a);                            // output: a=1

#define CONCAT(a, b) a##b
int num1=10; printf("num1=%d", CONCAT(num, 1));
```

### 大小端法

大端法: 内存低位对数据高位(网络字节序)
小端法: 内存低位对数据低位(主机字节序)

以 int32 0xaabbccdd 为例，假设内存地址为 0x01 ~ 0x04

|内存地址 | 大端法 | 小端法 |
| --  | -- | -- |
|0x01 | aa | dd |
|0x02 | bb | cc |
|0x03 | cc | bb |
|0x04 | dd | aa |

linux查看大小端法

```c
#include <stdio.h>
#include <endian.h>

int main(int argc, char *argv[]) {
#if (__BYTE_ORDER == __LITTLE_ENDIAN)
    printf("little\n");
#endif
#if (__BYTE_ORDER == __BIG_ENDIAN) 
    printf("big\n");
#endif

    unsigned int a = 0xaabbccdd;
    unsigned char *p = (unsigned char *)&a;
    for (int i = 0; i < 4; ++i) {
        // 大端法结果为: aa bb cc dd
        // 小端法结果为: dd cc bb aa
        printf("%x\n", p[i]);
    }
    return 0;
}
```

大小端法转换

```c
#include <arpa/inet.h>
// h: host, n: net
// h -> n: 小转大；n -> h: 大转小
uint32_t htonl(uint32_t hostlong);
uint16_t htons(uint16_t hostshort);
uint32_t ntohl(uint32_t netlong);
uint16_t ntohs(uint16_t netshort);
```

## 预定义标识符

```c
// 获取当前函数名称
void func() { printf("Current function name: %s\n", __func__); }
```

## 函数

<a id="printf-format"></a>

### printf格式化输出

```text
%d  ：以十进制形式输出整数。
%f  ：以浮点数形式输出实数。
%x  : 十六进制
%c  ：输出字符。
%s  ：输出字符串。
%p  ：以指针的形式输出内存地址。
%%  ：输出百分号。
%nd ：将整数输出为至少n位宽的十进制数，不足部分用空格填充。
%0nd：将整数输出为至少n位宽的十进制数，不足部分用0填充。
%.nf：将浮点数输出为小数点后保留n位的形式。
%-ns: 左对齐输出（默认右对齐）
```

## 头文件

### climits

定义最小/最大值的宏

* SHRT_MIN
* SHRT_MAX
* USHRT_MAX
* INT_MIN
* INT_MAX
* UINT_MAX
* LONG_MIN
* LONG_MAX
* ULONG_MAX
* LLONG_MIN
* LLONG_MAX
* ULLONG_MAX

### cstdint

使用确定长度的整型数

|有符号 |最大值 |最小值 | 无符号 | 最大值 |
|- |- |- |- |- |
|int8_t  |INT8_MAX  |INT8_MIN  | uint8_t | UINT8_MAX  |
|int16_t |INT16_MAX |INT16_MIN | uint8_t | UINT16_MAX |
|int32_t |INT32_MAX |INT32_MIN | uint8_t | UINT32_MAX |
|int64_t |INT64_MAX |INT64_MIN | uint8_t | UINT64_MAX |

## STL

### initializer_list

初始化序列

```cpp
#include <iostream>
#include <vector>
#include <initializer_list>
using namespace std;

vector<int> make_vec(initializer_list<int> numbers) {
    return vector<int>(numbers);
}

int main(int, char **) {
    auto vec = make_vec({1, 2, 3, 4});
    for (int v : vec) {
        cout << v << endl;
    }
    return 0;
}
```

### vector

```cpp
// 初始化
vector<int> vec;                        // 空
vector<int> vec(3, 10);                 // 3 个 10
vector<int> vec(v.begin(), v.end());    // 从迭代器获取数据
vector<int> vec(vec2);                  // 复制另一个vector
vector<int> vec({1, 2, 3});             // 初始化序列

// 添加数据
vec.push_back(1);
vec.emplace_back(1);                    // 自动调用构造函数(如果有)
vec.insert(0, 1);
vec.insert(0, 10, 1);                   // 插入 10 个 1
vec.insert(vec.begin(), vec2.begin(), vec2.end());
vec.insert(vec.begin(), {1, 1, 1});
```

遍历

```cpp
vector<int> vec = {0, 1, 2, 3};
// 方式一
for (size_t i = 0; i < vec.size(); ++i) {
    vec[i];
}
// 方式二
for (auto it = vec.begin(); it != vec.end(); ++it) {
    *it;
}
// 方式三
for (int val: vec) {
    val;
}
```

### set

```cpp
set<int> numbers;

numbers.insert(1);              // 插入
numbers.emplace(1);             // 插入
numbers.erase(1);               // 删除
numbers.clear();                // 清空

numbers.empty();                // 是否为空
numbers.size();                 // 数量

numbers.count() != 0;           // 存在性
numbers.find(1);                // 查找迭代器
```

### map

遍历

```cpp
map<int, char> m = {{1, 'a'}, {2, 'b'}, {3, 'c'}};
// 方式一
for (auto it = m.begin(); it != m.end(); ++m) {
    it->first; it->second;
}
// 方式二
for (const auto &pair: m) {
    pair.first; pair.second;
}
// 方式三
for (const auto &[key, value]: m) {
    key; value;
}
```

### unordered_map

有默认值，int 类型默认值为 0

```cpp
unordered_map<int, int> m;
m[0] += 1;
```

### bitset

将字符串或 int 转换为二进制

* 索引 0 是最低位
* 位数在编译时即确定，不支持动态修改
* 支持位运算(& | ^ ~)

```cpp
#include <iostream>
#include <bitset>

using namespace std;

int main () {
  // 初始化
  bitset<8> val;                  // 创建空 bitset，默认全为 0
  cout << val << endl;            // 0000 0000
  val = bitset<8>(123);           // 使用整型初始化
  cout << val << endl;            // 0111 1011
  val = bitset<8>("01010101");    // 使用字符串初始化
  cout << val << endl;            // 0101 0101

  // 修改
  val = 0;
  val[0] = 1;                                       // 通过索引修改最低位
  cout << val << endl;                              // 0000 0001
  val.reset(0);                                     // 将指定位设为 0
  val.set(1);                                       // 将指定位设为 1
  val.flip(2);                                      // 翻转指定位
  cout << "modify:" << val << endl;                 // 0000 0110

  // 访问
  val = bitset<8>("01010101");
  cout << "bit[0]: " << val[0] << endl;             // 通过索引访问: 1
  cout << "bit[1] is 1: " << val.test(1) << endl;   // 检查指定位是否为 1: 0(false)
  cout << "bitset size: " << val.size() << endl;    // 获取总位数: 8
  cout << "1 count: " << val.count() << endl;       // bit 为 1 的位数量: 4

  // 转换
  val = 123;
  cout << val.to_string() << endl;                  // 转换为字符串: 0111 1011
  cout << val.to_ulong() << endl;                   // 转换无符号长整型: 123

  // 位运算
  val = bitset<8>("01010101");
  auto val2 = ~val;
  cout << "&: " << (val & val2) << endl;            // 0000 0000
  cout << "|: " << (val | val2) << endl;            // 1111 1111
  cout << "^: " << (val ^ val2) << endl;            // 1111 1111
  cout << "~: " << ~val << endl;                    // 1010 1010

  return 0;
}
```

## 库函数

### fstream

#### ifstream

一般流程

```cpp
#include <iostream>
#include <fstream>
#include <sstream>
#include <string>

using namespace std;
int main(int argc, char **argv) {
    ifstream ifs;
    ifs.exceptions(ifstream::failbit | ifstream::badbit);
    try {
        ifs.open("/home/ycd/test/opengl/src/test.txt");
        // stringstream ss;
        // ss << ifs.rdbuf();
        // cout << ss.str() << endl;
        string line;
        while (getline(ifs, line)) {
            cout << line << endl;
            cout << "===" << endl;
        }
        ifs.close();
    } catch(ifstream::failure e) {
        if (!ifs.eof()) {       // eof 会导致 failbit
            cout << "Failed to read file: " << e.what() << endl;
        }
    }
    return 0;
}
```

设置读取出问题时抛出异常

```cpp
std::ifstream file;
file.exceptions(std::ifstream::failbit | std::ifstream::badbit);
try {
  file.open("test.txt");
  while (!file.eof()) { file.get(); }
  file.close();
} catch(std::ifstream::failure e) {
}
```

#### ofstream

```cpp
#include <iostream>
#include <fstream>
#include <string>

int main() {
    std::ofstream outFile("example.txt");

    if (outFile.is_open()) {
        outFile << "Hello, World!" << std::endl;
        std::string message = "This is a test.";
        outFile << message << std::endl;

        outFile.close();
        std::cout << "File written successfully." << std::endl;
    } else {
        std::cerr << "Unable to open file." << std::endl;
    }

    return 0;
}
```

### algorithm

#### upper_bound/lower_bound

注意: 只能用于已经是 **升序** 的序列，否则结果不可信

```cpp
// 返回 [left, right) 中第一个 >= target 的迭代器
lower_bound(left, right, target);

// 返回 [left, right) 中第一个 > target 的迭代器
upper_bound(left, right, target);
```

## 内存布局

|segment |desc
|- |-
|BSS        |Block Started by Symbol, 通常存放未初始化的全局变量。属于静态内存分配
|data       |通常存放已初始化全局变量。属于静态内存分配。 
|code/text  |通常存放执行代码。这部分区域的大小在程序运行前就已经确定，并且通常只读, 可能包含一些只读的常数变量 ，例如字符串常量等。程序段为程序代码在内存中的映射.一个程序可以在内存中多有个副本
|heap       |堆, 存放进程动态分配的内存
|stack      |栈/堆栈，存放线程的局部变量，函数堆栈信息

## 汇编

```c
// 嵌入汇编语言, asm 或 asm volatile
asm(
    "assembly code"             // 汇编命令，%0, %1 等表示操作数
    : output operands           // 输出操作数
    : input  operands           // 输入操作数，只读，多个操作数用逗号隔开
    : clobbers                  // 破坏描述，表示哪些寄存器或内存会被修改，可选
);

asm volatile( /* volatile : 可选，禁止编译器对汇编代码进行优化 */
  "汇编指令"
  : "=限制符"(输出参数)
  : "限制符"(输入参数)
  : 保留列表
)
```

```yml
assemble:
input/output 约束:
    a: 寄存器 EAX/AX/AL
    i: 立即数(常量)
    g: 任意通用寄存器、内存或立即数
    m: 内存地址
    r: 通知汇编器可以使用任意一个通用寄存器来加载操作数
    +: 可读可写
    =: 只写，output 必须有 = 或 + 修饰
clobbers:
    memory: 表示会修改内存
```

### 汇编指令

#### 语法风格

在 x86 中:

* Intel 语法风格使用如 mov 等指令时不需要后缀，操作数大小通过寄存器或内存操作符显式指定
* AT&T 语法风格添加后缀表示操作数大小: b(8), w(16), l(32), q(64)

#### mov

```c
#include <stdio.h>
int main() {
    int i1 = 1, i2 = 2, o1 = 0, o2 = 0;

    // 将 input 值通过任意寄存器赋值给 output
    asm volatile("movl %0, %1" : "=r"(o1) : "r"(i1));    
    // 经 input 值通过任意寄存器赋值给一个内存地址
    asm volatile("movl %0, %1" : : "r"(i2), "m"(*(volatile int *)&o2) : "memory");    
    // 另一中写法
    asm volatile("movl %1, %0" : "=m"(*(volatile int *)&o2) : "r"(i2) : "memory");    

    printf("o1: %d, o2: %d\n", o1, o2);     // o1: 1, o2: 2
    return 0;
}
```

## tips

### 遍历枚举值

```cpp
enum class Type: uint8_t { ONE, TWO, THREE };
for (const auto &type : Type()) { }
```
