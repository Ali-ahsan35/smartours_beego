package main

import (
	_ "smartours/routers"
	"strings"

	beego "github.com/beego/beego/v2/server/web"
)

func main() {
	// Add custom template functions
    beego.AddFuncMap("mul", func(a, b float64) float64 {
        return a * b
    })
    beego.AddFuncMap("contains", func(s, substr string) bool {
        return strings.Contains(s, substr)
    })
	beego.Run()
}

