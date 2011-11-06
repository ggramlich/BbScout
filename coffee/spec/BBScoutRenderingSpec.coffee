{model} = require('BbScoutModel').BbScout
{renderer, parser} = require 'BBScoutRendering'

createDefaultGame = ->
	teamA = new model.Team 'Team A'
	teamB = new model.Team 'Team B'
	return new model.Game teamA, teamB

describe 'the renderer', ->
	it 'should represent a game', ->
		game = createDefaultGame()
		game.id = 1
		representation = renderer.gameRepresentation game
		expectedRepresentation =
			uri: '/games/1'
			teamA:
				name: 'Team A'
				uri: '/games/1/teams/a'
			teamB:
				name: 'Team B'
				uri: '/games/1/teams/b'
			score: '0:0'

		expect(representation).toEqual expectedRepresentation

