package main

import (
	"flag"
	"fmt"
	"github.com/russross/blackfriday"
	"io/ioutil"
	"os"
	"path/filepath"
	"regexp"
	"strings"
)

/* - 主函数 - */
func main() {
	file_name := flag.String("f", "", "文件名")
	dir_name := flag.String("d", "", "目录")

	flag.Parse()
	fmt.Println(*file_name)
	if *file_name != "" {
		is_file(*file_name)
	} else if *dir_name != "" {
		is_dir(*dir_name)
	} else {
		fmt.Printf("test\n")
	}
}

/* - 传入参数是文件(-f)- */
func is_file(file_name string) {
	/* - 读取文件 - */
	file, err := os.Open(file_name)
	if err != nil {
		panic(err)
	}
	defer file.Close()

	input, _ := ioutil.ReadAll(file)
	/* - 读取文件 - */

	/* - md=>html - */
	output := blackfriday.MarkdownCommon(input)

	/* - 打开文件句柄 - */
	var out *os.File
	if out, err = os.Create(strings.Replace(file_name, ".md", ".html", -1)); err != nil {
		fmt.Fprintf(os.Stderr, "Error creating %s: %v", file_name, err)
		os.Exit(-1)
	}
	defer out.Close()

	/* - 组织html数据 - */
	header := `
	<!doctype html>
	<html lang="en">
	<head>
		<meta charset="utf-8"/>
		<style>
			*{margin:0;padding:0;}
			body {
				 font:13.34px helvetica,arial,freesans,clean,sans-serif;
				 color:black;
				 line-height:1.4em;
				 background-color: #F8F8F8;
				 padding: 0.7em;
			}
			p {
				 margin:1em 0;
				 line-height:1.5em;
			}
			table {
				 font-size:inherit;
				 font:100%;
				 margin:1em;
			}
			table th{border-bottom:1px solid #bbb;padding:.2em 1em;}
			table td{border-bottom:1px solid #ddd;padding:.2em 1em;}
			input[type=text],input[type=password],input[type=image],textarea{font:99% helvetica,arial,freesans,sans-serif;}
			select,option{padding:0 .25em;}
			optgroup{margin-top:.5em;}
			pre,code{font:12px Menlo, Monaco, "DejaVu Sans Mono", "Bitstream Vera Sans Mono",monospace;}
			pre {
				 margin:1em 0;
				 font-size:12px;
				 background-color:#eee;
				 border:1px solid #ddd;
				 padding:5px;
				 line-height:1.5em;
				 color:#444;
				 overflow:auto;
				 -webkit-box-shadow:rgba(0,0,0,0.07) 0 1px 2px inset;
				 -webkit-border-radius:3px;
				 -moz-border-radius:3px;border-radius:3px;
			}
			pre code {
				 padding:0;
				 font-size:12px;
				 background-color:#eee;
				 border:none;
			}
			code {
				 font-size:12px;
				 background-color:#f8f8ff;
				 color:#444;
				 padding:0 .2em;
				 border:1px solid #dedede;
			}
			img{border:0;max-width:100%;}
			abbr{border-bottom:none;}
			a{color:#4183c4;text-decoration:none;}
			a:hover{text-decoration:underline;}
			a code,a:link code,a:visited code{color:#4183c4;}
			h2,h3{margin:1em 0;}
			h1,h2,h3,h4,h5,h6{border:0;}
			h1{font-size:170%;border-top:4px solid #aaa;padding-top:.5em;margin-top:1.5em;}
			h1:first-child{margin-top:0;padding-top:.25em;border-top:none;}
			h2{font-size:150%;margin-top:1.5em;border-top:4px solid #e0e0e0;padding-top:.5em;}
			h3{margin-top:1em;}
			hr{border:1px solid #ddd;}
			ul{margin:1em 0 1em 2em;}
			ol{margin:1em 0 1em 2em;}
			ul li,ol li{margin-top:.5em;margin-bottom:.5em;}
			ul ul,ul ol,ol ol,ol ul{margin-top:0;margin-bottom:0;}
			blockquote{margin:1em 0;border-left:5px solid #ddd;padding-left:.6em;color:#555;}
			dt{font-weight:bold;margin-left:1em;}
			dd{margin-left:2em;margin-bottom:1em;}
			sup {
			   font-size: 0.83em;
			   vertical-align: super;
			   line-height: 0;
			}
			* {
				 -webkit-print-color-adjust: exact;
			}
			@media screen and (min-width: 914px) {
			   body {
			      width: 854px;
			      margin:0 auto;
			   }
			}
			@media print {
				 table, pre {
					  page-break-inside: avoid;
				 }
				 pre {
					  word-wrap: break-word;
				 }
			}
		</style>
	</head>
	`
	footer := "</html>\n"
	out.Write([]byte(header))
	if _, err = out.Write(output); err != nil {
		fmt.Fprintln(os.Stderr, "Error writing output:", err)
		os.Exit(-1)
	}
	out.Write([]byte(footer))
}

/* - 传入参数是目录 - */
func is_dir(dir_name string) {
	filepath.Walk(dir_name,
		func(path string, f os.FileInfo, err error) error {
			if f == nil {
				return err
			}
			if f.IsDir() {
				return nil
			} else if (f.Mode() & os.ModeSymlink) > 0 {
				return nil
			} else {
				/*过滤目录中文件*/
				if strings.HasSuffix(f.Name(), ".md") {

					/* - 读取文件 - */
					file, err := os.Open(f.Name())
					if err != nil {
						panic(err)
					}
					defer file.Close()
					input, _ := ioutil.ReadAll(file)

					/* - 读取文件 - */

					/* - 正则匹配 - */
					input = regexp.MustCompile("\\[(.*?)\\]\\(<?(.*?)\\.md>?\\)").ReplaceAll(input, []byte("[$1](<$2.html>)"))
					output := blackfriday.MarkdownCommon(input)
					var out *os.File
					if out, err = os.Create(strings.Replace(path, ".md", ".html", -1)); err != nil {
						fmt.Fprintf(os.Stderr, "Error creating %s: %v", f.Name(), err)
						os.Exit(-1)
					}
					defer out.Close()
					header := "<!doctype html>\n<html lang=\"en\">\n<head>\n<meta charset=\"utf-8\"/>\n</head>\n"
					footer := "</html>\n"
					out.Write([]byte(header))
					if _, err = out.Write(output); err != nil {
						fmt.Fprintln(os.Stderr, "Error writing output:", err)
						os.Exit(-1)
					}
					out.Write([]byte(footer))
				}
			}
			return nil
		})
}
