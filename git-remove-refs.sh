#!/bin/bash

branch_name=$1

if test -z "$branch_name"; then
    echo "Usage: sh git-remove-refs.sh @branch_name"
    exit 1
fi

ref_file=".git/refs/remotes/origin/$branch_name"
log_file=".git/logs/refs/remotes/origin/$branch_name"

echo "---------------------------------------------------------------------"
echo "for current folder: "`pwd`
echo "---------------------------------------------------------------------"

echo "remove file $ref_file"
rm -f $ref_file
echo "remove file $log_file"
rm -f $log_file
