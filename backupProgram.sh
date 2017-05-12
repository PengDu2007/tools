#!/bin/bash
# 备份程序
# @author ioioj5
# @version 0.2
# 需要安装7zip
# @date 2016/12/22

# 设置备份时间
BACKUPTIME=`date +%Y%m%d`
# 设置备份路径
BACKUPDIR=/data/backup/programe

# 设置目标目录(要备份的目录)
WWWDIR=/data/www/
# 设置排除目录, 如多个用空格分割
EXCLUDEDIR=(test.local)

for DIR in $WWWDIR/*
do
	if [ -d $DIR ]; then
		echo "#> " ${DIR}
		ITEM=${DIR##*/}
		echo "#>> "${ITEM}
		for i in ${EXCLUDEDIR};
		do
			if [ $i != $ITEM ]; then
				if [ -d ${BACKUPDIR}/${BACKUPTIME} ]; then
					echo $ITEM
					/usr/local/bin/7za a $BACKUPDIR/$BACKUPTIME/$ITEM.7z $DIR
				else
					mkdir -p $BACKUPDIR/$BACKUPTIME
					echo $ITEM
					/usr/local/bin/7za a $BACKUPDIR/$BACKUPTIME/$ITEM.7z $DIR
				fi
			fi
		done
	fi
done
