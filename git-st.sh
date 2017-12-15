#!/bin/bash

FOLDER=$1
DEPTH=$2

if (test -z "$FOLDER"); then
    #echo "Usage: sh git-st.sh @git-parent-folder [@depth]"
    echo "use current folder:`pwd`"
    FOLDER=`pwd`
fi

if (test -z "$DEPTH"); then
    DEPTH=2
    echo "set depth:$DEPTH"
fi

echo ""

function git_st_() {
    local target=$1
    local depth=$2
    
    if (test -z "$target") || (test -z "$depth"); then
        echo "Usage: git_st @target-folder @seek-depth"
    fi

    cd $target
    if [ -d ".git/" ];then
        local result=`git st`
        if (test -n "$result");then
            local ref=$(git symbolic-ref HEAD 2> /dev/null) || return;
            local branch="${ref#refs/heads/}"
            local relative=`echo "$target" | rev | cut -d '/' -f -$[$DEPTH-$depth] | rev`
            echo "$relative($branch):"
            git st
            echo ""
        fi
    else
        if [ $depth -gt 0 ];then
            for file in `ls $target`
            do
                cd $target
                if [ -d $file ];then
                    git_st_ "$target/$file" "$(($depth-1))"
                fi
            done
        fi
    fi
}

origin_work_path=`pwd`

git_st_ "$FOLDER" "$DEPTH"

cd $origin_work_path

exit 0
