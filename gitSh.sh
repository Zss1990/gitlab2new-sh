
#!/bin/bash

# 修改当前路径下项目的，各个分支最后提交账户为“shuaishuai.zhu”，防止部分分支无法push到新仓的情况
function change_last_commit_account ()
{
  # 遍历所有分支
  # for branch in $(git branch --list | grep -v "HEAD detached" | grep "[^* ]+" -oE); do
  #     # git log --oneline "$branch" ^origin/master
  #     echo "分支：$branch"
  # done
  for branch in $(git rev-parse --symbolic --branches); do
      # git log --oneline "$branch" ^origin/master
    echo "-->分支：$branch"
    git checkout $branch
    get_cur_branch=`git symbolic-ref --short -q HEAD`
    echo "切到分支：$get_cur_branch"

    git_last_commit_id=$(git rev-parse HEAD)
    git_last_commit_account=$(git log --pretty=format:“%an” ${git_last_commit_id} -1)
    
    echo "最后提交：$git_last_commit_account"

    me_git_account='“shuaishuai.zhu”'

    echo $me_git_account
    if [[ "$git_last_commit_account" != "$me_git_account" ]];then
      echo "最近提交者不是我：$git_last_commit_account"

      git pull origin $get_cur_branch
      #新建一个文件,刷新下提交记录账户
      touch "git_push_test_remove_me.txt"
      git add .
      git commit -m '新建一个文件,刷新下提交记录账户，用于迁移'
      git push origin $get_cur_branch
      git pull origin $get_cur_branch
    fi
  done

  #切回master
  git checkout master
}

function gitlab_old_to_new ()
{
    # 读取shell窗口输入的内容并赋值给变量project_name
  # read project_name
  project_name=$1
  old_gitla=$2
  new_gitla=$3
  echo "~~~~~~~~gitExt~>${project_name} ${old_gitla} ${new_gitla}"

  [ ! $project_name ] && return
  [ ! $old_gitla ] && return
  [ ! $new_gitla ] && return


  project_name_path="./gitData/${project_name}"
  mkdir ${project_name_path}
  git clone $old_gitla  ${project_name_path}

    # 进入项目目录
  cd ${project_name_path}
  pwd

  # 将项目的所有分支check到本地
  git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done
  # 下面的fetch 和 pull应该执行一条即可，自行测试
  # git fetch --all
  git pull --all
  pwd

  #修改各个分支最近为我的
  change_last_commit_account

  git remote -v
  git remote remove origin
  git remote add origin ${new_gitla}
  git remote -v

  # gitlab地址替换成为新gitlab地址
  # git remote set-url origin ${new_gitla}:

  # git add .
  # git commit -m 'git新库迁移' --amend --reset-author --no-edit

  # 将所有分支push到新的远程服务器
  git push --all

  # 推送标签
  git push --tags 

  cd "../.."
  pwd
}

# #### 遍历json转为数组
# 目标数据格式： projects = ('url1 newurl1' url2 newurl2')
# configs=`cat gitConfig.json`
count=$( jq '. | length' gitConfig.json)
for ((i = 0; i < $count; i++))
do 
    # 使用jq工具从json中逐项提取url，jq测试https://jqplay.org/  -r取消双引号保留原始数据
    project_name=$(cat gitConfig.json | jq -r ".[${i}].project_name")
    old_gitla=$(cat gitConfig.json | jq -r ".[${i}].old_gitla")
    new_gitla=$(cat gitConfig.json | jq -r ".[${i}].new_gitla")

    # echo "--${project_name} --- ${old_gitla} ---- ${new_gitla}"
    # 执行clone&push 略
  gitlab_old_to_new ${project_name} ${old_gitla} ${new_gitla}

  
done


