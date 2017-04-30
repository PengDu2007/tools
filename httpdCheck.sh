#!/bin/sh
# 监控httpd以及TCP状态
# @author ioioj5
# @version 0.1
# @date 2017/4/30
URL=""
HTTPCODE=`curl -o /dev/null -s -w "%{http_code}" "${URL}"`
DATE=`date +%c`
LOGDIR=/data/log/httpd/monitor

PROCESS_NUM=`ps aux | grep httpd | grep -v grep | wc -l`
SYN_NUM=`netstat -an | grep SYN_RECV | wc -l`
TIME_WAIT_NUM=`netstat -an | grep TIME_WAIT | wc -l` 
STATUS=`/etc/init.d/httpd status | grep -E "Server|Time|Total|CPU|requests"`
# httpd status
DIRNAME=`date +%Y/%m`
FILENAME=`date +%Y%m%d`
mkdir -p ${LOGDIR}/${DIRNAME}
cat >> /data/log/httpd/${DIRNAME}/httpdStatus${FILENAME}.log <<EOF
=================
TIME: ${DATE}
process: ${PROCESS_NUM}, SYN_RECV: ${SYN_NUM}, TIME_WAIT: ${TIME_WAIT_NUM}
-----------
${STATUS}
=================

EOF

if [ $HTTPCODE != '200' ]; then
	/etc/init.d/httpd restart
fi
