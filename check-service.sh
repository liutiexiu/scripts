#!/bin/bash

##################################
# check memory and start service #
##################################

PORT=8048

MEM=`free -g | grep "cache:" | awk '{print $4}'`
PID=`jps -lvm | grep Bootstrap | grep "PORT=${PORT}" | awk '{print $1}'`
LOG="/tmp/check-${PORT}.out"

if [[ (-z $PID) && ("$MEM" -gt "5") ]] ; then
    /home/web_server/liushuai/tomcat/bin/startup.sh >> ${LOG} 2>&1
    echo "restart at `date`" >> ${LOG}
    echo "" >> ${LOG}
fi
