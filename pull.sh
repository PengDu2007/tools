#!/bin/bash
# 备份服务器拉取备份数据
# author ioioj5
# version 0.1
# 2017-01-22

# 设置全局变量
BACKUPDIR=/data/backup/
DATABASEDIR=$BACKUPDIR/database
PROGRAMEDIR=$BACKUPDIR/programe

# 拉取时间
DATE=`date +%Y%m%d_%H%M%S`
FILENAME=`date +%Y%m%d`

# 拉取
# 1. 程序
scp  -C -P 端口 -r root@IP地址:/data/backup/programe/${FILENAME} ${PROGRAMEDIR}

# 2. 数据库
scp  -C -P 端口 -r root@IP地址:/data/backup/databases/${FILENAME} ${DATABASEDIR}
