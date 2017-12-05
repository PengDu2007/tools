#!/bin/bash
# LNMP安装脚本, 适用系统版本CentOS6.*
# php7 + nginx1.11.13 + mysql5.7
# @author ioioj5
# @version 2017/09/26 16:35:21

# 设置安装目录
dir=/opt

# 创建文件夹
mkdir -p $dir/server
mkdir -p $dir/log/mysql
mkdir -p $dir/tools

# 添加用户以及组
groupadd mysql
useradd -g mysql -s /sbin/nologin mysql

# 更新源
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
yum clean all && yum makecache && yum -y update

# 安装支持库以及工具
yum -y install wget gcc gcc-c++ gcc-g77 make libtool autoconf patch unzip automake libxml2 libxml2-devel ncurses ncurses-devel libtool-ltdl-devel libtool-ltdl libpng libpng-devel libjpeg-devel openssl openssl-devel curl curl-devel ncurses ncurses-devel  libtool-ltdl libaio* pcre pcre-devel tar vixie-cron zlib file  sharutils zip  bash vim cyrus-sasl-devel libmemcached libmemcached-devel libyaml libyaml-devel libvpx-devel  ImageMagick-devel gd-devel mcrypt mhash bzip2 bzip2-devel libjpeg freetype-devel bison net-tools

# 安装mysql
cd $dir/tools/
wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.18-linux-glibc2.5-x86_64.tar.gz -O mysql-5.7.18-linux-glibc2.5-x86_64.tar.gz

tar -xzvf mysql-5.7.18-linux-glibc2.5-x86_64.tar.gz
mv $dir/tools/mysql-5.7.18-linux-glibc2.5-x86_64 $dir/server/mysql

# 配置mysql
$dir/server/mysql/bin/mysqld --initialize --datadir=$dir/server/mysql/data/ --basedir=$dir/server/mysql --user=mysql
chown -R mysql:mysql $dir/server/mysql/
chown -R mysql:mysql $dir/server/mysql/data/
chown -R mysql:mysql $dir/log/mysql
touch $dir/log/mysql/error.log
chown mysql.mysql $dir/log/mysql/error.log
chmod 775 $dir/log/mysql/error.log

cp -f $dir/server/mysql/support-files/mysql.server /etc/init.d/mysqld
sed -i 's#^basedir=$#basedir='$dir'/server/mysql#' /etc/init.d/mysqld
sed -i 's#^datadir=$#datadir='$dir'/server/mysql/data#' /etc/init.d/mysqld

cat > /etc/my.cnf <<END
[client]
port            = 3306
socket          = /tmp/mysql.sock
[mysqld]
basedir         = $dir/server/mysql
datadir         = $dir/server/mysql/data
port            = 3306
socket          = /tmp/mysql.sock
skip-external-locking
log-error=$dir/log/mysql/error.log
key_buffer_size = 16M
max_allowed_packet = 1M
table_open_cache = 64
sort_buffer_size = 512K
net_buffer_length = 8K
read_buffer_size = 256K
read_rnd_buffer_size = 512K
myisam_sort_buffer_size = 8M

log-bin=mysql-bin
binlog_format=mixed
server-id       = 1

sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES

[mysqldump]
quick
max_allowed_packet = 16M

[mysql]
no-auto-rehash

[myisamchk]
key_buffer_size = 20M
sort_buffer_size = 20M
read_buffer = 2M
write_buffer = 2M

[mysqlhotcopy]
interactive-timeout
expire_logs_days = 5
max_binlog_size = 1000M
END

chmod 755 /etc/init.d/mysqld
/etc/init.d/mysqld start
# alter user 'root'@'localhost' identified by '123456';  
# flush privileges;