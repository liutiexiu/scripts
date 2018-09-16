#!/bin/bash

let START=$1-1
END=$2
FILE=$3

sed "1,${START}d;${END}q" $FILE
