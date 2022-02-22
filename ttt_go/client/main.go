package main

import (
	"fmt"
	"io"
	"net/http"
	"strconv"

	"ttt/ttt"

	"github.com/eiannone/keyboard"
)

func ChoosePlayerFirst() int {
	for {
		fmt.Printf("Who move first? Press:\n")
		fmt.Printf("  - 1: Player 1\n")
		fmt.Printf("  - 2: Player 2 (Computer)\n")

		char, _, _ := keyboard.GetSingleKey()
		if char == '1' {
			fmt.Printf("You choose '1': Player 1.\n")
			return ttt.Player1
		}
		if char == '2' {
			fmt.Printf("You choose '2': Player 2 (Computer).\n")
			return ttt.Player2
		}
	}
}

func Output(board *ttt.Board) {
	fmt.Printf("\n")
	fmt.Printf("Current Board:\n")
	fmt.Printf("  First and Current: %v, %v\n", FormatWhoMove(board.MoveFirst), FormatWhoMove(board.Current))
	fmt.Printf("  History: %v\n", board.History)
	fmt.Printf("  MoveList: %v\n", board.MoveList)

	r := board.MoveList
	fmt.Printf("  %v|%v|%v\n", BoardDataToOX(r[0]), BoardDataToOX(r[1]), BoardDataToOX(r[2]))
	fmt.Printf("  -+-+-\n")
	fmt.Printf("  %v|%v|%v\n", BoardDataToOX(r[3]), BoardDataToOX(r[4]), BoardDataToOX(r[5]))
	fmt.Printf("  -+-+-\n")
	fmt.Printf("  %v|%v|%v\n", BoardDataToOX(r[6]), BoardDataToOX(r[7]), BoardDataToOX(r[8]))
	fmt.Printf("\n")
}

func BoardDataToOX(move int) string {
	if move == ttt.Player1 {
		return "O"
	} else if move == ttt.Player2 {
		return "X"
	} else {
		return " "
	}
}

func FormatWhoMove(move int) string {
	if move == ttt.Player1 {
		return "Player 1"
	} else if move == ttt.Player2 {
		return "Player 2"
	} else {
		return "unknown player, valid=1,2 input=%v"
	}
}

func MoveOnBoard(board *ttt.Board) {
	for {
		fmt.Printf("Which move? 1..9 valid\n")

		// get '1'..'9'
		char, _, _ := keyboard.GetSingleKey()
		index := int(char - '1')
		if !board.Move(index) {
			fmt.Printf("This move already taken or out of range! Choose another one.\n")
		} else {
			break
		}
	}
}

func AutoMove(board *ttt.Board) {
	for {
		uri := fmt.Sprintf("http://localhost:8080/ttt?first=%v&history=%v", board.MoveFirst, board.History)
		res, err := http.Get(uri)
		if err != nil {
			fmt.Printf("%v\n", err.Error())
			continue
		}

		// get move
		defer res.Body.Close()
		body, _ := io.ReadAll(res.Body)

		// move
		index, _ := strconv.Atoi(string(body))
		fmt.Printf("move from HTTP: %v\n", index)
		if !board.Move(index) {
			fmt.Printf("This move already taken or out of range! Choose another one.\n")
		} else {
			break
		}
		break
	}
}

func main() {
	whoFirst := ChoosePlayerFirst()
	fmt.Printf("Who first: %v\n", whoFirst)

	// create Tic-Tac-Toe board
	board, _ := ttt.New(whoFirst)

	// for game is not finish
	for !board.Finish() {
		Output(board)
		if board.Current == ttt.Player1 {
			// if player 1, get keyboard input from user
			MoveOnBoard(board)
		} else {
			// if player 2, computer, get HTTP
			AutoMove(board)
		}
	}

	Output(board)
	if board.State == ttt.Winner {
		if board.Current == ttt.Player1 {
			fmt.Printf("%v Win ^_^\n", BoardDataToOX(board.Current))
		} else {
			fmt.Printf("%v Win Y_Y\n", BoardDataToOX(board.Current))
		}
	} else {
		fmt.Printf("Draw -_-")
	}
}
