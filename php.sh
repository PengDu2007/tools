#!/bin/bash
# LNMP安装脚本, 适用系统版本CentOS6.*
# php7 + nginx1.11.13 + mysql5.7
# @author ioioj5
# @version 2017/09/26 16:35:21

# 设置安装目录
dir=/data

# 创建文件夹
mkdir -p $dir/server
mkdir -p $dir/log/nginx
mkdir -p $dir/log/mysql
mkdir -p $dir/log/php
mkdir -p $dir/tools
mkdir -p $dir/www

# 添加用户以及组
# userdel www
groupadd www
useradd -g www -M -d $dir/www -s /sbin/nologin www &> /dev/null

chown -R www:www $dir/log
# 更新源
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
yum clean all && yum makecache && yum -y update

# 安装支持库以及工具
yum -y install wget gcc gcc-c++ gcc-g77 make libtool autoconf patch unzip automake libxml2 libxml2-devel ncurses ncurses-devel libtool-ltdl-devel libtool-ltdl libpng libpng-devel libjpeg-devel openssl openssl-devel curl curl-devel   ncurses ncurses-devel  libtool-ltdl libaio* pcre pcre-devel tar vixie-cron zlib file  sharutils zip  bash vim cyrus-sasl-devel libmemcached libmemcached-devel libyaml libyaml-devel libvpx-devel  ImageMagick-devel gd-devel mcrypt mhash bzip2 bzip2-devel libjpeg freetype-devel bison net-tools



# 安装php
wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm -O  $dir/tools/epel-release-6-8.noarch.rpm
rpm -ivh $dir/tools/epel-release-6-8.noarch.rpm
yum install -y libmcrypt libmcrypt-devel
#
cd $dir/tools
#
wget http://cn2.php.net/get/php-7.1.9.tar.gz/from/this/mirror -O php-7.1.9.tar.gz
tar -xzvf php-7.1.9.tar.gz
cd php-7.1.9
./configure --prefix=$dir/server/php --with-config-file-path=$dir/server/php/etc --with-mysqli --with-pdo-mysql --with-iconv-dir --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir --enable-simplexml --enable-xml --disable-rpath --enable-bcmath --enable-soap --enable-zip --with-curl --enable-fpm --with-fpm-user=www --with-fpm-group=www --enable-mbstring --enable-sockets --with-mcrypt --with-gd --enable-gd-native-ttf --with-openssl --with-mhash --enable-opcache
make && make install
#
## 配置php
cp $dir/tools/php-7.1.9/php.ini-development $dir/server/php/etc/php.ini
## php.ini
sed -i 's#; extension_dir = \"\.\/\"#extension_dir = "'$dir'/server/php/lib/php/extensions/no-debug-non-zts-20121212/"#'  $dir/server/php/etc/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 64M/g' $dir/server/php/etc/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 64M/g' $dir/server/php/etc/php.ini
sed -i 's/;date.timezone =/date.timezone = Asia\/Shanghai/g' $dir/server/php/etc/php.ini
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/g' $dir/server/php/etc/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 300/g' $dir/server/php/etc/php.ini

cp $dir/server/php/etc/php-fpm.conf.default $dir/server/php/etc/php-fpm.conf
cp $dir/server/php/etc/php-fpm.d/www.conf.default $dir/server/php/etc/php-fpm.d/www.conf

sed -i 's,user = nobody,user=www,g'   $dir/server/php/etc/php-fpm.d/www.conf
sed -i 's,group = nobody,group=www,g'   $dir/server/php/etc/php-fpm.d/www.conf
sed -i 's,^pm.min_spare_servers = 1,pm.min_spare_servers = 5,g'   $dir/server/php/etc/php-fpm.d/www.conf
sed -i 's,^pm.max_spare_servers = 3,pm.max_spare_servers = 35,g'   $dir/server/php/etc/php-fpm.d/www.conf
sed -i 's,^pm.max_children = 5,pm.max_children = 100,g'   $dir/server/php/etc/php-fpm.d/www.conf
sed -i 's,^pm.start_servers = 2,pm.start_servers = 20,g'   $dir/server/php/etc/php-fpm.d/www.conf
sed -i 's,;pid = run/php-fpm.pid,pid = run/php-fpm.pid,g'   $dir/server/php/etc/php-fpm.d/www.conf
sed -i 's,;error_log = log/php-fpm.log,error_log = '$dir'/log/php/php-fpm.log,g'   $dir/server/php/etc/php-fpm.d/www.conf
sed -i 's,;slowlog = log/$pool.log.slow,slowlog = '$dir'/log/php/\$pool.log.slow,g'   $dir/server/php/etc/php-fpm.d/www.conf

install -v -m755 $dir/tools/php-7.1.9/sapi/fpm/init.d.php-fpm  /etc/init.d/php-fpm
# 启动php-fpm
/etc/init.d/php-fpm start
sleep 5