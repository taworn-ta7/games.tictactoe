const BlankCharacter = '\xA0'

const checkDrawState = (moves) => {
    return moves.every(item => item !== BlankCharacter)
}

const checkYVictory = (moves, boardSize, turnChar, y) => {
    let x = 0
    while (x < boardSize) {
        if (moves[y * boardSize + x] !== turnChar)
            return false
        x++
    }
    console.log(`${turnChar} win with y=${y}`)
    return true
}

const checkXVictory = (moves, boardSize, turnChar, x) => {
    let y = 0
    while (y < boardSize) {
        if (moves[y * boardSize + x] !== turnChar)
            return false
        y++
    }
    console.log(`${turnChar} win with x=${x}`)
    return true
}

const checkDiagonalVictory0 = (moves, boardSize, turnChar) => {
    let i = 0
    while (i < boardSize) {
        if (moves[i * boardSize + i] !== turnChar)
            return false
        i++
    }
    console.log(`${turnChar} win with direct diagonal`)
    return true
}

const checkDiagonalVictory1 = (moves, boardSize, turnChar) => {
    let i = 0
    while (i < boardSize) {
        if (moves[i * boardSize + (boardSize - i - 1)] !== turnChar)
            return false
        i++
    }
    console.log(`${turnChar} win with reverse diagonal`)
    return true
}

const checkVictoryState = (moves, boardSize, turnChar) => {
    // check horizontal
    for (let y = 0; y < boardSize; y++) {
        if (checkYVictory(moves, boardSize, turnChar, y))
            return true
    }

    // check vertical
    for (let x = 0; x < boardSize; x++) {
        if (checkXVictory(moves, boardSize, turnChar, x))
            return true
    }

    // check diagonal
    if (checkDiagonalVictory0(moves, boardSize, turnChar))
        return true
    if (checkDiagonalVictory1(moves, boardSize, turnChar))
        return true

    return false
}

module.exports = {
    BlankCharacter,
    checkDrawState,
    checkVictoryState,
}
