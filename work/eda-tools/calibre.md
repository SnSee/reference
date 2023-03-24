
# calibre

LVS(ERC)

```bash
calibre -lvs -hier -spice lay.net -turbo 4 <rule_file>
```

DRC

```bash
calibre -drc -hier <rule_file>
```

[LVL](https://zhuanlan.zhihu.com/p/148105306)

```bash
dbdiff -refsystem GDS -system GDS -refdesign top_ref.gds top_cell -design top.gds chip_top -write_xor_rules xor.rul diff -resultformat ASCII
calibre -drc -hier -turbo -hyper -fx xor.rul | tee xor.log &
```

参数：
-turbo <number_of_processors>
-turbo_all
