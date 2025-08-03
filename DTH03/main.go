package main

import (
	"github.com/kataras/iris/v12"
)

func main() {
	app := iris.New()

	// Serve file audio
	app.HandleDir("/audio", "./uploads")

	app.Get("/", func(ctx iris.Context) {
		ctx.ServeFile("index.html")
	})

	app.Listen(":8080")
}
