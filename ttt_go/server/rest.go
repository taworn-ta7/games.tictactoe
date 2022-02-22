package main

import (
	"net/http"
	"strconv"
	"ttt/ttt"

	"github.com/gin-gonic/gin"
)

func getNext(c *gin.Context) {
	// get query 'first'
	first := c.Query("first")
	if !(first == "1" || first == "2") {
		c.String(http.StatusBadRequest, "first must be 1 or 2")
		return
	}
	f, _ := strconv.Atoi(first)

	// get query 'history'
	history := c.DefaultQuery("history", "")
	board, err := ttt.Load(f, history)
	if err != nil {
		c.String(http.StatusBadRequest, err.Error())
		return
	}

	// think about next move
	index := ThinkRandomMove(board)

	c.String(http.StatusOK, strconv.Itoa(index))
}
