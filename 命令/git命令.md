
# Git

## 网页

[官方文档](https://git-scm.com/docs)

[搭建服务器](https://www.runoob.com/git/git-server.html)

[管理大文件](https://blog.csdn.net/wsmrzx/article/details/115803215)

[稀疏检出sparse-checkout](https://www.jianshu.com/p/680f2c6c84de)

[显示指定文件为文本文件](https://blog.csdn.net/qijingpei/article/details/110402054)

## 编码

```bash
# 设置编码
git config --global gui.encoding utf-8

# 禁止转义中文
git config --global core.quotepath false
```

## 分支

```text
查看本地所有分支: git branch
查看本地和远程所有分支: git branch -a
从当前分支创建新分支: git checkout -b <new_branch_name>
```

## 查看

```text
查看工作区及暂存区: git status [path]
查看提交记录: git log
    -ni: 只显示最近i次提交记录
    --stat: 只显示修改了哪些文件及改动行数
查看指定版本修改内容: git show <commit_id>，不指定commit_id时默认为HEAD

查看工作区当前修改: git diff [file], 如果不指定file则显示所有更改
查看工作区相对于指定版本区别: git diff <commit_id>
查看版本2相对于版本1区别: git diff <commit_id1> <commit_id2>
```

## 检出

```bash
# 检出单个文件的历史版本(版本不变，仅仅是文件内容变成检出版本)
git checkout <commit_id> test.txt
```

## 工作区与暂存区

```text
添加到暂存区: git add <file> 如果file是目录则添加该目录下所有文件
从暂存区移到工作区: git reset <file> 如果file是目录则针对该目录下所有文件，如果不指定file则针对暂存区所有文件
```

## 清理

```text
删除未添加到工作区和暂存区的文件: git clean -f [path]，不指定path时全部删除
如果目录也删除: git clean -fd [path]
撤销工作区单个文件修改: git checkout -- <file>
撤销工作区及暂存区所有文件修改: git reset --hard
```

## 回退

```text
checkout
    回退单个文件到指定版本: git checkout <commit_id> <file>
        commit_id处写 -- 表示撤销工作区的更改
reset
    回退本地仓库到指定版本: git reset [--hard] <commit_id>
        将HEAD回退到指定commit_id，不指定commit_id时默认为HEAD，即最新的commit
        --mixed: 默认值，会保留指定commit之后的所有更改到工作区(add之前)
        --hard: 将工作区的所有文件也回退到指定commit
        --soft: 会保留指定commit之后的所有更改到暂存区(add之后)
revert
    撤销指定commit: git revert <commit_id>
        revert不会回退版本树，而是产生一次新的提交记录，撤销后相关文件和指定commit前一次commit内容相同
        注意: revert仅仅回退这一次commit相关的文件，如果指定commit之后的commit也修改了这个文件会冲突，需要解决冲突并手动提交
```

## 远程

```text
添加远程仓库链接: git remote add <lib_name> https://test.com/test.git
修改远程仓库链接: git remote set-url <lib_name> <new_url>
删除远程仓库链接: git remote rm <lib_name>
删除远程仓库分支: git push --delete <lib_name> <branch_name>
远程仓库链接重命名: git remote rename <old_name> <new_name>
设置远程仓库链接时指定用户名: https://<user_name>@test.com/test.git

更新远程仓库: git fetch <lib_name>
将远程仓库的分支合并到当前分支: git rebase <lib_name>/<branch_name>
    如果发生冲突，解决冲突后add冲突文件，然后 git rebase --continue
    如果发生冲突后想放弃本地修改: git rebase --skip
    如果发生冲突后想放弃此次合并: git rebase --abort

重定向远程仓库链接
    git config --global url."https://new.git".insteadOf https://old.git

设置pull/push为当前分支：git config --global push.default "current"

```

## 换行符

```text
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
