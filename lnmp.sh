#!/bin/bash
# LNMP安装脚本
# @author ioioj5
# @version 0.2 20170705
# @date 2016/7/15

# 创建文件夹
mkdir -p /data/server
mkdir -p /data/log/nginx
mkdir -p /data/log/mysql
mkdir -p /data/log/php
mkdir -p /data/tools
mkdir -p /data/www

# 添加用户以及组
userdel www
groupadd www
useradd -g www -M -d /data/www -s /sbin/nologin www &> /dev/null
groupadd mysql
useradd -g mysql -s /sbin/nologin mysql

chown -R www:www /data/log
# 更新源
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
yum clean all && yum makecache && yum -y update

# 安装支持库以及工具
yum -y install wget gcc gcc-c++ gcc-g77 make libtool autoconf patch unzip automake libxml2 libxml2-devel ncurses ncurses-devel libtool-ltdl-devel libtool-ltdl libpng libpng-devel libjpeg-devel openssl openssl-devel curl curl-devel   ncurses ncurses-devel  libtool-ltdl libaio*i pcre pcre-devel tar vixie-cron zlib file  sharutils zip  bash vim cyrus-sasl-devel libmemcached libmemcached-devel libyaml libyaml-devel libvpx-devel  ImageMagick-devel gd-devel mcrypt mhash bzip2 bzip2-devel libjpeg freetype-devel bison net-tools

cd /data/tools/

# 安装nginx
wget http://nginx.org/download/nginx-1.11.13.tar.gz -O nginx-1.11.13.tar.gz

tar -xzvf nginx-1.11.13.tar.gz

cd nginx-1.11.13
./configure --prefix=/data/server/nginx --with-http_ssl_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_gzip_static_module --with-http_stub_status_module --with-debug

make && make install

# 配置nginx
chmod 775 /data/server/nginx/logs
chown -R www:www /data/server/nginx/logs
chmod -R 775 /data/www
chown -R www:www /data/www

# 安装php
wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm -O  /data/tools/epel-release-6-8.noarch.rpm
rpm -ivh /data/tools/epel-release-6-8.noarch.rpm && yum install -y libmcrypt libmcrypt-devel

cd /data/tools

wget http://cn2.php.net/get/php-5.6.30.tar.gz/from/this/mirror -O php-5.6.30.tar.gz
tar -xzvf php-5.6.30.tar.gz
cd php-5.6.30
./configure --prefix=/data/server/php --with-config-file-path=/data/server/php/etc --with-mysqli --with-pdo-mysql --with-iconv-dir --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir --enable-simplexml --enable-xml --disable-rpath --enable-bcmath --enable-soap --enable-zip --with-curl --enable-fpm --with-fpm-user=nobody --with-fpm-group=nobody --enable-mbstring --enable-sockets --with-mcrypt --with-gd --enable-gd-native-ttf --with-openssl --with-mhash --enable-opcache
make && make install

# 配置php
cp /data/tools/php-5.6.30/php.ini-development /data/server/php/etc/php.ini
## php.ini
sed -i 's#; extension_dir = \"\.\/\"#extension_dir = "/data/server/php/lib/php/extensions/no-debug-non-zts-20121212/"#'  /data/server/php/etc/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 64M/g' /data/server/php/etc/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 64M/g' /data/server/php/etc/php.ini
sed -i 's/;date.timezone =/date.timezone = Asia\/Shanghai/g' /data/server/php/etc/php.ini
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/g' /data/server/php/etc/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /data/server/php/etc/php.ini

install -v -m755 /data/tools/php-5.6.30/sapi/fpm/init.d.php-fpm  /etc/init.d/php-fpm

# 安装mysql
cd /data/tools/
wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.18-linux-glibc2.5-x86_64.tar.gz -O mysql-5.7.18-linux-glibc2.5-x86_64.tar.gz

tar -xzvf mysql-5.7.18-linux-glibc2.5-x86_64.tar.gz
mv /data/tools/mysql-5.7.18-linux-glibc2.5-x86_64 /data/server/mysql

# 配置mysql
/data/server/mysql/scripts/mysql_install_db --datadir=/data/server/mysql/data/ --basedir=/data/server/mysql --user=mysql
chown -R mysql:mysql /data/server/mysql/
chown -R mysql:mysql /data/server/mysql/data/
chown -R mysql:mysql /data/log/mysql

cp -f /data/server/mysql/support-files/mysql.server /etc/init.d/mysqld
sed -i 's#^basedir=$#basedir=/data/server/mysql#' /etc/init.d/mysqld
sed -i 's#^datadir=$#datadir=/data/server/mysql/data#' /etc/init.d/mysqld

cat > /etc/my.cnf <<END
[client]
port            = 3306
socket          = /tmp/mysql.sock
[mysqld]
port            = 3306
socket          = /tmp/mysql.sock
skip-external-locking
log-error=/data/log/mysql/mysql.log
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

# alter user 'root'@'localhost' identified by 'youpassword';  
# flush privileges;
