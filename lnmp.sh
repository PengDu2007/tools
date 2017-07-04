#!/bin/bash
# LNMP安装脚本
# @author ioioj5
# @TODO 通过脚本配置服务
# @version 0.2 20170705
# @date 2016/7/15

mkdir -p /data/server
mkdir -p /data/log
mkdir -p /data/tools

# 更新源
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
yum clean all && yum makecache && yum update

# 安装支持库以及工具
yum -y install wget gcc gcc-c++ gcc-g77 make libtool autoconf patch unzip automake libxml2 libxml2-devel ncurses ncurses-devel libtool-ltdl-devel libtool-ltdl libmcrypt libmcrypt-devel libpng libpng-devel libjpeg-devel openssl openssl-devel curl curl-devel   ncurses ncurses-devel  libtool-ltdl libaio*i pcre pcre-devel tar vixie-cron zlib file  sharutils zip  bash vim cyrus-sasl-devel libmemcached libmemcached-devel libyaml libyaml-devel libvpx-devel  ImageMagick-devel gd-devel mcrypt mhash bzip2 bzip2-devel libjpeg freetype-devel bison net-tools

# 安装nginx
wget http://nginx.org/download/nginx-1.11.13.tar.gz -O /data/tools/nginx-1.11.13.tar.gz
tar -xzvf /data/tools/nginx-1.11.13.tar.gz

/data/tools/nginx-1.11.13/configure --prefix=/data/server/nginx --with-http_ssl_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_gzip_static_module --with-http_stub_status_module --with-debug
make && make install

# 配置nginx
# ...

# 安装php
wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm -O  /data/tools/epel-release-6-8.noarch.rpm
rpm -ivh /data/tools/epel-release-6-8.noarch.rpm

wget http://cn2.php.net/get/php-5.6.30.tar.gz/from/this/mirror -O /data/tools/php-5.6.30.tar.gz
tar -xzvf /data/tools/php-5.6.30.tar.gz

/data/tools/php-5.6.30/configure --prefix=/data/server/php --with-mysqli --with-pdo-mysql --with-iconv-dir --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir --enable-simplexml --enable-xml --disable-rpath --enable-bcmath --enable-soap --enable-zip --with-curl --enable-fpm --with-fpm-user=nobody --with-fpm-group=nobody --enable-mbstring --enable-sockets --with-mcrypt --with-gd --enable-gd-native-ttf --with-openssl --with-mhash --enable-opcache
make && make install

# 配置php
# ...

# 安装mysql
wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.18-linux-glibc2.5-x86_64.tar.gz -O /data/tools/mysql-5.7.18-linux-glibc2.5-x86_64.tar.gz

tar -xzvf /data/tools/mysql-5.7.18-linux-glibc2.5-x86_64.tar.gz
mv /data/tools/mysql-5.7.18-linux-glibc2.5-x86_64 /data/server/mysql

# 配置mysql
# ...

