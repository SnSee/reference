
# wsl

## 安装

[官网文档](https://learn.microsoft.com/zh-cn/windows/wsl/install)

```bat
wsl --install
```

### 修改虚拟硬盘位置

虚拟硬盘默认在 C 盘，如： C:\Users\yinchuanduo\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu_79rhkp1fndgsc\LocalState\ext4.vhdx
按照下面的方式移动到其他硬盘

```sh
# 查看
wsl --list
# 导出，$name 是上一步列出的子系统名称
wsl --export $name "D:\\wsl.tar"
# 取消注册分发版并删除根文件系统
wsl --unregister $name
# 导入
wsl --import $name "D:\\wsl" "D:\\wsl.tar" --version 2
# 设置默认登录用户，默认为 root
$name config --default-user $user_name

# 如果重命名了删除 cmd 终端中旧的标签
设置 -> $name -> 删除配置文件(最下方) -> 保存
```

## WSL Settings

* 搜索 WSL Settings 后打开即可
* 点击 **欢迎使用 WSL** 查看进阶用法

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
