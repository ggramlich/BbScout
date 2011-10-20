restServer = require 'BbScoutRestServer'
model = require('BbScoutModel').BbScout.model
request = require('request')

port = 8001

base_uri = "http://localhost:#{port}"
games_uri = "#{base_uri}/games/"

describe 'The games resource', ->
	beforeEach ->
		restServer.resetGames()
		restServer.start(port)

	afterEach ->
		restServer.stop()

	it 'exists', ->
		request uri: games_uri, (req, resp) ->
			expect(resp.statusCode).toEqual 200
			asyncSpecDone()
		asyncSpecWait()

	it 'represents an empty list of games', ->
		request uri: games_uri, (req, resp) ->
			result = JSON.parse(resp.body)
			expect(result).toEqual []
			asyncSpecDone()
		asyncSpecWait()

	it 'represents the list of available games', ->
		teamA = new model.Team 'Team A'
		teamB = new model.Team 'Team B'
		game = new model.Game teamA, teamB
		restServer.addGame game
		restServer.addGame game
		request uri: games_uri, (req, resp) ->
			result = JSON.parse resp.body
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

	it 'allows the creation of a new game', ->
		teamNames = {teamA: 'Team A', teamB: 'Team B'}
		options = uri: games_uri, method: 'POST', json: teamNames
		request options, (req, resp) ->
			expect(resp.statusCode).toEqual 201
			expect(resp.headers.location).toEqual "#{base_uri}/games/1"
			request uri: games_uri, (req, resp) ->
				result = JSON.parse resp.body
				expected = [
					uri: '/games/1'
					teamA: 'Team A'
					teamB: 'Team B'
					score: '0:0'
				]
				expect(result).toEqual(expected)
				asyncSpecDone()
		asyncSpecWait()
