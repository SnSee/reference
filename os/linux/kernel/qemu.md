# QEMU

```sh
sudo apt install qemu-system-x86
```

```yml
-kernel     : 内核镜像
-initrd     : 临时文件系统
-append     : 内核启动项
```

## help

```sh
qemu-system-x86_64 -device help

qemu-system-x86_64 -device vfio-pci,help
```

## 安装 ubuntu

```sh
# ubuntu 22.04
wget https://mirrors.tuna.tsinghua.edu.cn/ubuntu-releases/22.04/ubuntu-22.04.5-desktop-amd64.iso
```

```sh
# 创建硬盘
qemu-img create -f qcow2 nvme_disk.img 20G
# 安装，安装完成后去掉 ubuntu.iso 一行即可启动
qemu-system-x86_64 \
  -enable-kvm \
  -m 4G \
  -cpu host \
  -smp 4 \
  -drive file=nvme_disk.img,format=qcow2,if=none,id=nvme0 \
  -drive file=ubuntu.iso,media=cdrom \
  -device nvme,drive=nvme0,serial=deadbeef \
  -virtfs local,path=/home/users/yinchuanduo/test/qemu/shared,mount_tag=host0,security_model=passthrough,id=host0 \
  -boot order=dc
```

## 扩充磁盘

```sh
# 主机
qemu-img create -f qcow2 nvme_disk.img 20G  # 创建硬盘
qemu-img resize nvme_disk.img 50G           # 扩充硬盘
qemu-img info nvme_disk.img                 # 查看

# 虚拟机
sudo growpart /dev/nvme0n1 3                # 扩充 nvme0n1p3
sudo resize2fs /dev/nvme0n1p3
df -h                                       # 查看扩充后大小
```

## 网络

默认虚拟机可以访问宿主机，但反过来不行

### hostfwd 端口转发

[ssh](../../../命令/linux.md#ssh)

```sh
# hostfwd=tcp::2222-:22：宿主机的 2222 端口 → 虚拟机的 22（SSH）
# hostfwd=tcp::8080-:80：宿主机的 8080 端口 → 虚拟机的 80（HTTP）
# 在宿主机上 ssh -p 2222 user@localhost 连接虚拟机
# 在宿主机上 curl http://localhost:8080 访问虚拟机 Web 服务
qemu-system-x86_64 \
    -nic user,model=virtio,hostfwd=tcp::2222-:22,hostfwd=tcp::8080-:80

ssh -p 2222 $user@localhost
```

### TAP 桥接

桥接后宿主机和虚拟机同局域网

```sh
sudo ip tuntap add tap0 mode tap
# 24 表示子网掩码为 255.255.255.0
sudo ip addr add 192.168.100.1/24 dev tap0
sudo ip link set tap0 up

qemu-system-x86_64 \
    -nic tap,model=virtio,ifname=tap0,script=no,downscript=no
```

## 文件传输

### scp

```sh
# 虚拟机内使用 scp
scp user@host_ip:/file/to/copy .
```

### 共享目录

```sh
# 虚拟机安装 9p 支持
sudo apt install 9mount
# 虚拟机设置挂载目录
sudo mount -t 9p -o trans=virtio,version=9p2000.L host0 $shared_dir

# qemu 启动虚拟机命令添加
-virtfs local,path=$shared_dir,mount_tag=host0,security_model=passthrough,id=host0
```

### 指定内核

指定内核需要使用 -kernel, -initrd, -append 参数

```sh
# -S 启动后会等待 gdb 连接
# -s 自动使用 1234 端口供 gdb 连接
# 注意: 使用设备时需要 root 权限
#       root= 按照安装好的 ubuntu 虚拟机内 /proc/cmdline 设置
sudo qemu-system-x86_64 \
    -kernel $kernel_dir/arch/x86_64/boot/bzImage \
    -initrd ./initramfs.img \
    -append "root=UUID=xxx ro quiet splash console=ttyS0"
```

#### 错误处理

如果有下面的报错，是因为默认使用 iso8859-1 西欧字符集，而编译内核时该字符集默认是 module(CONFIG_NLS_ISO8859_1=m) 形式，修改为 =y 后重新编译即可(会被编译进 bzImage)

```sh
FAT-fs (nvme0n1p2): IO charset iso8859-1 not found
    Mounting /boot/efi...
[FAILED] Failed to mount /boot/efi.
```
