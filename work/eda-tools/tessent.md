
# tessent

## 示例

### verilog 转换为 cell library

```bash
libcomp <verilog> -dof <dofile> -log tessent.log
```

dofile内容

```tcl
add models -all
set system mode translation
run
write library <cell_library> -rep
exit
```

### ATPG

```bash
tessent -shell -dofile <dofile> -log tessent.log
```

dofile内容

```tcl
try {
    set_context patterns -scan
    read_verilog <verilog1>
    read_verilog <verilog2>
    read_cell_library <atpg1>
    read_cell_library <atpg2>
    set_current_design <top_cell>
    set_system_mode analysis
    set_fault_type stuck
    add_faults -all
    create_patterns -auto
    write_patterns patterns -replace
    report_faults > faults
    report_statistics > <report>
} on error { code options } {
}
exit -f
```

帮助文档

```text
# 打开下面的链接, 在界面顶部搜索任意命令
# 查看任意命令: 界面拉到底部，点击Parent Topic: Command Descriptions查看所有命令
file:///eda-tools/mentor/tessent/doc/htmldocs/mgchelp.html#context=tshell_ref&topic=read_verilog
```

## 命令

set_context

> 指定当前Shell的上下文。

read_verilog

> 读取verilog。

read_cell_library

> 读取cell库。

set_current_design

> 指定顶层模块。

set_system_mode

> 指定操作状态。

set_fault_type

> 指定ATPG故障类型。

add_faults

> 将故障添加到当前故障列表中，丢弃当前测试模式集中的所有模式，并将故障设置为未检测到。

write_patterns

> 存储当前的pattern.

report_faults

> 展示当前fault list.

report_statistics

> 展示详细统计报告。

create_patterns

> 执行自动高速度测试生成和模式压缩操作。此命令是在最短时间内产生高质量、高效的测试模式集的推荐方式。这是一个 ATPG 的多进程命令。有关多进程的更多信息，请参考 Tessent Scan 和 ATPG 用户手册中的“使用多进程减少运行时间”部分。
>
> create_patterns 命令使用内置的专家系统 ATPG Expert 来创建测试模式。ATPG Expert 分析设计和 DRC，并可能修改工具设置，以优化测试模式的覆盖率、模式数量和运行时间。默认情况下，ATPG Expert 仅优化未明确指定的设置；它不会更改用户指定的设置。如果您希望 ATPG Expert 也优化用户指定的设置，请使用 -override_user_settings 开关。此外，会自动显示一个统计报告。create_patterns 命令显示以下统计信息：
>
> 1. 模拟的测试模式数量
> 2. 测试覆盖率
> 3. 检测到的故障数量
> 4. 故障列表中剩余的故障数量（未检测到的）
> 5. 有效模式数量
> 6. 测试模式数量
> 7. 冗余、无法测试和中止的故障数量