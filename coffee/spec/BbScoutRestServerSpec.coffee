restServer = require 'BbScoutRestServer'
model = require('BbScoutModel').BbScout.model
request = require('request')

port = 8001

games_uri = "http://localhost:#{port}/games/"

describe 'The REST server', ->
	beforeEach ->
		restServer.start(port)

	afterEach ->
		restServer.stop()

	it 'responds on the games resource', ->
		request uri: games_uri, (req, resp) ->
			expect(resp.statusCode).toEqual(200)
			asyncSpecDone()
		asyncSpecWait()

	it 'responds an empty list of games', ->
		request uri: games_uri, (req, resp) ->
			result = JSON.parse(resp.body)
			expect(result).toEqual([])
			asyncSpecDone()
		asyncSpecWait()

	it 'responds with the list of available games', ->
		teamA = new model.Team 'Team A'
		teamB = new model.Team 'Team B'
		game = new model.Game teamA, teamB
		restServer.addGame game
		restServer.addGame game
		request uri: games_uri, (req, resp) ->
			result = JSON.parse(resp.body)
			expected = [
				uri: '/games/1'
				teamA: 'Team A'
				teamB: 'Team B'
				score: '0:0'
			,
				uri: '/games/2'
				teamA: 'Team A'
				teamB: 'Team B'
				score: '0:0'
			]

			expect(result).toEqual(expected)
			asyncSpecDone()
		asyncSpecWait()
