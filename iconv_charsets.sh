#!/bin/bash
#批量更改文件编码
#@author:woniu<peng_du2007@qq.com>
#@date : 2013-09-03

#设定目录
directory=$1

loop_all=0
loop_php=0
loop_html=0
loop_replace=0

for dir in $(find $directory -type d); do
    #echo change to $dir
    #改变目录
    echo "---$dir"
    cd $dir
    for file in `ls $dir`; do
        #检测是否为文件
        if [ -f $file ]; then
            #iconv -f $f_encoding -t $t_encoding $file -o $file
            #转换文件编码为UTF-8
            if [ "${file##*.}" = "html" -o "${file##*.}" = "htm" -o "${file##*.}" = "php" -o "${file##*.}" = "phtml" ]; then
                enca -L zh_CN -x UTF-8 $file
                echo -e "\t= 转换 =" $file
                if [ "${file##*.}" = "php" ]; then
                    loop_php=`expr $loop_php + 1`
                else
                    loop_html=`expr $loop_html + 1`
                fi
                loop_all=`expr $loop_all + 1`
            fi
            
            ##gb2312,gbk替换成utf-8
            if [ "${file##*.}" = "html" -o "${file##*.}" = "htm" -o "${file##*.}" = "phtml" ];then
                sed -i 's/charset=gbk/charset=utf-8/g' $file
                sed -i 's/charset=gb2312/charset=utf-8/g' $file

                echo -e "\t= 替换 =" $file
                loop_replace=`expr $loop_replace + 1`
            fi
        fi
    done
done

echo "======================================"

echo "总共转换文件: $loop_all 个,其中php文件: $loop_php, html,htm,phtml文件: $loop_html"

echo "总共替换文件(gbk,gb2312=>utf-8): $loop_replace 个"
echo "======================================"
cd $directory
