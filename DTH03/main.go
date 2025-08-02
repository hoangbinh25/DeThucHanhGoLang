package main

import (
	"path/filepath"

	"github.com/kataras/iris/v12"
)

func main() {
	app := iris.New()

	// Serve file audio
	app.HandleDir("/audio", "./uploads")

	app.Get("/", func(ctx iris.Context) {
		ctx.ServeFile("index.html")
	})

	app.Post("/upload", func(ctx iris.Context) {
		_, fileHeader, err := ctx.FormFile("audio")
		if err != nil {
			ctx.StatusCode(iris.StatusBadRequest)
			ctx.WriteString("Upload failed: " + err.Error())
			return
		}

		dst := filepath.Join("uploads", fileHeader.Filename)
		_, err = ctx.SaveFormFile(fileHeader, dst)
		if err != nil {
			ctx.StatusCode(iris.StatusInternalServerError)
			ctx.WriteString("Lưu file thất bại: " + err.Error())
			return
		}

		ctx.WriteString(fileHeader.Filename)
	})

	app.Listen(":8080")
}
