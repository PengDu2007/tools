## iconv_charsets.sh
- 介绍
    
    批量更改网站文件编码(gbk,gb2312=>utf-8)

- 安装

        sudo apt-get install enca
        #sudo apt-get install iconv
        
因为是利用enca或者iconv来进行文件编码转换,所以需要事先安装其中一个,推荐enca.

- 用法

        ./iconv_charsets.sh 目录名
