
# Assembly Language

[gdb调试汇编](https://zhuanlan.zhihu.com/p/259625135)

* 指令中用括号表示解引用，如 (%rax) 表示取寄存器所存储的地址中的值

## 寄存器

R 表示 64 位寄存器，E 表示 32 位寄存器

|Name |Function |Desc
|- |- |-
|RBP |Base Pointer          |栈帧基地址，当前函数栈起始位置
|RSP |Stack Pointer         |当前栈顶(栈从高地址向低地址增长)
|RIP |Instruction Pointer   |下一条要执行的指令
|RSI |Source Index          |源地址
|RDI |Destination Index     |目标地址
|RAX |Accumulator Register  |通用寄存器，一般使用场景: 累加器，在算数运算中存放​​操作数​或​​结果，在​​函数调用中存放​​返回值​​
|RDX |Data Register         |通用寄存器，一般使用场景: 在乘法运算中存放高位结果，除法运算存放余数，系统调用存放第 3 个参数

## 指令

|Name |Demo |Desc
|- |- |-
|push   |push %rcx      |向栈顶(RSP指向地址)压入 RCX 中数据，RSP-=8(栈由高地址向低地址增长)
|pop    |pop %rcx       |​​从栈顶取出数据存入RCX，RSP+=8
