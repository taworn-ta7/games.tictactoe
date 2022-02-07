import React from 'react'
import { BrowserRouter, Route, Switch } from 'react-router-dom'
import HomePage from './pages/HomePage'
import GamePage from './pages/GamePage'
import './App.css'

export default function App(props) {
    // rendering
    return (
        <BrowserRouter>
            <Switch>
                <Route exact path="/" component={HomePage} />
                <Route exact path="/ttt/:boardSize/:player1/:player2" component={GamePage} />
            </Switch>
        </BrowserRouter>
    )
}
