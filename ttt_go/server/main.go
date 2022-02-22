package main

import (
	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()
	router.GET("/ttt", getNext)
	router.Run("localhost:8080")
}
