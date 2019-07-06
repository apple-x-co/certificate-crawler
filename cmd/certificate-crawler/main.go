package main

import (
	certificate_crawler "apple-x-co/certificate-crawler"
	"fmt"
	"os"
)

func main() {
	err := certificate_crawler.Crawl()
	if err != nil {
		fmt.Printf("error %+v\n", err)
		os.Exit(1)
	}
	os.Exit(0)
}
