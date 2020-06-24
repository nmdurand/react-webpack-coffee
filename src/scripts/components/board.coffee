import React from 'react'

Square = (props)->
	<button className="square" onClick={props.onClick}>
		{props.value}
	</button>

export default class Board extends React.Component
	renderSquare: (i)->
		<Square
			value = {@props.squares[i]}
			onClick = {=> @props.onClick(i)}
			key = {i}
		/>

	render: ->
		<div>
			{(<div className="board-row" key={i}>
				{(@renderSquare(i*3 + j) for j in [0...3])}
			</div> for i in [0...3])}
		</div>
