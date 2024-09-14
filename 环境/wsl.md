
# wsl

## 安装

[官网文档](https://learn.microsoft.com/zh-cn/windows/wsl/install)

```bat
wsl --install
```

## 图形界面

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

## 打开 wsl 文件夹

```text
在资源管理器中输入: \\wsl$
```
