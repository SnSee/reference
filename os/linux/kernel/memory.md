
# Memory

[Drm Memory Management](https://docs.kernel.org/gpu/drm-mm.html)

## Abbr

|Abbr |Full
|- |-
|BAR    |(PICe) Base Address Register
|CAM    |Content Addressable Memory
|GEM    |Graphics Execution Manager
|MM     |Memory Manager
|MMU    |(Page) Memory Management Unit
|IOMMU  |Input/Output MMU
|PFN    |Page Frame Number
|PTE    |Page Table Entry
|PGD    |Page Global Directory
|P4D    |Page Level 4 Directory
|PUD    |Page Upper Directory
|PMD    |Page Middle Directory
|TLB    |Translation Lookaside Buffer
|TWU    |Table Walk Unit
|VA     |Virtual Address
|VAS    |Virtual Address Space
|VMA    |Virtual Memory Area
|VP     |Virtual Page
|VPN    |Virtual Page Number

## Concepts

### 虚拟内存

```yml
Virtual Address Space: 虚拟地址空间，每个进程独有
Virtual Page         : 把虚拟内存按照页表大小进行划分
Virtual Address      : 处理器看到的地址
Virtual Page Number  : 用于定位页表的PTE
```

### 物理内存

```yml
Physical Memory     : 主存上能够使用的物理空间
Physical Page       : 把物理内存按照页表的大小进行划分
Physical Address    : 物理内存划分很多块，通过物理内存进行定位
Physical Page Number: 定位物理内存中块的位置
```

### 页表

```yml
Page Table           : 虚拟地址与物理地址映射表的集合
Page Global Directory: 多级页表中的最高一级
Page Upper Directory : 多级页表中的次高一级
Page Middle Directory: 多级页表中的一级
Page Table Entry     : 虚拟地址与独立地址具体对应的记录
```

```txt
TTBR(Page Table Base Address) -> PGD -> P4D -> PUD -> PMD -> PTE -> Physical Address
```

### prefault / pre-fault

当使用 malloc 申请内存时，并没有分配实际的物理内存，当尝试访问内存时会触发 page fault，然后内核会调用处理函数为该内存创建内存页并通过内存页对应到物理内存，虽然 page fault 只发生在 first page 上，但内核会最多分配 **num_prefault** 个 page，相当于对应的地址 (地址间隔为 page size) 提前触发了 page fault

### PFN

pfn identifies the physical page for the memory

在计算机的虚拟内存管理体系中，内存会被划分成固定大小的块。虚拟内存中的这些块被叫做页面（Page），而物理内存里对应的块则称为页帧（Page Frame）。PFN 就是用来唯一标识每个页帧的编号。

### DMA

[DMA](https://zhuanlan.zhihu.com/p/618143764)
[bus-master DMA](https://blog.csdn.net/qq_16390523/article/details/43014971)

DMA 是计算机系统的一种特性，它允许某些硬件子系统能够不使用 CPU 直接访问系统内存

DMA 通常包括 system dma 和 bus-master dma。他们的区别在于system dma 是依赖于系统，device 本身并没有 dma 控制传输的能力，而 bus-master 则相反，device 有 dma 控制传输的能力。

### IOMMU

[IOMMU](https://zhuanlan.zhihu.com/p/18100038357)

### IOMMU vs. DMA

[link](https://jungo.com/windriver/iommu-vs-direct-dma)

使用场景: DMA 适合需要 **高性能** 传输数据的场景，如磁盘 IO 和 网络通信；IOMMU 适合需要 **保护内存、隔离地址** 的场景，如具有多个 IO 设备的系统或虚拟化环境

### CAM

[CAM](https://blog.csdn.net/qq_42322644/article/details/109170011)

RAM 是通过地址查找数据，而 CAM 是通过数据查找地址，在 GPU 中，CAM 可能用于实现 TLB

### VIMD and HUB

[amdgpu VMID](https://xxlnx.github.io/2020/10/25/amdgpu/AMD_GPU_VMID_HW)

GFX HUB 上有 8/16 个 VMID(0-15)，最多可以有 8/16 个虚拟内存地址空间

* VMID 0 是 KMD 专用的
* GART 地址空间在 0 上, KMD 提交 Command 是在 0 上
* VMID 0 提供 System Aperature 概念，简化内核态的物理地址翻译过程

## Page Table

[Page Tables](https://docs.kernel.org/mm/page_tables.html)

[addr 和 page index对应关系](https://zhuanlan.zhihu.com/p/108425561)

* 从内核 memory.c::walk_to_pmd 中可以看出虚拟内存地址 addr 和各级内存也之间的关系
* addr 中记录了在各级 page 中的 index
* 相关宏定义在 pgtable.h 中，不同架构和系统的 page table 可能有所区别

```c
// 查看 SHIFT 确定各级位置
printk("walk_to_pmd SHIFT: PGDIR=%d, P4D=%d, PUD=%d, PMD=%d, PTE=%d", 
    PGDIR_SHIFT, P4D_SHIFT, PUD_SHIFT, PMD_SHIFT, PAGE_SHIFT);
// 查看各级大小
printk("walk_to_pmd PTRS_PER: PGD=%d, P4D=%d, PUD=%d, PMD=%d, PTE=%d", 
    PTRS_PER_PGD, PTRS_PER_P4D, PTRS_PER_PUD, PTRS_PER_PMD, PTRS_PER_PTE);
// 查看各级 index
printk("walk_to_pmd with addr=%ld, pgd=%ld, p4d=%ld, pud=%ld, pmd=%ld, pte=%ld", 
    addr, pgd_index(addr), p4d_index(addr), pud_index(addr), pmd_index(addr), pte_index(addr));
```

## MMU

[MMU](https://zhuanlan.zhihu.com/p/596039345)
[MMU,TLB,TWU](https://blog.csdn.net/weixin_65286359/article/details/135577694)
[TLB原理](https://zhuanlan.zhihu.com/p/108425561)
[TLB,TWU原理](https://www.cnblogs.com/alantu2018/p/9000777.html)

MMU 是专门用于处理虚拟内存地址到物理内存地址转换的硬件模块。MMU模块包含了TLB和TWU两个子模块。TLB是一个高速缓存，用于缓存虚拟地址到物理地址的转换结果。页表的查询过程是由TWU硬件自动完成的，但是页表的维护是需要操作系统实现的，页表存放在主存中

## IOMMU

[IOMMU](https://blog.csdn.net/qq_34719392/article/details/114834467)

* IOMMU 将设备地址(GPU等)转换为内存物理地址，可以是硬件或软件？
* SWIOTLB(软件方式实现的IOMMU) 使寻址能力较低、无法直接寻址到内核所分配的DMA buffer的设备，也能够进行DMA操作
