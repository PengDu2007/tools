工具集
=====

## md2html.go
- 介绍

    把markdown转成html格式
  
- 安装

        go get github.com/russross/blackfriday
        go build md2html.go

- 用法

        md2html -f 文件名 //转换单个文件
        md2html -d 目录名 //转换整个目录

## iconv_charsets.sh
- 介绍
    
    批量更改网站文件编码(gbk,gb2312=>utf-8)

- 用法

        ./iconv_charsets.sh 目录名
