package main

import (
	"fmt"
	"math/rand"
	"ttt/ttt"
)

func ThinkRandomMove(board *ttt.Board) int {
	// gather free move list into bucket
	bucket := []int{}
	l := len(board.MoveList)
	for i := 0; i < l; i++ {
		v := board.MoveList[i]
		if v <= 0 {
			bucket = append(bucket, i)
		}
	}

	// randomly choose one move
	v := rand.Intn(len(bucket))
	fmt.Printf("choose: %v, bucket: %v\n", v, bucket)
	return bucket[v]
}
