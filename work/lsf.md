
# lsf

[IBM官方文档(直接搜索lsf命令)](https://www.ibm.com/docs/en)

[IBM官方文档中文版(机翻)](https://www.ibm.com/docs/zh)

[安装openlava](https://www.cnblogs.com/alittlemc/p/16646098.html)

## 进阶使用方法

<https://zhuanlan.zhihu.com/p/426515062>

```text
作业的管理：如何查看作业的详细信息以及管理作业的行为状态
作业行为定制：如何进行前处理和后处理，如何自动处理作业的异常状况
作业资源需求声明：如何写作业对资源的需求，包括NUMA节点和GPU的指定方法
一般的使用技巧：如何使用选项模版提交作业，如何快速提交批量作业，如何定制命令行输出格式等
使用管理员定义的对象：如何查看和使用队列， 应用配置以及预留资源
```

命令

```bash
# 提交任务
bsub [-q <queue>] [-m <host>] [-o <log>] [-e <err.log>] [-cwd <working_directory>] <EXE>
# -Ip: 在当前shell交互
# 引用jobid: %J

# 查看所有任务
bjobs 

# 查看指定任务
bjobs [-w] [-l] <JOBID>

# 终止指定任务
bkill <JOBID>

# 查看所有队列
bqueues

# 查看所有主机
bhosts

# 查看指定队列关联主机
bhosts <queue>

# 查看负载
lsload [HOST_NAME]
```
