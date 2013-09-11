#!/bin/bash
#批量更改文件编码
#@author:woniu<peng_du2007@qq.com>
#@date : 2013-09-03

#检测参数
if [ $# -ne 1 ]; then
    echo "usage: $0 目录名称"
    exit 1
fi

if [ ! -d $1 ]; then
    echo "###################################"
    echo "error: $1不是一个目录"
    echo "usage: $0 目录名称"
    echo "###################################"
    exit 1
fi

#设定目录
directory=$1

loop_all=0 #循环全部文件数量
loop_php=0 #循环php文件数量
loop_html=0 #循环html文件数量
loop_replace=0 #循环替换文件数量

for dir in $(find $directory -type d); do
    #echo change to $dir
    #改变目录
    echo "---$dir"
    cd $dir
    for file in `ls $dir`; do
        #检测是否为文件
        if [ -f $file ]; then
            #转换文件编码为UTF-8
            if [ "${file##*.}" = "html" -o "${file##*.}" = "htm" -o "${file##*.}" = "php" -o "${file##*.}" = "phtml" ]; then
                enca -L zh_CN -x UTF-8 $file #转换文件编码
               #iconv -f $f_encoding -t $t_encoding $file -o $file
                echo -e "\t= 转换 =" $file
                if [ "${file##*.}" = "php" ]; then
                    loop_php=`expr $loop_php + 1` #计数
                else
                    loop_html=`expr $loop_html + 1` #计数
                fi
                loop_all=`expr $loop_all + 1` #计数
            fi
            
            ##gb2312,gbk替换成utf-8
            if [ "${file##*.}" = "html" -o "${file##*.}" = "htm" -o "${file##*.}" = "phtml" ];then
                sed -i 's/charset=gbk/charset=utf-8/g' $file
                sed -i 's/charset=gb2312/charset=utf-8/g' $file

                echo -e "\t= 替换 =" $file
                loop_replace=`expr $loop_replace + 1` #计数
            fi
        fi
    done
done

echo "======================================"

echo "总共转换文件: $loop_all 个,其中php文件: $loop_php, html,htm,phtml文件: $loop_html"

echo "总共替换文件(gbk,gb2312=>utf-8): $loop_replace 个"
echo "======================================"
cd $directory
