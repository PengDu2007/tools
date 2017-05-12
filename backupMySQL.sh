#!/bin/bash
# 备份MySQL数据库
# @author ioioj5
# @version 0.2
# @date 2016/12/22


# 变量: 备份时间
DATE=`date +%Y%m%d`
FILENAME=`date +%Y%m%d%H`
# 昨天
#DATE=`date -d yesterday +%Y-%m-%d`

# 备份目录
BCK_DIR="/data/backup/databases"

# 设定需要备份的数据库名
DATABASES=(test01 test02)

LEN=${#DATABASES[@]} # 数组长度
if [ $LEN -gt 0 ]; then
	for DATABASE in ${DATABASES[*]};
	do
		echo "- ${DATABASE} -"
		if [ -d ${BCK_DIR}/${DATE} ]; then
			/data/server/mysql/bin/mysqldump --opt ${DATABASE} > ${BCK_DIR}/${DATE}/${DATABASE}_${FILENAME}.sql
		else
			mkdir -p ${BCK_DIR}/${DATE}
			/data/server/mysql/bin/mysqldump --opt ${DATABASE} > ${BCK_DIR}/${DATE}/${DATABASE}_${FILENAME}.sql
		fi
	done
fi

