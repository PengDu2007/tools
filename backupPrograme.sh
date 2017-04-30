#!/bin/sh
# 备份程序
# @author ioioj5
# @version 0.1
# @date 2016/12/22
BACKUPTIME=`date +%Y%m%d_%H%M`
BACKUPDIR=/data/backup/programe

WWWDIR=/data/www

for DIR in $WWWDIR/*
do
	if [ -d $DIR ]; then
		echo "#> " ${DIR}
		ITEM=${DIR##*/}
		echo "#>> "${ITEM}
		#echo ${BACKUPTIME}
	    if [ -d ${BACKUPDIR}/${BACKUPTIME} ]; then
			echo $ITEM
			7za a $BACKUPDIR/$BACKUPTIME/$ITEM.7z $DIR	
		else
			mkdir -p $BACKUPDIR/$BACKUPTIME
			echo $ITEM
			7za a $BACKUPDIR/$BACKUPTIME/$ITEM.7z $DIR
		fi
	fi
done
