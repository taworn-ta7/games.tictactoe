package main

const (
	Player   int = 0
	Computer int = 1
)

type Board struct {
	// move first
	MoveFirst int

	// current
	Current int

	// history moves
	History string

	// move list
	MoveList [9]rune
}

func (board *Board) Move(index int) bool {
	if index < 0 || index > 8 {
		return false
	}

	// check with MoveList to see it already move there
	if board.MoveList[index] != ' ' {
		return false
	}

	// add move
	board.History += string('0' + index)
	board.MoveList[index] += board.PlayerToOX()

	// next player
	if board.Current == Player {
		board.Current = Computer
	} else {
		board.Current = Player
	}
	return true
}

func (board *Board) PlayerToOX() rune {
	if board.Current == Player {
		return 'O'
	} else {
		return 'X'
	}
}

func (board *Board) Finish() bool {
	return len(board.History) >= 9
}

/// Create new board.
func NewBoard(moveFirst int) Board {
	this := Board{
		MoveFirst: moveFirst,
		Current:   moveFirst,
		History:   "",
		MoveList:  [9]rune{' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
	}
	return this
}
