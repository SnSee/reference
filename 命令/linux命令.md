# Linux

## 1. 光标

```text
ctrl + a: 跳到行首
ctrl + e: 跳到行尾
ctrl + u: 删除到行首
ctrl + k: 删除到行尾
ctrl + 方向键: 光标按单词移动
```

## 2. 用户

```text
根据 uid 查询用户名: getent passwd uid
根据用户名查询 uid: id user_name
```

## 3. 文件

```bash
# 查看文件
inode: ls -i 或 stat file_name

# 查看文件个数
ll | wc -l
find ./ -name "*.cpp" | wc -l
```

## 4. 进程

### 4.1. ps

```text
查看进程启动及运行时间: ps -eo pid,lstart,etime | grep 进程id
    pid: 进程id，可通过 `ps aux | grep app_name` 查找
    lstart: 启动时间
    etime: 运行时间
```

### 4.2. 脚本

```text
查看当前进程 id: echo $$
```

## 5. 版本

```text
查看发行版信息
    cat /etc/os-release
    cent-os: cat /etc/centos-release
```

## 6. 编程

```text
查看程序运行时动态库搜索路径: readelf -d app_name | head - 20
查看动态库中有那些符号: strings test.so，如果要查找是否含有特定字符串，配合grep使用
```

## 7. 查找文件

### 7.1. locate

```text
locate <file_name> (支持wildcard)
```

### 7.2. find

```text
递归删除当前路径下所有名称及类型符合匹配条件的文件
    find ./ -type {type} -name {name} | xargs rm -rf
    find ./ -type {type} -name {name} -exec rm -rf {} \;
```

## 8. shell编程(bash)

```text
睡眠: sleep, usleep
数组
    定义数组: arr=("1" "2" "3" "4")
    访问数组: arr[index]
let
    自加: let ++index
进度条
    printf "....\r" (最后的\r会把输出位置定位到本行行首)
```

## 时间

```text
显示当前时间: date
显示程序耗时: time ./a.out
```

## 环境变量

```bash
# 当前shell类型
$SHELL

# 可执行文件查找路径
$PATH

# 临时动态库查找路径
$LD_LIBRARY_PATH
```
