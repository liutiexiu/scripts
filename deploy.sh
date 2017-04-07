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

mvn $1 -Dmaven.test.skip=true clean package

if [ -d "target" ];then
  echo "compile done"
else
  echo "build fail"
  exit 1
fi

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
cd $TMP

rm -rf $DPL/${TAR%.*}-$TIME
unzip -q -d $DPL/${TAR%.*}-$TIME $TAR 

rm -f $BIN/$SRV
ln -s $DPL/${TAR%.*}-$TIME $BIN/$SRV

ls -al $BIN/$SRV

if [ -z HAS_WAR ];then
  echo "restart service please"
else
  /home/liushuai/bin/resin/bin/resin.sh --server $SRV kill
  sleep 1
  /home/liushuai/bin/resin/bin/resin.sh --server $SRV start
fi
