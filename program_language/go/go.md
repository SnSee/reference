
# go

[官网](https://golang.google.cn/)

[菜鸟教程](https://m.runoob.com/go/go-tutorial.html)

## 安装

[linux](../../%E7%8E%AF%E5%A2%83/linux.md#go)

## 包路径

```text
GOROOT: go安装路径
GOPATH: 环境变量，可通过shell命令设置
go env -w GO111MODULE=on  # on表示仅将 $GOROOT/src 作为包查找路径? off 则 $GOROOT/src 和 $GOPATH/src 都是包路径
```

推荐做法

```text
# 目录结构
project_name
    package1
    package2
    main.go
```

```text
go env -w GO111MODULE=off
# bash
export GOPATH=project_path:$GOPATH
# csh
setenv GOPATH project_path:$GOPATH
```
