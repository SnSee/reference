
# skill

[知乎](https://zhuanlan.zhihu.com/p/270644625)

cadence skill函数接口

```text
ICADVM/SKILL/SKILL_Language/Cadence_User_Interface_SKILL_Reference
```

打印日志

```il
print("Hello World!")
```

注释

```il
; 单行注释
/* 多行注释 
 * 注释
 */
```

变量类型

```il
; 查看变量类型
type(1)

nil         ; 相当于 python None
```

数据结构

```il
; 列表
a = '()                 ; 空列表
a = '(1 2 3)            ; 不能引用变量
var = 4
b = list(var 5 6)       ; 可以引用变量
c = append(a b)         ; 合并列表，原列表不变
d = cons(b c)           ; 将b头插到c，原列表不变
e = append(c '(7))      ; 尾插元素，原列表不变

length(c)               ; 列表长度
car(c)                  ; 第一个元素
last(c)                 ; 最后一个元素
nth(n c)                ; 第 n 个元素
cdr(c)                  ; 相当于切片 [1:]
member(x c)             ; 如果列表中有x，从 x 位置切片，否则返回 nil
reverse(c)              ; 翻转，原列表不变
setof(x c 条件表达式)    ; 相当于python有条件表达式的列表推导
```

函数

```il
; skill 自动 return 函数最后一个值
procedure( fibonacci(n)
    if( (n == 1 || n == 2) then
        1
    else
        fibonacci(n-1) + fibonacci(n-2)
    )
)
```

[窗口操作](https://mp.weixin.qq.com/s/FpnKOkoc4nF5wCsDGvemjQ)

```il
; 每个窗口对应一个 id
win = window(1)     ; 获取编号为 1 的窗口对象, wtype 类型，如果编号不存在返回 nil
hiGetCurrentWindow() => w_windowId / nil    ; 获取当前窗口 id
hiGetWindowList() => l_windowId             ; 获取所有打开的窗口
```
