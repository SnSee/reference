
# Git

## 网页

[官方文档](https://git-scm.com/docs)

[搭建服务器](https://www.runoob.com/git/git-server.html)

[管理大文件](https://blog.csdn.net/wsmrzx/article/details/115803215)

[稀疏检出sparse-checkout](https://www.jianshu.com/p/680f2c6c84de)

[显示指定文件为文本文件](https://blog.csdn.net/qijingpei/article/details/110402054)

## 配置(config)

```sh
# 查看所有配置
git config --list
git config --global --list
git config --global user.name "Your Name"   # 设置用户名

# 使用 vim 作为默认编辑器
git config --global core.editor "vim"
```

### 推荐配置

```sh
git config --global user.name       "tmp"
git config --global user.email      "tmp@example.com"
git config --global core.editor     "vim"
git config --global core.quotepath  false
git config --global core.autocrlf   input

# git config core.protectNTFS false
```

## 编码

```bash
# 设置编码
git config --global gui.encoding utf-8

# 禁止转义中文
git config --global core.quotepath false
```

## clone

```sh
git clone $remote_url
git clone $remote_url --depth 1     # 只下载最近一次提交记录
```

## 分支

```sh
# 查看本地所有分支
git branch
# 查看本地和远程所有分支
git branch -a
# 从当前分支创建新分支
git checkout -b <new_branch_name>

# 检出单个文件的历史版本(版本不变，仅仅是文件内容变成检出版本)
git checkout <commit_id> test.txt
```

## 查看

```sh
# 查看工作区及暂存区
git status [path]
# 查看提交记录
git log
    -n<i>: 只显示最近 i 次提交记录
    --stat: 只显示修改了哪些文件及改动行数
# 查看指定版本修改内容，不指定commit_id时默认为HEAD
git show <commit_id>
git show --name-status <commit_id>  # 只查看修改了哪些文件，不显示具体内容
# 查看工作区当前修改, 如果不指定file则显示所有更改
git diff [file]
# 查看工作区相对于指定版本区别
git diff <commit_id>
# 查看版本2相对于版本1区别
git diff <commit_id1> <commit_id2>
```

## 工作区与暂存区

```sh
# 添加到暂存区，如果file是目录则添加该目录下所有文件
git add <file>
# 从暂存区移到工作区，如果file是目录则针对该目录下所有文件，如果不指定file则针对暂存区所有文件
git reset <file>
```

## 清理

```sh
# 删除未添加到工作区和暂存区的文件，不指定path时全部删除
git clean -f [path]
# 如果目录也删除
git clean -fd [path]
# 撤销工作区单个文件修改
git checkout -- <file>
# 撤销工作区及暂存区所有文件修改
git reset --hard
```

```sh
# 将文件从版本管理中移除，-f 表示删除本地文件，--cached 保留
git rm --cached file
```

## 回退

```sh
# checkout
# 回退单个文件到指定版本，commit_id处写 -- 表示撤销工作区的更改
git checkout <commit_id> <file>

# reset
# 回退本地仓库到指定版本
# 将HEAD回退到指定commit_id，不指定commit_id时默认为HEAD，即最新的commit
git reset [--hard] <commit_id>
    --mixed: 默认值，会保留指定commit之后的所有更改到工作区(add之前)
    --hard: 将工作区的所有文件也回退到指定commit
    --soft: 会保留指定commit之后的所有更改到暂存区(add之后)

# revert
# 撤销指定commit
# revert不会回退版本树，而是产生一次新的提交记录，撤销后相关文件和指定commit前一次commit内容相同
# 注意: revert仅仅回退这一次commit相关的文件，如果指定commit之后的commit也修改了这个文件会冲突，需要解决冲突并手动提交
git revert <commit_id>
```

## 其他命令

### stash 缓存

```sh
# 不指定 stash@{n} 的默认为最近一次缓存
git stash                       # 暂存当前分支下改动
git stash list stash@{n}        # 查看缓存列表
git stash pop stash@{n}         # 恢复指定编号的缓存, 并删除该缓存
git stash apply stash@{n}       # 恢复指定编号的缓存，但不删除缓存
git stash drop stash@{n}        # 丢弃指定缓存
git stash push <path1> <path2>  # 缓存指定文件
git stash show stash@{n}        # 查看缓存涉及哪些文件
git stash show -p stash@{n}     # 查看缓存修改了哪些内容，相当于diff

# 重命名
git mv old.txt new.txt
```

## 远程

```sh
# 添加远程仓库链接
git remote add <lib_name> https://test.com/test.git
# 修改远程仓库链接
git remote set-url <lib_name> <new_url>
# 删除远程仓库链接
git remote rm <lib_name>
# 删除远程仓库分支
git push --delete <lib_name> <branch_name>
# 远程仓库链接重命名
git remote rename <old_name> <new_name>
# 设置远程仓库链接时指定用户名
https://<user_name>@test.com/test.git

# 更新远程仓库
git fetch <lib_name>
# 将远程仓库的分支合并到当前分支
git rebase <lib_name>/<branch_name>
# 如果发生冲突，解决冲突后add冲突文件，然后
git rebase --continue
# 如果发生冲突后想放弃本地修改
git rebase --skip
# 如果发生冲突后想放弃此次合并
git rebase --abort

# 重定向远程仓库链接
git config --global url."https://new.git".insteadOf https://old.git
# 设置pull/push为当前分支
git config --global push.default "current"
```

## 本地服务器

```sh
# 添加 git 用户
sudo adduser git
# 创建仓库
sudo mkdir /repo && cd /repo
git init --bare test.git
sudo chown git:git /repo/test.git

# 同一个主机其他用户 clone
git config --global --add safe.directory /repo/test.git
git clone /repo/test.git        
# 需要加入到 git 用户组才能 push
sudo usermod -aG git username

# 在其他主机上 clone
git clone git@server_ip:/opt/git/project.git
```

## submodule

```sh
# 查看子模块
git submodule

# 添加子模块
git submodule add <repository_URL> <path>

# 更新子模块
git submodule update --remote
git submodule update --init --recursive
```

## 换行符

```sh
#提交时转换为LF，检出时转换为CRLF
git config --global core.autocrlf true
 
#提交时转换为LF，检出时不转换
git config --global core.autocrlf input
 
#提交检出均不转换
git config --global core.autocrlf false

```

## .gitignore

```text
# 忽略.idea文件夹及文件夹下文件
.idea 

# 忽略以.iml结尾的文件
*.iml 

# 忽略*.o和*.a文件

 *.[oa]

# 忽略*.b和*.B文件，my.b除外

*.[bB]

!my.b

# 忽略dbg文件和dbg目录

dbg

# 只忽略dbg目录，不忽略dbg文件

dbg/

# 只忽略dbg文件，不忽略dbg目录

dbg

!dbg/

# 只忽略当前目录下的dbg文件和目录，子目录的dbg不在忽略范围内

/dbg

# 以'#'开始的行，被视为注释.

 * ？：代表任意的一个字符
    * ＊：代表任意数目的字符
    * {!ab}：必须不是此类型
    * {ab,bb,cx}：代表ab,bb,cx中任一类型即可
    * [abc]：代表a,b,c中任一字符即可
    * [ ^abc]：代表必须不是a,b,c中任一字符
```

```text
# 忽略数字
[0-9]/
[0-9][0-9]*/
[0-9]*.[0-9]*/

# 忽略目录下所有文件，但保留指定格式的文件
folder/*
!folder/*.txt
```

## QA

### 仓库损坏修复

[修复损坏的松散对象](https://jishuzhan.net/article/1953848054045519873)

现象: 使用 git status 等命令时报错对象文件为空

```sh
git fsck --full                 # 检查仓库完整性，会报错对象为空
git remote -v                   # 确保远程仓库存在
cp -r .git .git_backup          # 备份
find .git/objects/ -size 0 -exec rm -f {} \;    # 删除所有空对象
git fsck --full                 # 再次检查，会报错无效指针及悬空对象
git fetch origin                # 从远程仓库更新
git reset --hard origin/branch_name     # 重置本地分支
git fsck --full                 # 再次检查，报告正常
```
