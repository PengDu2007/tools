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

cd $dir/tools/

# 配置nginx目录
chmod 775 $dir/server/nginx/logs
chown -R www:www $dir/server/nginx/logs
chmod -R 775 $dir/www
chown -R www:www $dir/www

# 安装nginx
wget http://nginx.org/download/nginx-1.11.13.tar.gz -O nginx-1.11.13.tar.gz

tar -xzvf nginx-1.11.13.tar.gz

cd nginx-1.11.13
./configure --prefix=$dir/server/nginx \
--user=www \
--group=www \
--error-log-path=$dir/server/nginx/logs/error.log \
--http-log-path=$dir/server/nginx/logs/access.log \
--with-http_ssl_module \
--with-http_realip_module \
--with-http_sub_module \
--with-http_dav_module \
--with-http_flv_module \
--with-http_gzip_static_module \
--with-http_stub_status_module \
--with-debug

make && make install

# 启动nginx
$dir/server/nginx/sbin/nginx -c $dir/server/nginx/conf/nginx.conf
# 关闭ngxin
# $dir/server/nginx/sbin/nginx -s stop
# reload
# $dir/server/nginx/sbin/nginx -s reload
sleep 5