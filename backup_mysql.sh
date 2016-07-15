#!/bin/sh
#######################################
# 备份MySQL数据库
#######################################
# 配置MySQL数据库账号与密码
DB_USER="数据库账号"
DB_PASS="数据库账号密码"

# 变量: 日期
DATE=`date +%c`

# 变量: 昨天
DATE_YESTERDAY=`date -d yesterday +%Y-%m-%d`

# 备份目录
BCK_DIR="/data/backup/db/"

## TODO
echo '== START == '

echo '- test - '

/data/server/mysql/bin/mysqldump --opt test > $BCK_DIR/test_$DATE_YESTERDAY.sql

echo '== END =='
