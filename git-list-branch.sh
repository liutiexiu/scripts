#!/bin/bash

FOLDER=$1
DEPTH=$2

if (test -z "$FOLDER"); then
    #echo "Usage: sh git-list-branch.sh @git-parent-folder [@depth]"
    #echo "use current folder:`pwd`"
    FOLDER=`pwd`
fi

if (test -z "$DEPTH"); then
    DEPTH=2
    #echo "set depth:$DEPTH"
fi

function git_list_branch_() {
    local target=$1
    local depth=$2
    
    if (test -z "$target") || (test -z "$depth"); then
        echo "Usage: git_branch @target-folder @seek-depth"
    fi

    cd $target
    if [ -d ".git/" ];then
        local count=`git branch | wc -l`
        local stash_count=`git stash list | wc -l`
        if [ $count -gt 1 -o $stash_count -gt 0 ];then
            echo "repository: `pwd | awk -F "$origin_work_path" '{print $2}' | sed -e 's/^\///g'`"
            git branch
            git stash list
            echo ""
        fi
    else
        if [ $depth -gt 0 ];then
            for file in `ls $target`
            do
                cd $target
                if [ -d $file ];then
                    git_list_branch_ "$target/$file" "$(($depth-1))"
                fi
            done
        fi
    fi
}

origin_work_path=`pwd`

git_list_branch_ "$FOLDER" "$DEPTH"

cd $origin_work_path

exit 0
