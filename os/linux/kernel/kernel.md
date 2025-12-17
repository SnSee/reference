
# Kernel

[build kernel](https://linux.cn/article-16252-1.html)
[build kernel](https://phoenixnap.com/kb/build-linux-kernel)

[Linux Device Drivers](https://lwn.net/Kernel/LDD3)

[Linux GPU Driver Developer’s Guide](https://dri.freedesktop.org/docs/drm/gpu/index.html)
[Linux GPU Driver Developer’s Guide](https://docs.kernel.org/5.10/gpu/index.html)
[Linux GPU Driver Developer’s Guide](https://www.kernel.org/doc/html/v5.4/gpu)

[Linux Device Driver Tutorial](https://embetronicx.com/tutorials/linux/device-drivers/linux-device-driver-part-1-introduction)
[The Linux Kernel Module Programming Guide](https://sysprog21.github.io/lkmpg)

[Documentation](https://www.kernel.org/doc)

[GPU Driver Developer's Guide](https://www.kernel.org/doc/html/latest/gpu/drm-uapi.html)

[深入理解 Linux 内存管理](https://blog.csdn.net/orangeboyye/article/details/125998574?spm=1001.2014.3001.5501)

## Abbr

|Abbr |Full
|- |-
|APU    |Accelerated Processing Units
|BO     |Buffer Object
|CGCG   |Coarse Grain Clock Gating
|CP     |Command Processor
|CPC    |Command Processor Compute
|CPF    |Command Processor Frontend
|CPG    |Command Processor Graphics
|CS     |Command Submission
|CSB    |Clear State Block
|CSIB   |Clear State Indirect Buffer
|CU     |Compute Unit
|DMA    |Direct Memory Access
|DRM    |Direct Rendering Manager
|EOF    |End of Pipe
|FGCG   |Fine Grain Clock Gating
|GART   |Graphics Address Remapping Table，alias GTT
|GC     |Graphics Core
|GC     |Graphics and Compute
|GEM    |Graphics Execution Manager
|GMC    |Graphics Memory Controller
|GRBM   |Graphics Register Base Map
|GRBM   |Graphics Register Bus Manager
|GTT    |Graphics Translation Table, alias GART
|HAL    |Hardware Abstraction Layer
|HQD    |Hardware Queue Descriptor
|HSA    |Heterogeneous System Architecture
|IB     |Indirect Buffer
|IFPO   |Inter-Frame Power-Off
|IH     |Interrupt Handler
|IP     |Intellectual Property
|IRQ    |Interrupt Request
|KCQ    |Kernel Compute Queue
|KGQ    |Kernel Graphics Queue
|KIQ    |Kernel Interface Queue
|KMD    |Kernel Mode Driver
|KMS    |Kernel Mode Setting
|LRU    |Least Recently Used
|MES    |MicroEngine Scheduler
|MGCG   |Medium Grain Clock Gating
|MQD    |Map Queues Descriptor
|MQD    |Memory Queue Descriptor
|PBA    |Page Base Address
|PM4    |Programmable Multiplexer 4
|PSP    |Platform Security Processor
|RB     |Ring Buffer
|RB     |Render Backend
|RLC    |Real-Time Low-Power Controller
|RLC    |RunList Controller
|SA     |Sub Alloc
|SDMA   |System DMA
|SMU    |System management Unit
|SRIOV  |Single Root I/O Virtualization
|SRM    |Save Restore Machine
|TMR    |Trusted Memory Region
|TTM    |(Memory) Translation Table Manager
|TTM    |(Memory) Translation Table Maps
|UVD    |Unified Video Decoder
|WGP    |Workgroup Processor

### Engine

|Abbr   |Full
|- |-
|CE     |Constant Engine
|DE     |Drawing Engine
|EE     |
|ME     |Micro Engine
|MEC    |MicroEngine Compute
|PFP    |Pre-Fetch Parser
|SE     |Shader Engine

## Concepts

[GMC,IH,PSP,SMU,DCN,SDMA,GC,VCN,CP,MEC,MES,RLC,KIQ,IB](https://docs.kernel.org/gpu/amdgpu/driver-core.html)

### MES

manual: **Exploring-AMD-GPU-Scheduling**

The Micro-Engine Scheduler (MES) is a hardware engine used by AMD Graphics IP, GFX, for GPU workload scheduling. The MES FW interacts with the kernel driver via a ring buffer to schedule user queues to the hardware queues of each engine.

### task_struct

Linux 内核通过一个被称为进程描述符的 task_struct 结构体来管理进程，这个结构体包含了一个进程所需的所有信息

### efuse

[efuse](https://zhuanlan.zhihu.com/p/653516447)

electronic fuse 是一种可编程电子保险丝，通过熔断形成永久开路进行编程，因此是一次性的。
可用于存储序列号，安全密钥，特定硬件参数等。
在 amdgpu 中 efuse 可能存储了 SA,CU 等 disable bitmap 以禁用有缺陷硬件单元

### DMA address

[dma-api](https://docs.kernel.org/core-api/dma-api-howto.html)

### DMA mapping

[DMA](https://zhuanlan.zhihu.com/p/618143764)

DMA（Direct Memory Access，直接内存访问）映射主要用于让设备能够直接访问系统内存。分为一致性映射（consistent mapping）和流式映射（streaming mapping）

1. 应用场景

* Consistent Mapping 适用于那些需要频繁、随机访问内存的场景
* Streaming Mapping 适用于数据以流的形式进行传输的场景，设备通常按照顺序对内存进行读写操作，数据传输具有方向性，要么是从内存到设备（写操作），要么是从设备到内存（读操作）

2. 缓存处理

* Consistent Mapping 保证了 CPU 缓存和设备看到的内存内容始终是一致的。为了实现这一点，内核会将映射的内存区域标记为非缓存（uncached）或写合并（write-combining）。
* Streaming Mapping 不保证 CPU 缓存和设备之间的一致性。在进行流式映射时，内核需要在数据传输前后进行额外的操作来确保数据的一致性。
例如，在数据从内存传输到设备之前，需要将 CPU 缓存中的数据刷新到内存中；在数据从设备传输到内存之后，需要使 CPU 缓存中对应的部分失效，以保证 CPU 下次访问时能获取到最新的数据。

3. 生命周期

* Consistent Mapping 通常是长期有效的，在 driver 初始化时 map，退出时 unmap
* Streaming Mapping 是短期的，通常是在每次数据传输之前 map，传输完成后 unmap

4. API

* Consistent Mapping 使用 dma_alloc_coherent/dma_free_coherent 分配/释放 内存
* Streaming Mapping 使用 dma_map_single/dma_unmap_single 或 dma_map_page/dma_unmap_page 映射/解除映射

### DMA scatterlist

scatter list 是 Linux 内核中用于描述一组非连续内存块的数据结构。在 DMA 操作里，有时候需要传输的数据可能分散存于内存的不同位置，无法用一个连续的内存区域来表示。scatterlist 就可以把这些分散的内存块组织起来，让 DMA 设备能够将它们当作一个整体进行访问。

### Memory Mapping Register(mm)

Memory Mapping Register（MMR） 是指将硬件设备的寄存器映射到系统的内存地址空间，使CPU可以通过内存访问指令（如load/store）直接与硬件设备通信，而不需要专用的I/O指令。

### pci power management

PCI/PCIe 设备的电源状态由 PCI Power Management (PCI-PM) 和 PCI Express Power Management (PCIe-PM) 规范定义：

* ​D0（Active）​：设备完全供电，正常运行。
* ​D1/D2（Low Power）​：中间低功耗状态，保留部分功能（如寄存器状态），可通过软件快速唤醒。
* ​D1：比 D0 省电，但唤醒延迟较短（微秒级）。
* ​D2：比 D1 更省电，但唤醒延迟稍长（毫秒级）。
* ​D3hot（Hot Standby）​：深度低功耗状态，主电源（Vcc）仍供电，设备保留基础状态，但需要重新初始化才能恢复。
* ​D3cold（Off）​：最深省电状态，主电源（Vcc）可能被切断，设备完全断电，需硬件复位或冷启动。

```sh
# 查看电源状态
sudo lspci -vv -s 03:00.0 | grep Status

# 第 0,1 bit 表示电源状态
# 0: D0
# 1: D1
# 2: D2
# 3: D3hot
# D3cold 时查看不到 pci 设备?
sudo setpci -s 03:00.0 CAP_PM+4.w
```

PCI 设备的配置空间中包含 ​PCI Power Management Capability (PMC) 结构。

```c
// drivers/pci/pci.c
/**
 * pci_find_capability - query for devices' capabilities
 * @dev: PCI device to query
 * @cap: capability code
 *
 * Tell if a device supports a given PCI capability.
 * Returns the address of the requested capability structure within the
 * device's PCI configuration space or 0 in case the device does not
 * support it.  Possible values for @cap include:
 *
 *  %PCI_CAP_ID_PM           Power Management
 *  %PCI_CAP_ID_AGP          Accelerated Graphics Port
 *  %PCI_CAP_ID_VPD          Vital Product Data
 *  %PCI_CAP_ID_SLOTID       Slot Identification
 *  %PCI_CAP_ID_MSI          Message Signalled Interrupts
 *  %PCI_CAP_ID_CHSWP        CompactPCI HotSwap
 *  %PCI_CAP_ID_PCIX         PCI-X
 *  %PCI_CAP_ID_EXP          PCI Express
 */
u8 pci_find_capability(struct pci_dev *dev, int cap);
```

#### pci bridge

```sh
# lspci 桥接器输出
Bus: primary=01, secondary=02, subordinate=03, sec-latency=0
# 描述了 ​PCI 桥接器（PCI Bridge）的总线拓扑关系。

primary=01      : 桥接器所在的 ​主总线号​（连接上游的总线，通常是 CPU 或上级桥接器）。
secondary=02    : 桥接器下游的 ​起始总线号​（分配给下游设备的第一个总线）。
subordinate=03  : 桥接器下游的 ​最大总线号​（下游总线的结束范围）。
​sec-latency=0   : 次总线的 ​延迟时间​（单位是 PCI 时钟周期，通常无需调整）。
```

### ACPI

ACPI（Advanced Configuration and Power Interface）​ 是一种计算机行业标准，用于管理硬件设备的电源状态、温度监控、性能调节以及操作系统与硬件之间的通信。

​ACPI 的核心作用

1. ​电源管理

* 控制设备休眠/唤醒（如睡眠模式、休眠模式）。
* 调整 CPU/GPU 的功耗状态（例如从高性能切换到省电模式）。
* 管理电池（笔记本电脑）和外围设备（如 USB、PCIe 设备）的供电。

2. ​硬件资源分配

* 告诉操作系统硬件设备的地址、中断请求（IRQ）等资源信息。
* 协调硬件冲突（例如多个设备共享同一资源时）。

3. ​热管理

* 监控硬件温度，触发风扇调速或过热保护机制。

4. ​设备状态控制

* 控制设备的启用/禁用（如禁用独立显卡以省电）。
* 管理设备的电源状态（如 D0 工作状态、D3cold 深度休眠状态）。

### 内存屏障

[什么是内存屏障](https://www.cnblogs.com/Chary/p/18112934)
[mfence, lfence, sfence](https://blog.csdn.net/liuhhaiffeng/article/details/106493224)

内存屏障（Memory Barriers）用来保证在此指令之后的内存访问肯定在指令之前的内存访问之后（如果不设置，内存访问可能被重排序）
x86_64 架构中提供了 3 个屏障指令

```c
#define mb()    asm volatile("mfence":::"memory")       // 读写 fence
#define rmb()   asm volatile("lfence":::"memory")       // 读 fence
#define wmb()   asm volatile("sfence" ::: "memory")     // 写 fence
```

## firmware(固件)

[缺少固件](https://www.cnblogs.com/long5683/p/13830021.html)
[amdgpu-firmware](https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/amdgpu)

```sh
# 使用 git clone 后搜索
git clone https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
```

## GRUB

[kernel 启动项](https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html)

[屏蔽内核模块](https://zhuanlan.zhihu.com/p/653064228)

安装多个系统内核时进入内核选择界面

```sh
# 方式一
# 开机时按住 shift 或 esc

# 方式二
# GRUB_TIMEOUT_STYLE 设置为 menu
# GRUB_TIMEOUT 时间设置长一点
# 按 enter 进入 Advanced options for Ubuntu
sudo vim /etc/default/grub
```

设置默认启动内核

```sh
# 在 /boot/grub/grub.cfg 中搜索 menuentry，序号从 0 开始
# 如果 menuentry 在 submenu 中，则序号为 SUBMENU_INDEX>MENUENTRY_INDEX

menuentry 'Kernel1'
submenu
    menuentry 'Kernel1'
    menuentry 'Kernel1 (recover mode)'
    menuentry 'Kernel2'
    menuentry 'Kernel2 (recover mode)'

# 上面的顺序，如果要以 Kernel2 作为默认 Kernel
# 则 /etc/default/grub 中设置为
GRUB_DEFAULT="1>2"

# 然后更新
sudo update-grub
```

```sh
grep menuentry /boot/grub/grub.cfg          # 查看内核版本，索引从 0 开始
# 将 GRUB_DEFAULT 设置为对应内核索引，设置为 saved 时表示使用 grub-set-default 设置的值
sudo vim /etc/default/grub

# 如何 GRUB_DEFAULT 是 grub-set-default 则
grub-editenv list                           # 查看 saved_entry
sudo grub-set-default ''                    # 设置默认内核版本

sudo update-grub                            # 更新 /boot/grub/grub.cfg
sudo reboot                                 # 重启
```

## 编译内核

[build kernel](https://phoenixnap.com/kb/build-linux-kernel)

### GRUB: out of memory

```sh
# 查看引导文件大小，如果超过 100M 很可能会内存不足
ll -h /initrd.img

# 方式一: 去掉编译信息以减小内存占用
make INSTALL_MOD_STRIP=1 modules_install

# 方式二: 在 /etc/default/grub 中设置低分辨率
GRUB_GFXMODE=640x480

# 方式三: 修改 /etc/initramfs-tools/initramfs.conf，MODULES=most 改为 dep
```

### basic flow

```sh
cp -v /boot/config-$(uname -r) .config
# 按空格切换是否开启，[*] 表示开启
# 也可使用 ./scripts/config 命令设置
make menuconfig
scripts/config --disable SYSTEM_TRUSTED_KEYS
scripts/config --disable SYSTEM_REVOCATION_KEYS
make -j8
make htmldocs       # 编译 doc
sudo make modules_install -j8
# 查看 /boot 下的 initrd.img 文件，超过 500M 则会 out of memory
# 解决方式一: 修改 /etc/initramfs-tools/initramfs.conf，MODULES=most 改为 dep
# 解决方式二: 使用 INSTALL_MOD_STRIP 去除调试信息
#sudo make INSTALL_MOD_STRIP=1 modules_install -j8
sudo make install
sudo update-initramfs -c -k 6.12.5
sudo update-grub
sudo reboot
```

### 编译单独模块并重启

以 amdgpu.ko 为例

编译新驱动，卸载旧驱动

```sh
# 只编译指定模块，如 amdgpu.ko
make M=drivers/gpu/drm/amd/amdgpu -j5
# 指定宏定义
# make EXTRA_CFLAGS="-DDEBUG -DVERSION=123"
if [[ $? != 0 ]]; then
    echo "Build ERROR"
    exit -1
fi
# 关闭使用 amdgpu 驱动的进程
sudo systemctl stop display-manager
sudo systemctl stop gdm
sudo killall Xorg
# 确保服务停止后再卸载
sleep 2
# 使用数需要为 0，如果不为 0 通过 lsof 查看使用驱动文件的进程并 kill
lsmod | grep amdgpu
# 移除驱动
sudo rmmod amdgpu
```

安装新驱动

```sh
# 如果只时临时使用新驱动
sudo insmod /lib/modules/6.12.5/kernel/drivers/gpu/drm/amd/amdgpu/amdgpu.ko
# 如果需要彻底更换驱动
sudo mv /lib/modules/6.12.5/kernel/drivers/gpu/drm/amd/amdgpu/amdgpu.ko /lib/modules/6.12.5/kernel/drivers/gpu/drm/amd/amdgpu/amdgpu.ko.bk
sudo cp ./drivers/gpu/drm/amd/amdgpu/amdgpu.ko /lib/modules/6.12.5/kernel/drivers/gpu/drm/amd/amdgpu/amdgpu.ko
sudo modprobe amdgpu
```

恢复服务

```sh
sudo systemctl start display-manager
sudo systemctl start gdm
# 重新进入桌面时会自动创建 Xorg 进程
# startx
```

### 创建 module

```sh
# 创建下面的源文件和 Makefile 后直接编译即可
make
sudo insmod ./hello.ko
```

模块源文件

```c
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>

static int __init hello_init(void) {
    printk(KERN_INFO "Hello, World!\n");
    return 0;
}

static void __exit hello_exit(void) {
    printk(KERN_INFO "Goodbye, World!\n");
}

module_init(hello_init);
module_exit(hello_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("TEST");
MODULE_DESCRIPTION("A simple example Linux module");
```

Makefile

```makefile
obj-m := hello.o
KDIR := /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)

all:
    make -C $(KDIR) M=$(PWD) modules

clean:
    make -C $(KDIR) M=$(PWD) clean
```

### 添加编译选项

```sh
make EXTRA_CFLAGS="-DDEBUG -O2"
```

```makefile
ccflags-y := -DDEBUG -O2
ccflags-y += -g
```

## coding

### container_of

container_of 宏基于成员指针来获取其所属结构体的指针

```c
// 原理如下，完整宏在 kernel.h 或 stddef.h 中定义
// ptr:    成员指针
// type:   成员所属结构体类型
// member: 成员在结构体中的名称
#define container_of(ptr, type, member) ({              \
    ((type *)((void*)(ptr) - offsetof(type, member)));  \
})
```

## 特性

### (NO)KASLR

[参考](https://blog.csdn.net/essencelite/article/details/137723705)

* Address Space Layout Randomization，是一个内核安全功能
* 开启 KASLR 后内核符号(函数，变量等)在 System.map 中地址和实际地址不一样

```sh
# 查看内核启动时选项
cat /proc/cmdline
# 查看符号表地址
cat /boot/System.map-$(uname -r) | grep kmalloc_info
# 查看实际函数地址
sudo cat /proc/kallsyms | grep kmalloc_info
```

关闭 KASLR

```sh
# 编译时关闭
make menuconfig     # 关闭 CONFIG_RANDOMIZE_BASE
# 启动时关闭，/etc/default/grub
GRUB_CMDLINE_LINUX="... nokaslr"
update-grub
```

## 查看内核模块

```sh
# 第三列显示被多少设备或进程使用
lsmod | grep amdgpu
```

```sh
# 查看使用内核模块的进程
fuser -mv /sys/module/$module_name
```

```sh
# 查看使用显卡设备文件的进程
lsof /dev/dri/renderD128        
lsof /dev/dri/renderD129
lsof /dev/dri/card0
lsof /dev/dri/card1
```

## dkms

```sh
dkms status                 # 查看已安装的 dkms module
# 内容格式如下:
# 模块名称及版本                内核版本
# amdgpu/6.8.5-2044426.22.04, 6.8.0-51-generic, x86_64: installed

# 卸载指定内核的 dkms module
sudo dkms remove amdgpu/6.8.5-2044426.22.04 -k 6.8.0
```

## SysRq

```sh
# /proc/sys/kernel/sysrq
sysctl -n kernel.sysrq          # 查看允许使用的按键类型
# 1 表示所有请求都支持
sudo sysctl -w kernel.sysrq=1   # 设置允许使用的按键类型
# OR
sudo sh -c 'echo 1 > /proc/sys/kernel/sysrq'
```

## 测试内核

[测试方式](https://blog.csdn.net/weixin_50829653/article/details/109537407)

### debugfs

```sh
# 进入界面后输入 / 搜索 DEBUG_FS 查看 Location 及是否开启
make menuconfig

# 查看当前内核是否开启 DEBUG_FS
vim /boot/config-$(uname -r)
```

```sh
# amdgpu 调试信息路径
sudo ls /sys/kernel/debug/dri/129
```

### KUint

[KUint-Linux Kernel Unit Testing](https://www.kernel.org/doc/html/latest/dev-tools/kunit/index.html)

```sh
# 只测试 drm
./tools/testing/kunit/kunit.py run --kunitconfig=drivers/gpu/drm/tests
```

```yml
--raw_output: 显示更多细节
```

## debugging

### QA

#### gdb 无法单步执行

```sh
# dmesg 报错: BP remove failed
# 关闭这个配置即可
./scripts/config -d CONFIG_STRICT_KERNEL_RWX
```

### log

#### printk

[dmesg日志等级](#dmesg)

* 使用 printk 在代码中打印日志，使用 dmesg 查看日志
* 有的模块会把 printk 做到宏里，使用相应的宏即可
* 直接使用 printk 时最后一次 printk 可能不会打印，加上 \n 换行刷新即可

```c
// 控制输出频率
// 查看输出频率: cat /proc/sys/kernel/printk_ratelimit
if (printk_ratelimit()) {
    printk(KERN_NOTICE "The printer is still on fire\n");
}
```

#### dump_stack

```c
// 打印函数堆栈
dump_stack();
```

### gdb

```sh
scripts/config --disable CONFIG_RANDOMIZE_BASE  # 关闭 KASLR

cat /proc/modules | grep amdgpu                 # 查看 module 基地址，即 .text
# 如果 module 基地址是 0，执行下面的命令
# sudo sh -c 'echo 0 > /proc/sys/kernel/kptr_restrict'
sudo cat /sys/module/amdgpu/sections/.text      # 查看 section 地址

sudo gdb vmlinux /proc/kcore
(gdb) p jiffies                                 # 查看系统运行时间
(gdb) core-file /proc/kcore                     # 刷新 core
(gdb) add-symbol-file amdgpu.ko <.text_addr> \  # 加载 module debugging sections
    -s .bss  0xFFFFFFFF \
    -s .data 0xFFFFFFFF
(gdb) p amdgpu_discovery                        # 查看 amdgpu 中的全局变量或函数
# 校验实际函数地址确认是否一致
sudo cat /proc/kallsyms | grep amdgpu_discovery
```

[自动获取 amdgpu 基地址并设置符号表查看 gdb 连接](#qemu--gdb)

### kdb / kgdb

[参考](https://zhuanlan.zhihu.com/p/546416941)
[参考](https://www.kernel.org/doc/html/latest/process/debugging/kgdb.html)
[参考](https://www.kernel.org/pub/linux/kernel/people/jwessel/kdb/EnableKGDB.html)

```sh
# 配置 .config
./scripts/config -d CONFIG_STRICT_KERNEL_RWX -d CONFIG_STRICT_MODULE_RWX -e CONFIG_FRAME_POINTER -e CONFIG_KGDB -e CONFIG_KGDB_SERIAL_CONSOLE -e CONFIG_KGDB_KDB -e CONFIG_KDB_KEYBOARD -e CONFIG_MAGIC_SYSRQ -e CONFIG_MAGIC_SYSRQ_SERIAL
```

进入 kdb (目前仅在 QEMU 中成功)

1. 使用 Serial Port 进入 kdb

```sh
# Configure kgdboc at boot using kernel parameters
console=ttyS0,115200 kgdboc=ttyS0,115200 nokaslr
# OR
# Configure kgdboc after the kernel has booted
sudo sh -c 'echo ttyS0 > /sys/module/kgdboc/parameters/kgdboc'

# 中断 kernel 进入 kdb
sudo sh -c 'echo 1 > /proc/sys/kernel/sysrq'
sudo sh -c 'echo g > /proc/sysrq-trigger'
```

2. 使用 keyboard connected console 进入 kdb

```sh
kgdboc=kbd
# OR
sudo echo kbd > /sys/module/kgdboc/parameters/kgdboc
```

### VFIO

[VFIO](https://docs.kernel.org/driver-api/vfio.html)

```sh
# /etc/default/grub 中关闭 pcie 的电源管理功能，防止自动进入 D3cold
GRUB_CMDLINE_LINUX_DEFAULT="pcie_port_pm=off"

# 查看 iommu group
readlink /sys/bus/pci/devices/0000:03:00.0/iommu_group

# 加载 vfio
sudo modprobe vfio-pci
lsmod | grep vfio_pci

# 查看 vendor & device id，即 1003:743f
lspci -n -s 03:00.0         # 03:00.0 0300: 1002:743f (rev c7)
# 将设备从当前系统解绑，显卡和声卡都解绑
# lspci -v -s 03:00.0 可以看到 Kernel driver in use 已经没了
sudo sh -c 'echo 0000:03:00.0 > /sys/bus/pci/devices/0000:03:00.0/driver/unbind'
sudo sh -c 'echo 0000:03:00.1 > /sys/bus/pci/devices/0000:03:00.1/driver/unbind'
# 绑定到 vfio
# sudo sh -c 'echo 1002 743f > /sys/bus/pci/drivers/vfio-pci/new_id'
# sudo sh -c 'echo 1002 ab28 > /sys/bus/pci/drivers/vfio-pci/new_id'
sudo sh -c 'echo vfio-pci > /sys/bus/pci/devices/0000:03:00.0/driver_override'
sudo sh -c 'echo vfio-pci > /sys/bus/pci/devices/0000:03:00.1/driver_override'
# Kernel driver in use 应该是 vfio_pci
lspci -v -s 03:00.0

# 查看 group 下是否有其他设备，如果有也需要执行上述操作
ls /sys/bus/pci/devices/0000:03:00.0/iommu_group/devices

# 修改 vfio 设备所有权
sudo chown $USER /dev/vfio/18
sudo chown $USER /dev/vfio/19
```

恢复到原驱动

```sh
# 从 vfio 解绑并绑定到原驱动，lspci -v 显示的 Kernel modules 就是原驱动
# 也可以通过这种方式绑定 vfio-pci
# 确保设备未被虚拟机使用（如关闭相关VM）
sudo sh -c 'echo 0000:03:00.0  > /sys/bus/pci/devices/0000:03:00.0/driver/unbind'
sudo sh -c 'echo 0000:03:00.1  > /sys/bus/pci/devices/0000:03:00.1/driver/unbind'
sudo sh -c 'echo amdgpu        > /sys/bus/pci/devices/0000:03:00.0/driver_override'
sudo sh -c 'echo snd_hda_intel > /sys/bus/pci/devices/0000:03:00.1/driver_override'
sudo sh -c 'echo 0000:03:00.0  > /sys/bus/pci/drivers_probe'
sudo sh -c 'echo 0000:03:00.1  > /sys/bus/pci/drivers_probe'
```

```sh
# 查看所有 iommu groups
for d in /sys/kernel/iommu_groups/*/devices/*; do
  n=${d#*/iommu_groups/*}; n=${n%%/*}
  printf 'IOMMU Group %s ' "$n"
  lspci -nns "${d##*/}"
done
```

### QEMU + gdb

[参考](https://www.kernel.org/doc/html/latest/process/debugging/gdb-kernel-debugging.html)
[参考](https://zhuanlan.zhihu.com/p/412604505)

[QEMU](./qemu.md)

```sh
# 编译内核时禁用优化
./scripts/config -d CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE
# 或者直接修改根目录 Makefile 中 KBUILD_CFLAGS
```

安装环境

[其他 config 设置最好也加上](#kdb--kgdb)

```sh
# build kernel，-e 开启设置，-d 关闭设置
./scripts/config -e CONFIG_DEBUG_INFO -e CONFIG_GDB_SCRIPTS -e CONFIG_DEBUG_SECTION_MISMATCH -d CONFIG_RANDOMIZE_BASE
# install qemu
apt install qemu-system-x86_64
# create initramfs
mkinitramfs -v -o ./initramfs.img $(uname -r)
# 将下面的命令添加到 ~/.gdbinit 中
add-auto-load-safe-path $kernel_build_path
```

[安装/启动虚拟机](./qemu.md#安装-ubuntu)

[使用 GPU 时需要先隔离设备](#vfio)

注意:

* 使用设备时需要 root 权限
* root= 按照安装好的 ubuntu 虚拟机内 /proc/cmdline 设置
* 调试 GPU 时不能使用 -enable-kvm
* 虚拟机内 GPU 的 pci:device.function 可能会变
* 修改内核或 module 后需要重新生成 initramfs

```sh
# -S 启动后会等待 gdb 连接
# -s 自动使用 1234 端口供 gdb 连接
sudo qemu-system-x86_64 \
    -S -s \
    -nographic -m 4G -smp 4 \
    -drive file=nvme_disk.img,format=qcow2,if=none,id=nvme0 \   # 固态硬盘
    -device nvme,drive=nvme0,serial=deadbeef \                  # 驱动
    -kernel $kernel_dir/arch/x86_64/boot/bzImage \
    -initrd ./initramfs.img \
    -append "root=UUID=xxx ro quiet splash console=ttyS0"
    -device vfio-pci,host=03:00.0,multifunction=on \                    # 显卡
    -device vfio-pci,host=03:00.1                               # 声卡
```

gdb 连接

```sh
gdb vmlinux
(gdb) target remote :1234
(gdb) b start_kernel
(gdb) continue

# 使用前面 gdb 章节的方式加载 amdgpu.ko 符号表
# 注意: 模块加载时的基地址可能会发生变化，如果未触发断点，
# 需要查看实际函数地址和断点地址，校验是否一致

# gdb 自动获取 amdgpu 基地址，并为 amdgpu 的函数设置断点
# 设置完成后在虚拟机内使用 modprobe amdgpu 加载驱动以触发断点
(gdb) tb apply_relocate_add if $_streq(me->name, "amdgpu")
(gdb) commands
(gdb)     set $amdgpu_base_addr=sechdrs[sechdrs[relsec].sh_info].sh_addr
(gdb)     add-symbol-file ./amdgpu.ko $amdgpu_base_addr
(gdb)     # 后续直接用 amdgpu 函数名打断点即可
(gdb)     # 如果软件断点无法使用 next，使用硬件断点 hbreak
(gdb)     b amdgpu_pci_probe
(gdb)     continue
(gdb) end
```

```sh
# 比较重要的函数
(gdb) b load_module             # kernel/module/main.c，加载 module
```

```sh
# 内核提供了一些 gdb 命令
make scripts_gdb                # 生成 scripts/gdb/vmlinux-gdb.py
gdb vmlinux                     # 会自动加载脚本

(gdb) apropos lx                # 查看有哪些命令及函数
(gdb) lx-symbols                # 查看 module.ko 及地址
(gdb) lx-dmesg                  # 查看 dmesg
```

如果没有设置硬盘，即没有安装 ubuntu，直接从内核启动时会进入 initramfs 的最小系统，没有用户空间，能使用的命令也很少

```sh
(initramfs) modprobe amdgpu
# 不借助 lspci 查看设备驱动
# 注意: 虚拟机内 pci 地址可能会变，如变为 00:04.0
(initramfs) ls /sys/bus/pci/devices/0000:00:04.0/driver/module/drivers
```

退出虚拟机

```sh
(initramfs) poweroff
bash: sudo shutdown -h now
```

### 查看 module 地址

```sh
sudo cat /sys/module/amdgpu/sections/.text
sudo cat /sys/module/amdgpu/sections/.data
sudo cat /sys/module/amdgpu/sections/.bss
```

### Serial Port + gdb

如果主机没有自带串口，可以使用 usb 转串口

gdb 连接

```sh
gdb vmlinux
(gdb) set serial baud 115200
(gdb) target remote /dev/ttyUSB0
(gdb) b start_kernel
(gdb) continue
```

### ftrace

[参考](https://www.cnblogs.com/hpyu/p/14348151.html)

文件在 /sys/kernel/debug/tracing 目录下

#### 注意事项

* README 查看文件含义
* current_tracer 有效值查看 available_tracers
* 编译内核时需要开启一些选项才能使用
* 如果不显示某个函数，查看 available_filter_functions 确认是否支持

#### 基本用法

```sh
echo 1              > tracing_on                # 开启追踪，0 关闭
echo 1              > options/func_stack_trace  # 开启函数堆栈追踪
echo                > trace                     # 清空缓存
echo function_graph > current_tracer            # 设置 tracer 类型
echo $func          > set_graph_function        # 只为这些函数生成 graph
echo drm_ioctl      > set_ftrace_filter         # function 时只追踪过滤函数
echo drm_ioctl      > set_ftrace_notrace        # function 时反向过滤
echo $pid           > set_ftrace_pid            # 追踪指定进程
echo 5              > max_graph_depth           # 设置 graph 深度

# 追踪 amdgpu_cs 事件
echo 1              > events/amdgpu/amdgpu_cs/enable

cat enabled_functions                           # 查看当前追踪的函数
cat /sys/kernel/debug/tracing/trace             # 查看追踪结果
```

#### 如果未追踪检查以下文件

```sh
cat tracing_on                  # 1
cat current_tracer              # function / function_graph
cat set_ftrace_filter           # 包含追踪函数
cat set_ftrace_pid              # no pid / 要追踪的 pid
```

#### 追踪指定 pattern

```sh
# 追踪指定模块
echo '*:mod:amdgpu*' > set_ftrace_filter
# 指定函数名 pattern
echo 'amdgpu*' > set_ftrace_filter
```

#### 追踪函数

使用 function 向上追踪函数堆栈，使用 function_graph 向下追踪内部调用

```sh
td="/sys/kernel/debug/tracing"
exe="traced_exec_file args"
func="drm_ioctl"
echo 0          > $td/tracing_on
echo            > $td/trace
# echo function_graph   > $td/current_tracer
# echo $func      > $td/set_graph_function
echo function   > $td/current_tracer
echo 1          > options/func_stack_trace
echo $func      > $td/set_ftrace_filter
echo $$         > $td/set_ftrace_pid; \
echo 1          > $td/tracing_on; \
exec $exe
```

#### 追踪 event

```sh
echo amdgpu:amdgpu_cs   > set_event                 # 追踪指定 event
echo 1                  > events/amdgpu/enable      # 追踪当前目录所有 event
echo *                  > events/amdgpu/filter      # 只追踪指定 pattern

cat available_events                                # 查看有效 event
cat /sys/kernel/debug/tracing/trace                 # 查看追踪结果
```

### trace-cmd

```sh
# 封装了 ftrace
sudo apt install trace-cmd
```

```sh
# 查看有哪些选项可用
trace-cmd list -h
    -t: 可用 tracer
    -f: 可追踪函数

# 只用于设置启动选项，并不实际追踪
trace-cmd start -h
    -p: 设置 current_tracer

# 开始追踪并记录到 trace.dat，可通过 report 命令查看
trace-cmd record -h
    -e: 追踪事件
        -f: event filter
    -l: filter function name
    -g: graph function name
    -P: pid
    -F: 只追踪给定命令
trace-cmd report

# 停止追踪，相当于 echo 0 > tracing_on
trace-cmd stop

# 查看追踪记录
trace-cmd show

# 重置所有选项，会清空 trace
trace-cmd reset
```

#### 示例

```sh
# 追踪 drm cs 单元测试中 amdgpu 相关内核函数
sudo trace-cmd record -p function -l "amdgpu*" -F ./amdgpu_test -s 3 -t 1
trace-cmd report
# 只追踪 amdgpu_cs_ioctl 的 graph
sudo trace-cmd record -p function_graph -g amdgpu_cs_ioctl -F ./amdgpu_test -s 3 -t 1

# 追踪 drm cs 单元测试中和 amdgpu_cs 有关事件
sudo trace-cmd record -e "amdgpu_cs*" -F ./amdgpu_test -s 3 -t 1
trace-cmd report
```

### pcie_debug

[github](https://github.com/Martoni/pcie_debug)

pcie_debug 是读取 PCIe BARx 地址空间的命令行工具

```c
#include <stdint.h>
// 需要将 struct device_t 的属性修改类型，否则只能访问 256M
size_t size;
size_t offset;
// 改为
uint64_t size;
uint64_t offset;
```

```sh
sudo pcie_debug
    -s  : 指定 pci 设备编号
    -b  : 指定 BAR 编号，如 -b 0
    -f  : 执行文件中命令
    -q  : 执行文件中命令后退出
```

## Module

### 安装与卸载

```sh
lsmod                           # 查看当前 modules
sudo rmmod amdgpu               # 卸载指定 module，不会自动卸载依赖，需要 module 未被使用
sudo rmmod -f amdgpu            # 卸载正被使用的 module，需要内核支持，man 查看编译选项(CONFIG_MODULE_FORCE_UNLOAD)
sudo modprobe amdgpu            # 安装 /lib/modules 下的 module，会自动安装依赖的 module
sudo insmod ./amdgpu.ko         # 安装指定路径的 module，不会自动安装依赖的 module
```

#### 强制卸载

当加载 module 报错时，使用 -f 也无法卸载，可以参考下面的方式

[force_unload.c](src/modules/force_unload/force_unload.c)

```sh
# 查看引用计数，大于 0 需要重置
cat /sys/module/amdgpu/refcnt
# 如果显示为 coming 表示正在初始化，此时不仅要重置引用计数，还要重置状态
cat /sys/module/amdgpu/initstate

# 在 force_unload.c 所在目录
make
sudo insmod force_unload.ko
sudo rmmod force_unload
# 然后尝试卸载出错模块
sudo rmmod amdgpu

# 卸载后无法重新安装，待解决
```

### modinfo

```sh
# 查看 module 信息
modinfo amdgpu
modinfo amdgpu.ko

# 查看 module 对应的内核版本
modinfo amdgpu | grep vermagic
```

### drm

[drm-gem](https://www.systutorials.com/docs/linux/man/7-drm-gem)

#### GEM/TTM

* GEM: graphics execution manager developed by Intel initially, used for device memory management and focus on simplicity
* TTM: translation table manager, another device memory management, suitable for both UMA and devices with dedicated RAM

### amdgpu

[amdgpu](drivers/amdgpu.md)

## 命令

### dmesg

用于显示内核环缓冲区（ring buffer）的内容。内核环缓冲区记录了系统启动以来内核产生的各种信息，包括设备初始化、驱动程序加载、错误信息、警告信息等。

```sh
dmesg                               # 查看本次内核日志 /var/log/dmesg
cat /var/log/kern.log               # 查看历史内核日志

cat /proc/sys/kernel/printk         # 查看日志等级，第一个表示 console_loglevel
sudo dmesg -n debug                 # 设置日志等级
```

```yml
-C: 清除环缓冲区中的内容，需要 sudo
-c: 显示后再清除
-n: 设置 console 显示日志等级，可选值通过 -h 查看
    -: 不是设置本次日志等级，而是设置后续显示日志等级
-T: 在日志中显示时间戳
-w: --follow 实时显示日志
```

### strace

追踪命令的系统调用流程

```sh
strace ls

# strace 输出到 stderr，过滤时需要重定向
strace ls 2>&1 | grep ioctl
```

```yml
-o: 写入文件而不是 stderr
-p: 追踪指定 pid
-c: 统计调用时间
-f: 也统计子进程
-e: 过滤，strace -e trace=open,read ls
-y: 显示文件描述符对应文件路径
```

### pci

[A Practical Tutorial on PCIe for Total Beginners on Windows (Part 1)](https://ctf.re/windows/kernel/pcie/tutorial/2023/02/14/pcie-part-1)

Peripheral Component Interconnect [Express]，计算机内外围设备互联标准

```sh
# 查看指定 pci 设备信息
ls /sys/bus/pci/devices/0000:03:00.0

# 重新扫描 pci 总线
sudo sh -c 'echo 1 > /sys/bus/pci/rescan'
```

* PCI registers (configuration space) 使用小端法，如在文件/内存中布局为 0x12 0x34 的占 2 个字节的数据，实际表示的值是 0x3412

#### 配置空间

[pcie configuration space](https://zhuanlan.zhihu.com/p/662317817)

#### BAR

​BAR（Base Address Register，基地址寄存器）用于动态分配和管理硬件设备的地址空间，通过 ioremap 将硬件内存等映射到系统 CPU 虚拟地址空间。

#### interrupt (中断)

```sh
# PCI 设备的中断请求（IRQ）在系统中的 ​逻辑中断号
# 注意: INTERRUPT_LINE 仅在传统 INTx 模式下有效，如果设备使用 MSI/MSI-X，该字段可能被 BIOS/OS 设为 0xff 表示未使用
setpci -s 03:00.0 INTERRUPT_LINE

# 如果支持中断是非 0 值，表示使用哪个 pin 发出中断信号
# 一个 PCI connector 有 4 个 interrupt pins
setpci -s 03:00.0 INTERRUPT_PIN

# 查看系统已经处理的中断数量
# 第一列是中断编号
cat /proc/interrupts
```

#### lspci

```sh
# -v, -vv, -vvv: verbose 程度递增
lspci                       # 查看 PCI 设备信息
lspci | grep -i vga         # 查看 GPU PCIe 信息，第一列是设备的 PCI 地址
# 设备地址含义，PCI域通常为 0000，单主机系统可省略
# PCI域:总线号:设备号.功能号
# Bus:Device.Function 被称为 BDF
lspci -v -s 01:00.0         # 根据设备地址查看详细信息

sudo lspci -x -s 01:00.0    # 查看 PCI 配置空间
    -x      : hex dump of the standard PCI configuration space(64/128 bytes)
    -xxx    :
    -xxxx   : the extended (4096-bytes) PCI configuration space
```

Capability

```sh
# lspci -vv -s 03:00.0 输出如下
# [50] 表示该配置内存地址从 0x50 开始
Capabilities: [50] Power Management version 3

# 查看 CAP_PM，两者一样
sudo setpci -s 03:00.0 0x50.l
sudo setpci -s 03:00.0 CAP_PM+0.l
```

```sh
# 检查 pci 设备 IOMMU
sudo dmesg | grep iommu     # Adding to iommu group
find /sys/kernel/iommu_gropus -name "*01:00.0"
```

#### setpci

```sh
setpci --dumpregs       # 查看
    # cap pos w name
    #      00 W VENDOR_ID
    #      02 W DEVICE_ID
    #      04 W COMMAND
    cap     : capability id
    pos     : 在配置空间内地址偏移
    w       : 字节数，b/w/l -> 1/2/4
    name    : 名称
```

```sh
setpci -s 01:00.0 0x24.l            # 读取配置空间，地址偏移为 0x24，(b/w/l 分别表示 1/2/4 字节)
setpci -s 01:00.0 BASE_ADDRESS_5    # 也可以直接用 dumpregs 查到的值，可以不加宽度
```

## 函数

### ioctl

[ioctl](https://zhuanlan.zhihu.com/p/578501178)

Input Output Control, 用户程序通过 ioctl 和设备交互(读写)，内核会根据设备文件的 major number 自动调用相应驱动的 ioctl 函数

```c
// fd     : 读写的文件描述符
// request: 一般用宏创建，包含: in/out, size 等信息
//        : 内核和用户程序需要使用相同头文件以保证格式一致
int ioctl(int fd, unsigned long request, ...);
```

### dump_stack

打印函数堆栈

```c
#include <linux/kernel.h>
dump_stack();
```

## Ring Buffer

### Ring Buffer 数据结构

[参考](https://blog.csdn.net/weixin_43778179/article/details/120287393)

```c
// 仅用于辅助理解，实际代码可能有差别
struct kfifo {
    unsigned char *buffer;
    unsigned int size;
    unsigned int in;           // 从该 offset 插入数据
    unsigned int out;          // 从该 offset 读取数据
    spinlock_t *lock;          // 自旋锁防止并发问题
};
```

### kernel space

* 不同模块会通过 printk 共用一个用于打印的 ring buffer
* 不同模块可能会创建自己的 ring buffer
* ring buffer 可以在初始化时就创建，也可以动态创建
* cpu 不同核心可能共用同一个 ring buffer(如 printk)，也可能有自己的(如 ftrace)，共用时需要使用自旋锁解决竞争问题，效率会低一些

### user space

```sh
# 向 ring buffer 写入数据
sudo sh -c 'echo test > /dev/kmsg'
```

## tips

### 无显示器启动

[设置 BIOS](https://askubuntu.com/questions/1052310)

```sh
# 无屏幕启动，修改 /etc/default/grub 后更新
GRUB_CMDLINE_LINUX_DEFAULT="biosdevname=0 nomodeset"
sudo update-grub
```
