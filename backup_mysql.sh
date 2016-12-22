#!/bin/sh
#!/bin/bash
# 备份MySQL数据库
# @author ioioj5
# @version 0.1
# @date 2016/12/22

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
