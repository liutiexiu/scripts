#!/bin/sh

if [ -f "pom.xml" ];then
  echo "compiling..."
else
  echo "bad dir"
  exit 1
fi

PRO=`ls *.iml`
SRV=${PRO%.*}
TMP="/tmp/build"
DPL="/home/mmears/deploy"
BIN="/home/mmears/bin"

mkdir -p $TMP

##build##
mvn $1 -Dmaven.test.skip=true clean package

if [ -d "target" ];then
  echo "compile done"
else
  echo "build fail"
  exit 1
fi

##find target##
cd target

#TIME=`date "+%Y%m%d_%H:%M:%S"`
TIME="local"

HAS_WAR=`ls | grep war`
TAR=""

if [ -z HAS_WAR ];then
  TAR=`ls *.jar`
else
  TAR=`ls *.war`
fi

echo "service:$SRV, target:$TAR"

rm -rf $TMP/*
cp $TAR $TMP

##deploy##
cd $TMP

scp $TAR onebox:$TMP

ssh onebox "rm -rf $DPL/${TAR%.*}-$TIME"
ssh onebox "cd $TMP;unzip -q -d $DPL/${TAR%.*}-$TIME $TAR"

ssh onebox "rm -f $BIN/$SRV"
ssh onebox "ln -s $DPL/${TAR%.*}-$TIME $BIN/$SRV"

ssh onebox "ls -al $BIN/$SRV"

if [ -z HAS_WAR ];then
  echo "restart service please"
else
  ssh onebox "\$HOME/bin/resin/bin/resin.sh --server $SRV kill"
  sleep 1
  ssh onebox "\$HOME/bin/resin/bin/resin.sh --server $SRV start"
fi
