#!/bin/sh
# 监控httpd以及TCP状态
# @author ioioj5
# @version 0.1
# @date 2017/4/30

# 设置检测的站点url
URL=""
# 获取站点http状态码
HTTPCODE=`curl -o /dev/null -s -w "%{http_code}" "${URL}"`
DATE=`date +%c`
# 设置日志保存目录
LOGDIR=/data/log/httpd/monitor

# httpd进程数
PROCESS_NUM=`ps aux | grep httpd | grep -v grep | wc -l`
# SYN数量
SYN_NUM=`netstat -an | grep SYN_RECV | wc -l`
# TIME_WAIT数量
TIME_WAIT_NUM=`netstat -an | grep TIME_WAIT | wc -l`
# httpd状态
STATUS=`/etc/init.d/httpd status | grep -E "Server|Time|Total|CPU|requests"`

# 日志
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

# 判断http状态码
if [ $HTTPCODE != '200' ]; then
	# 重启httpd
	/etc/init.d/httpd restart
fi
