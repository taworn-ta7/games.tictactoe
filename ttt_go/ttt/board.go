package ttt

import (
	"errors"
	"fmt"
)

/// Player 1 and 2.
const (
	Player1 int = 1
	Player2 int = 2
)

/// State of current game.
const (
	Playing = iota
	Winner  = iota
	Draw    = iota
)

/// Constants.
const (
	BoardSize int = 3
	TotalSize int = BoardSize * BoardSize
)

/// Board data.
type Board struct {
	// move first
	MoveFirst int

	// current
	Current int

	// history moves
	History string

	// move list
	MoveList [9]int

	// state
	State int
}

// ----------------------------------------------------------------------

/// Move current marker to board.
func (board *Board) Move(index int) bool {
	if !(index >= 0 && index < TotalSize) {
		return false
	}

	// check with MoveList to see it already move there
	if board.MoveList[index] > 0 {
		return false
	}

	// add move
	board.History += string('0' + rune(index))
	board.MoveList[index] = board.Current

	// check move result
	if board.CheckVictoryState() {
		board.State = Winner
	} else if board.CheckDrawState() {
		board.State = Draw
	} else {
		// next player
		if board.Current == Player1 {
			board.Current = Player2
		} else {
			board.Current = Player1
		}
	}

	return true
}

/// Finish move and can check result in State.
func (board *Board) Finish() bool {
	return board.State != Playing
}

// ----------------------------------------------------------------------

func (board *Board) CheckYVictory(y int) bool {
	x := 0
	for x < BoardSize {
		if board.MoveList[y*BoardSize+x] != board.Current {
			return false
		}
		x++
	}
	fmt.Printf("Player %v win with y=%v\n", board.Current, y)
	return true
}

func (board *Board) CheckXVictory(x int) bool {
	y := 0
	for y < BoardSize {
		if board.MoveList[y*BoardSize+x] != board.Current {
			return false
		}
		y++
	}
	fmt.Printf("Player %v win with x=%v\n", board.Current, x)
	return true
}

func (board *Board) CheckDiagonalVictory0() bool {
	i := 0
	for i < BoardSize {
		if board.MoveList[i*BoardSize+i] != board.Current {
			return false
		}
		i++
	}
	fmt.Printf("Player %v win with direct diagonal\n", board.Current)
	return true
}

func (board *Board) CheckDiagonalVictory1() bool {
	i := 0
	for i < BoardSize {
		if board.MoveList[i*BoardSize+(BoardSize-i-1)] != board.Current {
			return false
		}
		i++
	}
	fmt.Printf("Player %v win with reverse diagonal\n", board.Current)
	return true
}

// ----------------------------------------------------------------------

/// Check victory.
func (board *Board) CheckVictoryState() bool {
	// check horizontal
	for y := 0; y < BoardSize; y++ {
		if board.CheckYVictory(y) {
			return true
		}
	}

	// check vertical
	for x := 0; x < BoardSize; x++ {
		if board.CheckXVictory(x) {
			return true
		}
	}

	// check diagonal
	if board.CheckDiagonalVictory0() {
		return true
	}
	if board.CheckDiagonalVictory1() {
		return true
	}

	return false
}

/// Check draw.
func (board *Board) CheckDrawState() bool {
	for i := range board.MoveList {
		if board.MoveList[i] <= 0 {
			return false
		}
	}
	return true
}

// ----------------------------------------------------------------------

/// Create new board.
func New(moveFirst int) (*Board, error) {
	if !(moveFirst >= Player1 && moveFirst <= Player2) {
		return nil, errors.New("parameter moveFirst must be Player1 or Player2")
	}

	this := Board{
		MoveFirst: moveFirst,
		Current:   moveFirst,
		History:   "",
		MoveList:  [9]int{0, 0, 0, 0, 0, 0, 0, 0, 0},
		State:     Playing,
	}
	return &this, nil
}

/// Load board from history.
func Load(moveFirst int, history string) (*Board, error) {
	if !(moveFirst >= Player1 && moveFirst <= Player2) {
		return nil, errors.New("parameter moveFirst must be Player1 or Player2")
	}

	p := moveFirst
	r := [9]int{0, 0, 0, 0, 0, 0, 0, 0, 0}
	l := len(history)
	for i := 0; i < l; i++ {
		c := history[i]
		if !(c >= '0' && c < '9') {
			return nil, errors.New("found unexpected character in history, only 0..8 allow")
		}

		// extract history and copy into MoveList
		v := int(c - '0')
		r[v] = p

		// next player
		if p == Player1 {
			p = Player2
		} else {
			p = Player1
		}
	}

	this := Board{
		MoveFirst: moveFirst,
		Current:   moveFirst,
		History:   history,
		MoveList:  r,
		State:     Playing,
	}

	if this.CheckVictoryState() || this.CheckDrawState() {
		return nil, errors.New("this game result is concluded")
	}

	return &this, nil
}
