
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
