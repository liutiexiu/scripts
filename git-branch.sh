#!/bin/bash

TARGET=$1
FOLDER=$2
DEPTH=$3

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # Color END

if (test -z "$TARGET"); then
    TARGET="master"
fi
echo "checking if branch is [$TARGET]"

if (test -z "$FOLDER"); then
    #echo "Usage: sh git-branch.sh @branch-name @git-parent-folder [@depth]"
    #echo "use current folder:`pwd`"
    FOLDER=`pwd`
fi

if (test -z "$DEPTH"); then
    DEPTH=2
    #echo "set depth:$DEPTH"
fi

echo ""

function git_branch_() {
    local target=$1
    local depth=$2
    
    if (test -z "$target") || (test -z "$depth"); then
        echo "Usage: git_branch @target-folder @seek-depth"
    fi

    cd $target
    if [ -d ".git/" ];then
        local ref=$(git symbolic-ref HEAD 2> /dev/null) || return;
        local branch="${ref#refs/heads/}"
        local relative=`echo "$target" | rev | cut -d '/' -f -$[$DEPTH-$depth] | rev`
        local status=`git status -b --porcelain`
        local is_master=`echo $status | grep master | grep -v ahead`
        if (test -z "$is_master");then
            echo "${RED}$relative:${NC}\n$status\n"
        fi
    else
        if [ $depth -gt 0 ];then
            for file in `ls $target`
            do
                cd $target
                if [ -d $file ];then
                    git_branch_ "$target/$file" "$(($depth-1))"
                fi
            done
        fi
    fi
}

origin_work_path=`pwd`

git_branch_ "$FOLDER" "$DEPTH"

cd $origin_work_path

exit 0
