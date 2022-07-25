
# Git

## 编码

```text
设置编码: git config --global gui.encoding utf-8
禁止转义中文: git config core.quotepath false
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
设置远程仓库链接时指定用户名: https://<user_name>@test.com/test.git

更新远程仓库: git fetch <lib_name>
将远程仓库的分支合并到当前分支: git rebase <lib_name>/<branch_name>
    如果发生冲突，解决冲突后add冲突文件，然后 git rebase --continue
    如果发生冲突后想放弃本地修改: git rebase --skip
    如果发生冲突后想放弃此次合并: git rebase --abort

重定向远程仓库链接
    git config --global url."https://new.git".insteadOf https://old.git
```
