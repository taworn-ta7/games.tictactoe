import React from 'react'
import { useParams } from "react-router-dom"
import AppBox from '../layouts/AppBox'
import boardHelper from '../libs/board_helper'
import Logic from '../libs/Logic'
import classes from './GamePage.module.css'

export default function GamePage(props) {
    // router
    const params = useParams()

    // parameters
    const boardSize = Math.floor(params.boardSize)
    const logic0 = params.player1 === 'computer' ? new Logic(boardSize, 'O') : null
    const logic1 = params.player2 === 'computer' ? new Logic(boardSize, 'X') : null

    // states
    const [reload, setReload] = React.useState(0)
    const [win, setWin] = React.useState(false)
    const [draw, setDraw] = React.useState(false)
    const [turn, setTurn] = React.useState(0)
    const [moves, setMoves] = React.useState(Array(boardSize * boardSize).fill(boardHelper.BlankCharacter))

    // events
    const handleClick = (e, index) => {
        if (!win && !draw) {
            if (logic0 && turn === 0)
                return
            if (logic1 && turn !== 0)
                return
            if (moves[index] === boardHelper.BlankCharacter) {
                realClick(index)
            }
        }
    }

    // functions
    const realClick = (index) => {
        const turnChar = turn === 0 ? 'O' : 'X'
        moves.splice(index, 1, turnChar)
        setMoves(moves)
        if (boardHelper.checkVictoryState(moves, boardSize, turnChar)) {
            setWin(true)
        }
        else if (boardHelper.checkDrawState(moves)) {
            setDraw(true)
        }
        else {
            setTurn(turn === 0 ? 1 : 0)
            setReload(reload + 1)
        }
    }
    const logicCode = (logic) => {
        const index = logic.think(moves, boardHelper.BlankCharacter)
        console.log(`logic ${logic.turnChar} think ${index}`)
        realClick(index)
    }

    // load
    React.useEffect(() => {
        if (turn === 0 && logic0) {
            logicCode(logic0)
        }
        if (turn === 1 && logic1) {
            logicCode(logic1)
        }
    }, [reload])

    // rendering
    const elements = []
    for (let i = 0; i < boardSize; i++) {
        const result = ((() => {
            const result = ((() => {
                const elements = []
                for (let j = 0; j < boardSize; j++) {
                    const index = i * boardSize + j
                    const result = ((() => {
                        return (
                            <td
                                className={classes.boardCell}
                                onClick={(e) => handleClick(e, index)}>
                                <span id={`cell-${index}`}>{moves[index]}</span>
                            </td>
                        )
                    })())
                    elements.push(result)
                }
                return elements
            })())
            return (
                <tr className={classes.boardRow}>{result}</tr>
            )
        })())
        elements.push(result)
    }
    return (
        <AppBox title="Tic Tac Toe" active="Games">
            <div>
                {(() => {
                    if (win)
                        return `Game End, Player ${turn === 0 ? '1' : '2'} Win`
                    else if (draw)
                        return `Game End, Draw`
                    else if (turn === 0)
                        return `Player 1 Turn`
                    else if (turn === 1)
                        return `Player 2 Turn`
                    else
                        return ``
                })()}
            </div>
            <table className={classes.board}>{elements}</table>
        </AppBox>
    )
}
