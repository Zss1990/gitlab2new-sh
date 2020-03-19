# gitlab2new-sh
根据配置文件迁移gitlab到新仓库shell脚本
# 简介
通过脚本完成，从老的gitlab仓库迁移代码到新的gitlab仓库，包括所有的分支、tag、提交记录的迁移；
# 使用
## 配置
### 1. 配置`gitConfig.json`,把需要迁移的项目库配置进去
```
[
    {
        "project_name":"这里写仓库名称",
        "old_gitla":"这里写项目老的gitlab地址",
        "new_gitla":"这里写项目新的gitlab地址"
    },
    {
        "project_name":"xxxx",
        "old_gitla":"https://xxxx/xxx.git",
        "new_gitla":"https://xxx/xxxx.git"
    }

]
```
注意：`gitConfig.json`是校准的json文件格式！
### 2. 配置脚本`gitSh.sh`方法`change_last_commit_account`里面默认的账户名字
```
    me_git_account='“shuaishuai.zhu”'

```
`change_last_commit_account`方法会检查如果老仓库最近他提交不是该账户，则会进行新建一个临时文件`git_push_test_remove_me.txt`进行一次老仓库的提交；这么做的目的是为了，解决部分仓库的分支提交不上去的问题：
如提交release分支失败报错：
```
➜  iOS-xxxKit git:(master) git push origin release
Total 0 (delta 0), reused 0 (delta 0)
remote: AD Account:  otherAccount 
remote: 提交失败！！!
remote: 请使用 git config user.name <your_ad_account> 将提交人设置为域账号并重新 commit
To https://gitlabnewxxxxx.git
 ! [remote rejected] release -> release (pre-receive hook declined)
error: failed to push some refs to 'https://gitlabnewxxxxx.git'
```

### 执行
cd到sh脚本所在目录，执行`sh gitSh.sh`

## 结束啦！打开新仓库吧！
