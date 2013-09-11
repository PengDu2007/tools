## md2html.go
- 介绍

    把markdown转成html格式
  
- 安装以及编译

        go get github.com/russross/blackfriday
        go build md2html.go

- 用法

        md2html -f 文件名 //转换单个文件
        md2html -d 目录名 //转换整个目录

## iconv_charsets.sh
- 介绍
    
    批量更改网站文件编码(gbk,gb2312=>utf-8)

- 安装

        sudo apt-get install enca
        #sudo apt-get install iconv
        
因为是利用enca或者iconv来进行文件编码转换,所以需要事先安装其中一个,推荐enca.

- 用法

        ./iconv_charsets.sh 目录名
