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
	if *file_name != "" {
		is_file(*file_name)
	} else if *dir_name != "" {
		is_dir(*dir_name)
	} else {
		//fmt.Printf("test")
	}
}

/* - 传入参数是文件(-f)- */
func is_file(file_name string) {
	/* - 读取文件 - */
	file, err := os.Open(file_name)
	if err != nil {
		panic(err)
	}
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
	header := "<!doctype html>\n<html lang=\"en\">\n<head>\n<meta charset=\"utf-8\"/>\n</head>\n"
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
