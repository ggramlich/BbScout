{model} = require('BbScoutModel').BbScout
{renderer, parser} = require 'BBScoutRendering'

teamA = new model.Team 'Team A'
teamB = new model.Team 'Team B'
game = new model.Game teamA, teamB

game.id = 1

describe 'the renderer', ->
	it 'should represent a game', ->
		representation = renderer.gameRepresentation game

		expect(representation).toEqual
			uri: '/games/1'
			teamA:
				name: 'Team A'
				uri: '/games/1/teams/teamA'
			teamB:
				name: 'Team B'
				uri: '/games/1/teams/teamB'
			score: '0:0'

	it 'should represent a team', ->
		representation = renderer.teamRepresentation teamA
		expect(representation).toEqual
			uri: '/games/1/teams/teamA'
			game:
				uri: '/games/1'
			name: 'Team A'
			players: []
			points: 0

	it 'should represent a team with players', ->
		player = new model.Player 23, 'Michael', 'Jordan'
		teamA.addPlayer player
		representation = renderer.teamRepresentation teamA
		playerRepresentation = renderer.playerRepresentation player
		expect(representation.players).toEqual [playerRepresentation]

	it 'should represent a player', ->
		player = new model.Player 23, 'Michael', 'Jordan'
		teamA.addPlayer player
		representation = renderer.playerRepresentation player
		expect(representation).toEqual
			uri: '/games/1/teams/teamA/players/23'
			name: 'Michael Jordan'
			firstName: 'Michael'
			lastName: 'Jordan'
			points: 0
