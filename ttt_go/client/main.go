package main

import (
	"fmt"

	"github.com/astaxie/beego/config"
	"github.com/eiannone/keyboard"
)

/// Return host to connect.
func ReadConfig() string {
	// read configuration file
	conf, _ := config.NewConfig("ini", "config.ini")
	host := conf.DefaultString("host", "http://127.0.0.1:8080")
	fmt.Printf("host: %v\n", host)
	return host
}

func ChoosePlayerOrComputerFirst() int {
	for {
		fmt.Printf("Who move first?\n")
		fmt.Printf("  1. Player\n")
		fmt.Printf("  2. Computer\n")

		char, _, _ := keyboard.GetSingleKey()
		if char == 49 {
			fmt.Printf("You choose '1': Player.\n")
			return Player
		}
		if char == 50 {
			fmt.Printf("You choose '2': Computer.\n")
			return Computer
		}
	}
}

func Output(board *Board) {
	// print current board status
	fmt.Printf("Current Board:\n")
	fmt.Printf("  First and Current: %v, %v\n", FormatWhoMove(board.MoveFirst), FormatWhoMove(board.Current))
	fmt.Printf("  History: %v\n", board.History)

	r := board.MoveList
	fmt.Printf("  %v|%v|%v\n", string(r[0]), string(r[1]), string(r[2]))
	fmt.Printf("  -+-+-\n")
	fmt.Printf("  %v|%v|%v\n", string(r[3]), string(r[4]), string(r[5]))
	fmt.Printf("  -+-+-\n")
	fmt.Printf("  %v|%v|%v\n", string(r[6]), string(r[7]), string(r[8]))
	fmt.Printf("\n")
}

func FormatWhoMove(move int) string {
	if move == Player {
		return "Player"
	} else if move == Computer {
		return "Computer"
	} else {
		return "unknown player, valid=0,1 input=%v"
	}
}

func MoveOnBoard(board *Board) {
	for {
		fmt.Printf("Which move? 0..8 valid\n")

		// get '0'..'8'
		char, _, _ := keyboard.GetSingleKey()
		index := int(char - '0')
		if !board.Move(index) {
			fmt.Printf("This move already taken or out of range! Choose another one.\n")
		} else {
			break
		}
	}
}

func main() {
	//host := ReadConfig()

	computerFirst := ChoosePlayerOrComputerFirst()
	fmt.Printf("computerFirst: %v\n", computerFirst)

	board := NewBoard(computerFirst)

	for !board.Finish() {
		Output(&board)
		MoveOnBoard(&board)
	}
}
