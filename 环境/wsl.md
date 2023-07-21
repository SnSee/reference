
# wsl

[使用图形页面](https://blog.csdn.net/weixin_44437771/article/details/128026215)

```bash
# Xming 选项
窗口选项：
    Multiple Windows: 子窗口不显示在xfce窗口内
    One Window: 子窗口显示在xfce窗口内
Display number 设为 0
Start No Client
No Access Control

# 设置display
export hostip=$(cat /etc/resolv.conf |grep -oP '(?<=nameserver\ ).*')
export DISPLAY=$hostip:0

# wsl 上启动
startxfce4
```

打开wsl文件夹

```text
在资源管理器中输入: \\wsl$
```
