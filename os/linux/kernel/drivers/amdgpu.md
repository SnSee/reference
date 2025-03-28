
# amdgpu

[AMD search](https://www.amd.com/en/search/documentation/hub.html)
[Glossary](https://docs.kernel.org/gpu/amdgpu/amdgpu-glossary.html)
[drm/amdgpu AMDgpu driver](https://docs.kernel.org/gpu/amdgpu/index.html)
[amdgpu Dirver Notes](https://wiki.huangxt.cn/gpu/amdgpu-Driver-Notes)
[AMD GPU 手册](https://www.x.org/docs/AMD/old/R5xx_Acceleration_v1.5.pdf)
[AMD GPU 任务调度1 - 用户态](https://blog.csdn.net/huang987246510/article/details/106658889)
[AMD GPU 任务调度2 - 内核态](https://blog.csdn.net/huang987246510/article/details/106737570)
[AMD GPU 任务调度3 - fence 机制](https://blog.csdn.net/huang987246510/article/details/106865386)
[GPU submission strategies](https://gpuopen.com/presentations/2022/gpuopen-gpu_submission-reboot_blue_2022.pdf)

[Module Parameters](https://docs.kernel.org/gpu/amdgpu/module-parameters.html)

## Concepts

### MQD

* The AMD GPU has a unit called Command Processor (CP) in charge of driving work based on information provided by the driver. The MQD is an object in memory that describes the configuration of a compute queue. The firmware reads the state out of the MQD and puts it into a hardware slot when the queue is scheduled.
* When a queue is de-scheduled, the firmware saves the queue state from the hardware slot back to the MQD.

```sh
# 查看 gfx mqd 设置
sudo cat /sys/kernel/debug/dri/1/amdgpu_mqd_gfx_0.0.0 | xxd -c 4 -e
```

### SE, SH, CU

* SE(Shader Engine): 着色器引擎是GPU中的一个主要模块，负责处理图形和计算任务，每个 SE 包含多个 SH
* SH(Shader Array): 着色器阵列，是SE中的一个子模块。每个SE可以包含多个SH，每个SH又包含多个 CU(Compute Unit)
* 在 RDNA 架构中，一个 shader array 可能由多个 WGP(Workgroup Processor) 构成，而每个 WGP 又包含两个 CU

### TCC

Texture Cache Controller（纹理缓存控制器）。它是 GPU 中负责管理纹理数据缓存的关键硬件模块，主要用于优化纹理数据的访问效率，从而提升图形渲染和计算任务的性能。

* L1 Cache：每个计算单元（CU）都有自己的 L1 缓存，用于存储局部数据。
* L2 Cache：多个 CU 共享 L2 缓存，TCC 通常与 L2 缓存协同工作。
* 显存（VRAM）：当缓存未命中时，TCC 会从显存中加载纹理数据。

### Clock Gating

时钟门控是一种硬件级别的电源管理技术，通过动态关闭或启用某个硬件模块的时钟信号来降低功耗。

当需要节能时（如GPU空闲），调用 set_clockgating_state 函数启用时钟门控，关闭模块的时钟信号。

当模块需要工作时（如GPU进入高负载状态），调用此函数禁用时钟门控，恢复时钟信号。

每个IP模块（如GFX、UVD、VCN等）可能有自己的时钟门控实现，因此该函数的行为因硬件模块而异。

```sh
# 查看 clock-gating state
cat /sys/kernel/debug/dri/<N>/amdgpu_pm_info
```

### AMD KFD

[amdkfd](https://zhuanlan.zhihu.com/p/655989037)

AMD Kernel Fusion Driver 驱动用于支持 GPU 和 CPU 之间的协同工作，以实现异构系统架构（Heterogeneous System Architecture，HSA）

KFD 功能: 硬件抽象，内存管理，任务调度与执行，事件通知和同步，数据传输等

### APU

Accelerated Processing Unit 将 CPU，GPU 集成于同一芯片上的处理器，融合了 x86 处理器核心与 AMD 的图形核心（GPU 核心），通过统一的内存控制器和高速内部总线连接两者，让 CPU 和 GPU 能够更紧密协作、共享资源，打破了传统 CPU 与独立 GPU 之间数据传输的瓶颈。

### dummy page

在AMDGPU驱动中，dummy page（虚拟页/占位页） 是一个特殊的内存页面，用于在图形地址重映射表（GART）中充当占位符，确保系统在内存动态分配和释放时的稳定性和安全性。

1. 为什么需要dummy page？

* 防止非法访问：当GPU通过GART访问内存时，某些条目可能因内存释放或未分配而无效。若直接保留空指针或无效地址，GPU访问这些条目会导致崩溃或数据损坏。dummy page提供了一个安全的“虚拟”目标，所有无效的GART条目均指向此页，避免非法访问。
* 内存管理一致性：GPU内存管理需要动态分配和释放物理页（如显存或系统内存）。在页被释放后，GART条目不能立即清空（可能仍有未完成的操作），此时用dummy page填充，保持GART结构的完整性。
* 避免未初始化数据泄漏：dummy page通常被初始化为全零或固定值，防止通过无效地址读取到随机内存内容（可能包含敏感数据）。

### AGP

[agp-aperture-size](https://www.lenovo.com/us/en/glossary/agp-aperture-size)

AGP (Accelerated Graphics Port) aperture size is the amount of system memory allocated to the AGP for graphics operations. It serves as a buffer for the graphics card, allowing it to temporarily store textures and other graphical data. This allocation affects graphics performance by determining how much memory the graphics card can access, impacting tasks like rendering complex 3D graphics or high-resolution textures. Adjusting the aperture size can optimize performance based on system capabilities and application requirements.

### gang

gang 用于管理一组需要协同调度的GPU作业（jobs）。

1. Gang（作业组）的概念

* 协同调度需求：GPU任务（如计算、渲染）可能需要多个作业协同执行。例如，多个作业需共享资源、同步执行或按特定顺序提交。
* 原子性保障：通过将作业捆绑为gang，驱动确保它们被调度器视为一个整体，避免部分作业执行导致资源竞争或状态不一致。
* 硬件队列管理：某些GPU硬件可能要求相关作业必须提交到同一队列或按特定顺序处理，gang机制简化了这种复杂调度。

2. Gang Leader（领导者）的角色

* 调度协调：调度器可能优先处理gang_leader，其状态可能影响整个gang的调度（如阻塞或完成事件）。
* 同步点：其他作业可能依赖gang_leader的执行结果，例如通过硬件信号或软件同步机制。
* 资源管理：gang_leader可能负责分配共享资源（如内存、寄存器），确保组内作业一致性。
* 错误处理：若gang_leader执行失败，整个gang可能被标记为失败，触发统一回滚或恢复机制。

3. 典型应用场景

* 多队列依赖：如计算任务依赖渲染结果，需将两个作业捆绑为gang，确保渲染作业（gang_leader）先执行。
* 资源共享：多个作业共享同一缓冲区，通过gang确保它们被连续调度，避免中间插入其他作业导致资源冲突。
* 硬件约束：某些GPU架构要求特定操作序列必须原子提交，gang机制保证这些作业被整体处理。

4. 示例流程

用户提交一组作业 → 驱动创建gang并设置gang_size → 指定gang_leader及其索引 → 将作业填入jobs[]，绑定调度实体到entities[] → 调度器将gang作为单元处理，优先提交gang_leader → 根据硬件反馈更新整个gang状态。

## amdgpu ring buffer

[PM4 packet format](https://www.jianshu.com/p/0eedbd58162b)
[PM4 packet spec-2011](https://www.amd.com/content/dam/amd/en/documents/radeon-tech-docs/programmer-references/evergreen_cayman_programming_guide.pdf)
[PM4 packet spec-2012](https://www.amd.com/content/dam/amd/en/documents/radeon-tech-docs/programmer-references/si_programming_guide_v2.pdf)

* amdgpu 使用 PM4 packet 作为 ring buffer 中数据的格式，PM4 packet 通过 PCIe bus 传递
* gfx 使用的是 type-3 类型

### fence

* fence 对象是共用的，但是有不同类型的 fence，通过 dma_fence_get 获取对象引用并增加引用计数
* 需要通过 amdgpu_ctx_add_fence 添加 fence，该函数会返回一个 sequence 表示当前 fence 编号，该编号是递增的
* 通过 PM4 packet 将 PACKET3 命令添加到 ring buffer 中时，会在最后添加一个 fence 命令(PACKET3_EVENT_WRITE_EOP)，该 fence 有一个 sequence 值
* GPU 执行该条指令时会将 seq 值写入命令中的地址，然后发送一个中断通知 CPU，CPU 获取地址中的 seq 值并于当前维护的 cur_seq 值比较，如果不一致说明执行了 fence，即有任务完成，然后发出 signal，解除 dma_fence_wait 函数的阻塞并调用通过 dma_fence_add_callback 注册的回调
* 记录 GPU 实际完成的 seq 的地址只有一个，当 seq 值和 cur_seq 不一致时，说明 [cur_seq, seq] 间的所有 fence 都已经执行

```c
// 将 fence 写入 ring 流程
amdgpu_ring_write(ring, PACKET3(PACKET3_EVENT_WRITE_EOP, 4));
amdgpu_ring_write(ring, EVENT_INDEX(5) | (exec ? EOP_EXEC : 0)));
amdgpu_ring_write(ring, addr & 0xfffffffc);
amdgpu_ring_write(ring, (upper_32_bits(addr) & 0xffff) | DATA_SEL(1) | INT_SEL(2));
amdgpu_ring_write(ring, lower_32_bits(seq));
amdgpu_ring_write(ring, upper_32_bits(seq));
```

#### fence_info

查看 fence 状态

```sh
sudo cat /sys/kernel/debug/dri/1/amdgpu_fence_info
```

## 内存管理

```c
GEM {               // 通过 GEM 与 user space 交互
    TTM {           // 将 GEN 转换为 TTM，实际使用 TTM 管理，GEM 只是接口
        AMDGPU_BO   // Buffer Object，实际的 buffer 内容
    }
}
```

### 虚拟内存 (VM)

查看 manual: **GPU VM Management**

Each VM has an ID associated with it and there is a page table associated with each VMID. When execting a command buffer, the
kernel tells the the ring what VMID to use for that command buffer. VMIDs are allocated dynamically as commands are submitted.
The userspace drivers maintain their own address space and the kernel sets up their pages tables accordingly when they submit
their command buffers and a VMID is assigned.

## CS (Command submit)

### 调度器数据结构

* **amdgpu_ring** (hardware ring) 中有一个任务调度器 **drm_gpu_scheduler**
* drm_gpu_scheduler 管理多个调度队列 **drm_sched_rq**
* drm_sched_rq 管理多个调度实体 **drm_sched_entity**，不同 entity 具有不同的优先级 drm_sched_priority
* drm_sched_entity 管理多个调度任务 **drm_sched_job**
* **amdgpu_job** 相当于继承了 drm_sched_job，增加了 **Indirect Buffer** 信息用来存储命令

```mermaid
classDiagram
    amdgpu_ring *-- amdgpu_ring_funcs
    amdgpu_ring o-- drm_gpu_scheduler

    class amdgpu_ring {
        const struct amdgpu_ring_funcs  *funcs;     // 操作 ring buffer 的函数
        struct drm_gpu_scheduler        sched;      // 任务调度器
        struct amdgpu_bo                *ring_obj;  // buffer objects
        volatile uint32_t               *ring;
    }
```

```c
// 任务调度器，用于调度特定实例，每个 hardware ring 都有一个调度器
struct drm_gpu_scheduler {
    const struct drm_sched_backend_ops  *ops;           // 操作 job 的回调函数，用于提交 job 的是 ops->run_job
    u32                                 credit_limit;   // 能够同时提交的任务数量
    atomic_t                            credit_count;   // 已经提交的任务数量
    long                                timeout;        // 超时后从调度器移除 job
    const char                          *name;          // 该调度器操作的 ring buffer 名称
    u32                                 num_rqs;        // run-queues 数量
    struct drm_sched_rq                 **sched_rq;     // run-queues，每个 run-queue 有一个或多个 entity，每个 entity 有一个或多个 job
    wait_queue_head_t                   job_scheduled;  // 其他线程等待一个 entity 中所有 job 完成，完成后调度器会唤醒该线程
    atomic64_t                          job_id_count;   // 为每个 job 赋予一个唯一的 id
    struct workqueue_struct             *submit_wq;     // workqueue used to queue @work_run_job and @work_free_job
    struct workqueue_struct             *timeout_wq;    // workqueue used to queue @work_tdr
    struct work_struct                  work_run_job;   // work which calls run_job op of each scheduler
    struct work_struct                  work_free_job;  // work which calls free_job op of each scheduler
    struct delayed_work                 work_tdr;       // schedules a delayed call to @drm_sched_job_timedout after the timeout interval is over
    struct list_head                    pending_list;   // the list of jobs which are currently in the job queue
    spinlock_t                          job_list_lock;  // lock to protect the pending_list
    int                                 hang_limit;     // once the hangs by a job crosses this limit then it is marked guilty and 
                                                        // it will no longer be considered for scheduling.
    atomic_t                            *score;         // 选取空闲调度器时用于帮助负载均衡
    atomic_t                            _score;         // driver 不提供时使用的 score
    bool                                ready;          // 标记底层硬件是否 ready
    bool                                free_guilty;    // A hit to time out handler to free the guilty job
    bool                                pause_submit;   // pause queuing of @work_run_job on @submit_wq
    bool                                own_submit_wq;  // 当前调度器是否管理 @submit_wq 的内存
    struct device                       *dev;           // system &struct device
};
```

### CS 流程

|func |step
|- |-
|amdgpu_cs_parser_init  |init parser (amdgpu_device，drm_file，context等)
|amdgpu_cs_pass1        |获取或创建 entity;<br>遍历 chunks，创建 job，将渲染数据从用户态拷贝到内核态，设置 job 的 entity
|amdgpu_cs_pass2        |遍历 chunks，初始化 job->ibs
|amdgpu_cs_parser_bos   |设置 parser->bo_list
|amdgpu_cs_patch_jobs   |依据 bo_va_map 拷贝 job->ibs 数据
|amdgpu_cs_vm_handling  |
|amdgpu_cs_sync_rings   |同步 fence
|trace_amdgpu_cs_ibs    |tracing_fs 日志
|amdgpu_cs_submit       |
|--drm_sched_job_arm    |设置 job 的调度器及 s_fence 等
|--drm_sched_job_add_dependency |设置 job 依赖的 fence
|--amdgpu_ctx_add_fence |为 ctx 添加 fence，并将 handle 传回 UMD
|--amdgpu_cs_post_dependencies|
|amdgpu_cs_parser_fini  |清理工作，释放各种引用

1. 解析用户态渲染命令并存储到 chunks 中
初始化 job
从 chunks 中拷贝渲染命令到 IB 中
初始化 entity
将 job 加入 entity
GFX scheduler 选择一个 entity，以 FIFO 方式取出 job
执行 job->amdgpu_job_run，提交存放渲染命令的 IB

### 命令传递

CPU 和 GPU 的渲染命令传递通过 Ring Buffer 来实现

## module options

amdgpu_drv.c 中定义了类似下面这样的代码，表示能够在加载模块时指定参数

```c
/*
disable_cu          : insmod 时指定的参数名称
amdgpu_disable_cu   : 在 amdgpu_drv 中定义的变量
charp               : 数据类型为 char *，也可以是 uint 等
0444                : 该数据设置后访问权限，0444 表示只读
*/
MODULE_PARM_DESC(disable_cu, "Disable CUs (se.sh.cu,...)");
module_param_named(disable_cu, amdgpu_disable_cu, charp, 0444);
```

```sh
insmode amdgpu.ko disable_cu="0.0.0,0.0.1"  # 禁用指定编号的两个 CU
sudo dmesg | grep "amdgpu: disabling"       # 查看是否禁用
```

## 寄存器

```yml
CP: Command Process 相关命令
```

```sh
sudo umr -r *.*.mm.*                # 查看所有寄存器
sudo umr -r *.*.mmCP.*              # 查看所有 CP 寄存器
```

amdgpu 中对寄存器的定义在 **drivers/gpu/drm/amd/include/asic_reg** 下，其中
offset.h 定义寄存器，
sh_mask.h 定义寄存器中各个字段对应位域(SHIFT + MASK)

```C
// 如 32 位寄存器中某个字段范围为 [11:8] 共占 4 位，则
// 读该字段时需要先使用 MASK(0xf00) 移除其他字段，再右移位 8 位
uint32_t val_r = (REG_R & MASK) >> SHIFT;
// 写该字段时需要左移位 8 位
uint32_t val_w = val_new << SHIFT;
uint32_t val_other = REG_R & ~MASK;
REG_W = (val_w | val_other);
```

|Name |File |Desc
|- |- |-
|mmCP_RB.*_BASE         |   |当前 ring buffer
|mmCP_IB.*_BASE         |   |当前 indirect buffer
|mmRLC_CNTL             |gc_10_3_0_sh_mask.h    |
|mmGRBM_STATUS          |sid.h                  |CP_BUSY,CB_BUSY,GPU_ACTIVE 等
|mmGRBM_STATUS2         |gc_10_3_0_sh_mask.h    |RLC_BUSY,CPG_BUSY 等
|mmGRBM_GFX_CNTL        | gc_10_3_0_sh_mask.h   |其中的 PIPEID,MEID,VMID,QUEUEID 表示当前选中的 queue

## debug

[GPU Debugging](https://docs.kernel.org/gpu/amdgpu/debugging.html)

### umr

[doc](https://umr.readthedocs.io/en/main/index.html)
[查看 fence 状态](#fence_info)

```sh
umr -c                                      # 查看显卡配置
umr -lb                                     # 查看当前显卡的 IP blocks

sudo umr --read .*.mmUVD_CGC_.*             # 读取 register
sudo umr --vm-read 0x1000 10 | xxd -e       # 读取 virtual memory
sudo umr --ring-stream gfx[0:9]             # 读取 gfx ring 前 10 个 dword
sudo umr --ring-stream gfx[.]               # 读取 gfx ring 中直到读指针位置的内容

sudo umr -w .*.gfx800.mmCP_RB_DOORBELL_RANGE_LOWER ff  # 设置指定寄存器的值
```

#### 读取 indirect buffer

```sh
# IB_BASE_HI, IB_BASE_LO: GTT 的虚拟内存地址
# IB_SIZE: 大小
# IB_VMID: 虚拟内存 id
Opcode 0x3f [PKT3_INDIRECT_BUFFER] (3 words, type: 3, hdr: 0xc0023f00)
|---> IB_BASE_LO=0x0, SWAP=0
|---> IB_BASE_HI=0x1
|---> IB_SIZE=16, IB_VMID=1, CHAIN=0, PRE_ENA=0, CACHE_POLICY=0, PRE_RESUME=0, PRIV=0
```

```sh
# umr -di <IB_VMID>@<IB_BASE_HI><IB_BASE_LO> <IB_SIZE>
sudo umr -di 0x1@0x100000000 16
```

#### 读写 GTT 内存

```sh
# 查看 VMID=1 的内存地址 0x100000400，长度为 4 字节
> sudo umr -vr 0x001@0x100000400 0x4 | xxd -e
# 不能显示为可见字符的 ascii 值显示为 .
00000000: 00000000                              ....
```

```sh
# 1 的 ASCII 码为 49，即 0x31
> echo 1111 | sudo umr -vw 0x001@0x100000400 0x4
> sudo umr -vr 0x001@0x100000400 0x4 | xxd -e
00000000: 31313131                             1111

# 借助 python 可以输入不可见字符
> python -c 'print(chr(0)*4)' | sudo umr -vw 0x001@0x100000400 0x4
> sudo umr -vr 0x001@0x100000400 0x4 | xxd -e
00000000: 00000000                             ....
```
