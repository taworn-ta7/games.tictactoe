import React from 'react'
import { useHistory } from "react-router-dom"
import AppBox from '../layouts/AppBox'

export default function HomePage(props) {
    // router
    const history = useHistory()

    // states
    const [boardSize, setBoardSize] = React.useState(3)
    const [player1IsComputer, setPlayer1IsComputer] = React.useState(false)
    const [player2IsComputer, setPlayer2IsComputer] = React.useState(false)

    // events
    const handleSubmit = (e) => {
        e.preventDefault()
        const p1 = player1IsComputer ? 'computer' : 'player'
        const p2 = player2IsComputer ? 'computer' : 'player'
        history.push(`/ttt/${boardSize}/${p1}/${p2}`)
    }

    // rendering
    return (
        <AppBox title="Home" active="Home">
            <div>
                <form id="settingsForm" onSubmit={(e) => handleSubmit(e)}>
                    <label for="boardSize">Board Size: </label>
                    <input type="number"
                        min="3" max="20" autoFocus required
                        id="boardSize" value={boardSize}
                        onChange={(e) => setBoardSize(e.target.value)} />
                    <br />

                    <input type="checkbox"
                        id="player1IsComputer"
                        onChange={(e) => setPlayer1IsComputer(e.target.value)} />
                    <label for="player1IsComputer">Player 1 is computer?</label>
                    <br />

                    <input type="checkbox"
                        id="player2IsComputer"
                        onChange={(e) => setPlayer2IsComputer(e.target.value)} />
                    <label for="player2IsComputer">Player 2 is computer?</label>
                    <br />

                    <button type="submit">Play</button>
                </form>
            </div>
        </AppBox>
    )
}
