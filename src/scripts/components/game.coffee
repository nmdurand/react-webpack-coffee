import React from 'react'

import Board from 'components/board'

formatCoords = (i)->
	col = (i % 3) + 1
	row = 3 - Math.floor(i / 3)
	col + "-" + row

calculateWinner = (squares)->
	lines = [
		[0, 1, 2]
		[3, 4, 5]
		[6, 7, 8]
		[0, 3, 6]
		[1, 4, 7]
		[2, 5, 8]
		[0, 4, 8]
		[2, 4, 6]
	]
	for i in [0...lines.length]
		[a, b, c] = lines[i]
		if (squares[a] and squares[a] is squares[b] and squares[a] is squares[c])
			return squares[a]
	return null

export default class Game extends React.Component
	constructor: (props)->
		super props
		@state =
			history: [
				squares: Array(9).fill(null)
			]
			stepNumber: 0
			xIsNext: true

	handleClick: (i)->
		history = @state.history.slice 0, @state.stepNumber + 1
		current = history[history.length - 1]
		squares = current.squares.slice()
		if calculateWinner(squares) or squares[i]
			return

		squares[i] = if @state.xIsNext then 'X' else 'O'
		@setState
			history: history.concat [
					squares: squares
					moveCoords: i
				]
			stepNumber: history.length
			xIsNext: !@state.xIsNext

	jumpTo: (step)->
		@setState
			stepNumber: step
			xIsNext: (step % 2) is 0

	render: ->
		history = @state.history
		current = history[@state.stepNumber]
		winner = calculateWinner current.squares

		moves = history.map (step, move) =>
			desc = if move then 'Go to move #' + move else 'Go to game start'
			coords = if Number.isInteger(step.moveCoords) then formatCoords(step.moveCoords) else ''
			classes = if (move is @state.stepNumber) then 'current' else ''
			handleClick = => @jumpTo(move)

			<li key={move} className={classes}>
				{coords}
				<button onClick={handleClick}>
					{desc}
				</button>
			</li>

		if winner
			status = 'Winner:' + winner
		else
			if @state.stepNumber < 9
				status = 'Next player:' + (if @state.xIsNext then 'X' else 'O')
			else
				status = 'Draw'


		<div className="game">
		<div className="game-board">
		<Board
			squares={current.squares}
			onClick={(i) => @handleClick(i)}
		/>
		</div>
			<div className="game-info">
				<div>{status}</div>
				<ol>{moves}</ol>
			</div>
		</div>
