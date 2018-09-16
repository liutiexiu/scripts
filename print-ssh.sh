#!/bin/bash

HOST=$1
CMD=$2

echo "$HOST"
echo "$CMD"

eval "ssh $HOST $CMD > result.$HOST.txt"

