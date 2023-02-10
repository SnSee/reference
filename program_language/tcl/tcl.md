
# Tcl

[安装](../../%E7%8E%AF%E5%A2%83/linux.md#tcl)

[官网](https://core.tcl-lang.org/index.html)

[wiki](https://wiki.tcl-lang.org/welcome)

## 命令

[disassemble](https://wiki.tcl-lang.org/page/disassemble)

调试disassemble

```text
gdb 命令
    break Tcl_DisassembleObjCmd
tcl 命令
    tcl::unsupported::disassemble script script
```

```tcl
puts $text: 输出变量
lsearch ?option? list pattern: 查找列表是否包含指定pattern的元素，如果包含返回第一个匹配元素的索引，否则返回-1
```

[lsearch options](https://blog.csdn.net/asty9000/article/details/89693505)
