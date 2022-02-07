export default class Logic {

    constructor(boardSize, turnChar) {
        this.boardSize = boardSize
        this.turnChar = turnChar
    }

    think(moves, emptyChar) {
        const size = this.boardSize * this.boardSize
        const count = Math.random() * size % size
        let step = 0
        let i = 0
        while (step < count) {
            if (moves[i] === emptyChar) {
                step++
                if (step >= count) {
                    return i
                }
            }
            i++
            if (i >= size)
                i = 0
        }
    }

}
