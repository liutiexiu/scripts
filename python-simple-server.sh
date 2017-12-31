dir=`dirname $0`

cd $dir

nohup python -m SimpleHTTPServer 8070 &
