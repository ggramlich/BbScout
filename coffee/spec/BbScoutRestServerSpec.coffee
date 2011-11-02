restServer = require 'BbScoutRestServer'
model = require('BbScoutModel').BbScout.model
request = require('request')

port = 8001

base_uri = "http://localhost:#{port}"
games_uri = "#{base_uri}/games/"
games_uri_1 = "#{games_uri}1"

createDefaultGame = ->
	teamA = new model.Team 'Team A'
	teamB = new model.Team 'Team B'
	return new model.Game teamA, teamB


game1Response =
	uri: '/games/1'
	teamA:
		name: 'Team A'
		uri: '/games/1/teams/a'
	teamB:
		name: 'Team B'
		uri: '/games/1/teams/b'
	score: '0:0'

game2Response =
	uri: '/games/2'
	teamA:
		name: 'Team A'
		uri: '/games/2/teams/a'
	teamB:
		name: 'Team B'
		uri: '/games/2/teams/b'
	score: '0:0'

describe 'The games resource', ->
	beforeEach ->
		restServer.resetGames()
		restServer.start port

	afterEach ->
		restServer.stop()

	it 'exists', ->
		request uri: games_uri, (req, resp) ->
			expect(resp.statusCode).toEqual 200
			asyncSpecDone()
		asyncSpecWait()

	it 'represents an empty list of games', ->
		request uri: games_uri, (req, resp) ->
			result = JSON.parse resp.body
			expect(result).toEqual []
			asyncSpecDone()
		asyncSpecWait()

	it 'represents the list of available games', ->
		restServer.addGame createDefaultGame()
		restServer.addGame createDefaultGame()
		request uri: games_uri, (req, resp) ->
			result = JSON.parse resp.body
			expect(result).toEqual [game1Response, game2Response]
			asyncSpecDone()
		asyncSpecWait()

	it 'allows the creation of a new game', ->
		teamNames = {teamA: 'Team A', teamB: 'Team B'}
		options = uri: games_uri, method: 'POST', json: teamNames
		request options, (req, resp) ->
			expect(resp.statusCode).toEqual 201
			expect(resp.headers.location).toEqual games_uri_1
			request uri: games_uri, (req, resp) ->
				result = JSON.parse resp.body
				expect(result).toEqual [game1Response]
				asyncSpecDone()
		asyncSpecWait()

describe 'A single game resource', ->
	beforeEach ->
		restServer.resetGames()
		restServer.addGame createDefaultGame()
		restServer.start port

	afterEach ->
		restServer.stop()

	it 'exists', ->
		request uri: games_uri_1, (req, resp) ->
			expect(resp.statusCode).toEqual 200
			asyncSpecDone()
		asyncSpecWait()

	it 'does not exist for non-existing game', ->
		request uri: "#{games_uri}2", (req, resp) ->
			expect(resp.statusCode).toEqual 404
			asyncSpecDone()
		asyncSpecWait()

	it 'contains the link to the team resources', ->
		expected = game1Response
		request uri: games_uri_1, (req, resp) ->
			result = JSON.parse resp.body
			expect(result).toEqual expected
			asyncSpecDone()
		asyncSpecWait()

