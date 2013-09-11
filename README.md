工具集
=====

## md2html
- 介绍

    把markdown转成html格式
  
- 安装

    go get github.com/russross/blackfriday
    go build md2html.go

- 用法

    md2html -f 文件名 //转换单个文件
    md2html -d 目录名 //转换整个目录
