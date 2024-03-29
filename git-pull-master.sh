#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # Color END

folder=$1
depth=$2

if (test -z "$folder"); then
    #echo "Usage: sh git-pull-master.sh @git-parent-folder [@depth]"
    echo "use current folder:`pwd`"
    folder=`pwd`
    #exit 1
fi

if (test -z "$depth"); then
    depth=3
fi

echo ""

function git_check_branch() {
    local target_branch=$1

    if (test -z "$target_branch"); then
        echo "Usage: git_check_branch @target_branch"
        exit 1
    fi

    local ref=$(git symbolic-ref HEAD 2> /dev/null) || return;
    local branch="${ref#refs/heads/}"
  
    if [[ $target_branch == $branch ]]; then
        return 0
    else
        return -1
    fi
}

function git_pull() {
    local target=$1
    local branch=$2
    local depth=$3
    
    if (test -z "$target") || (test -z "$branch") || (test -z "$depth"); then
        echo "Usage: git_pull @target-folder @branch @seek-depth"
    fi

    cd $target
    if [ -d ".git/" ];then
        git_check_branch "$branch"
        if [ $? -eq 0 ];then
            echo "pull $branch in `pwd`"
            git pull --rebase
            # if always push master
            diff=`git diff origin/master`
            if [ -n "$diff" ]; then
              echo "diff lines against origin/master    ${RED}=[`git diff origin/master | wc -l | xargs` lines]=${NC}"
              echo "recent commit: ${GREEN}`git log --pretty=oneline -1 | cut -d " " -f 2-`${NC}"
              echo ""
            fi
        fi
    else
        if [ $depth -gt 0 ];then
            for file in `ls $target`
            do
                cd $target
                if [ -d $file ];then
                    git_pull "$target/$file" "$branch" "$(($depth-1))"
                fi
            done
        fi
    fi
}

origin_work_path=`pwd`

git_pull "$folder" "master" "$depth"

cd $origin_work_path

#find rebase conflict
echo "============="
echo "git pull done"
echo ""

echo "git-st:(@ `date`)"
git-st.sh

exit 0
