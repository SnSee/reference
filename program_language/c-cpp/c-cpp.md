
# c-cpp

## 概念

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

## 函数

<a id="printf-format"></a>

### printf格式化输出

```text
%d  ：以十进制形式输出整数。
%f  ：以浮点数形式输出实数。
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

## 库函数

### algorithm

#### upper_bound/lower_bound

注意: 只能用于已经是 **升序** 的序列，否则结果不可信

```cpp
// 返回 [left, right) 中第一个 >= target 的迭代器
lower_bound(left, right, target);

// 返回 [left, right) 中第一个 > target 的迭代器
upper_bound(left, right, target);
```

