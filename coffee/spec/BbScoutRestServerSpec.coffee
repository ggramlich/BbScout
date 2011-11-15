restServer = require 'BbScoutRestServer'
{model} = require('BbScoutModel').BbScout
{renderer, parser} = require('BBScoutRendering')

request = require('request')

port = 8001

base_uri = "http://localhost:#{port}"
games_uri = "#{base_uri}/games/"
game1_uri = "#{games_uri}1"
game1_teamA_uri = "#{game1_uri}/teams/teamA"

all_teams_uri = "#{base_uri}/all_teams/"

createDefaultGame = ->
	teamA = new model.Team 'Team A'
	teamB = new model.Team 'Team B'
	return new model.Game teamA, teamB


describe 'The Rest server', ->
	beforeEach ->
		restServer.resetGames()
		restServer.resetTeams()
		restServer.start port
		@addMatchers
			toBeJson: -> @actual.headers['content-type'] == 'application/json'

	afterEach ->
		restServer.stop()

	describe 'The games resource', ->
		it 'exists', ->
			request uri: games_uri, (req, resp) ->
				expect(resp.statusCode).toEqual 200
				expect(resp).toBeJson()
				asyncSpecDone()
			asyncSpecWait()
	
		it 'represents an empty list of games', ->
			request uri: games_uri, (req, resp) ->
				result = JSON.parse resp.body
				expect(result).toEqual []
				asyncSpecDone()
			asyncSpecWait()
	
		it 'represents the list of available games', ->
			game1 = restServer.addGame createDefaultGame()
			game2 = restServer.addGame createDefaultGame()
			request uri: games_uri, (req, resp) ->
				result = JSON.parse resp.body
				expect(result).toEqual [renderer.gameRepresentation(game1), renderer.gameRepresentation(game2)]
				asyncSpecDone()
			asyncSpecWait()
	
		it 'allows the creation of a new game', ->
			expect(restServer.getGame 1).toBeUndefined()

			expectedGame = createDefaultGame()
			expectedGame.id = 1
			teamNames = {teamA: 'Team A', teamB: 'Team B'}
			options = uri: games_uri, method: 'POST', json: teamNames
			request options, (req, resp) ->
				expect(resp.statusCode).toEqual 201
				expect(resp.headers.location).toEqual game1_uri
				expect(restServer.getGame 1).toEqual expectedGame
				asyncSpecDone()
			asyncSpecWait()

		it 'allows the creation of a new game with teams from the all_teams resource', ->
			expect(restServer.getGame 1).toBeUndefined()
			teamX = restServer.addTeam new model.Team 'Team X'
			teamY = restServer.addTeam new model.Team 'Team Y'
			teamX.addPlayer new model.Player(41, 'Dirk', 'Nowitzki')
			teamY.addPlayer new model.Player(23, 'Michael', 'Jordan')

			teamNames = {teamA: 'Team X', teamB: 'Team Y'}
			options = uri: games_uri, method: 'POST', json: teamNames
			request options, (req, resp) ->
				expect(resp.statusCode).toEqual 201
				expect(resp.headers.location).toEqual game1_uri
				actualGame = restServer.getGame 1
				expect(actualGame.teamA).toEqual teamX
				expect(actualGame.teamB).toEqual teamY
				asyncSpecDone()
			asyncSpecWait()

		it 'should remove the teams from the all_games when they are used for a new game', ->
			expect(restServer.getGame 1).toBeUndefined()
			teamX = restServer.addTeam new model.Team 'Team X'
			teamY = restServer.addTeam new model.Team 'Team Y'
			teamZ = restServer.addTeam new model.Team 'Team Z'

			teamNames = {teamA: 'Team X', teamB: 'Team Y'}
			options = uri: games_uri, method: 'POST', json: teamNames
			request options, (req, resp) ->
				expect(resp.headers.location).toEqual game1_uri
				request uri: all_teams_uri, (req, resp) ->
					result = JSON.parse resp.body
					expect(result).toEqual [renderer.teamRepresentation(teamZ)]
					asyncSpecDone()
			asyncSpecWait()

	describe 'A single game resource', ->
		game1 = null
		beforeEach ->
			game1 = restServer.addGame createDefaultGame()
	
		it 'exists', ->
			request uri: game1_uri, (req, resp) ->
				expect(resp.statusCode).toEqual 200
				expect(resp).toBeJson()
				asyncSpecDone()
			asyncSpecWait()
	
		it 'does not exist for non-existing game', ->
			request uri: "#{games_uri}2", (req, resp) ->
				expect(resp.statusCode).toEqual 404
				asyncSpecDone()
			asyncSpecWait()
	
		it 'contains the link to the team resources', ->
			expected = renderer.gameRepresentation game1
			request uri: game1_uri, (req, resp) ->
				result = JSON.parse resp.body
				expect(result).toEqual expected
				asyncSpecDone()
			asyncSpecWait()

	describe 'the all teams resource', ->
		teamX = teamY = null
		beforeEach ->
			teamX = restServer.addTeam new model.Team 'Team X'
			teamY = restServer.addTeam new model.Team 'Team Y'
			
		it 'exists', ->
			request uri: all_teams_uri, (req, resp) ->
				expect(resp.statusCode).toEqual 200
				expect(resp).toBeJson()
				asyncSpecDone()
			asyncSpecWait()

		it 'shows a list of the teams', ->
			expected = [renderer.teamRepresentation(teamX), renderer.teamRepresentation(teamY)]
			request uri: all_teams_uri, (req, resp) ->
				result = JSON.parse resp.body
				expect(result).toEqual expected
				asyncSpecDone()
			asyncSpecWait()

		it 'allows to add a team', ->
			team = name: 'New team'
			new_team_uri = "#{all_teams_uri}New%20team"	
			options = uri: all_teams_uri, method: 'POST', json: team
			request options, (req, resp) ->
				expect(resp.statusCode).toEqual 201
				expect(resp.headers.location).toEqual new_team_uri
				request uri: new_team_uri, (req, resp) ->
					expect(resp.statusCode).toEqual 200
				asyncSpecDone()
			asyncSpecWait()

	describe 'a single team resource from all teams', ->
		teamX = null
		teamX_uri = "#{all_teams_uri}Team%20X"
		beforeEach ->
			teamX = restServer.addTeam new model.Team 'Team X'

		it 'exists', ->
			request uri: teamX_uri, (req, resp) ->
				expect(resp.statusCode).toEqual 200
				expect(resp).toBeJson()
				asyncSpecDone()
			asyncSpecWait()

		it 'shows a representation of the team', ->
			expected = renderer.teamRepresentation teamX
			request uri: teamX_uri, (req, resp) ->
				result = JSON.parse resp.body
				expect(result).toEqual expected
				asyncSpecDone()
			asyncSpecWait()

		it 'can handle a wrong name', ->
			request uri: "#{all_teams_uri}abc", (req, resp) ->
				expect(resp.statusCode).toEqual 404
				asyncSpecDone()
			asyncSpecWait()

	describe 'the player resource from an all_teams team', ->
		teamX = null
		teamX_uri = "#{all_teams_uri}Team%20X"
		beforeEach ->
			teamX = restServer.addTeam new model.Team 'Team X'

		it 'exists', ->
			teamX.addPlayer new model.Player(41, 'Dirk', 'Nowitzki')
			playerUri = "#{teamX_uri}/all_players/41"
			request uri: playerUri, (req, resp) ->
				expect(resp.statusCode).toEqual 200
				expect(resp).toBeJson()
				asyncSpecDone()
			asyncSpecWait()

		it 'shows a representation of the player', ->
			player = teamX.addPlayer new model.Player(41, 'Dirk', 'Nowitzki')
			playerUri = "#{teamX_uri}/all_players/41"
			request uri: playerUri, (req, resp) ->
				result = JSON.parse resp.body
				expect(result).toEqual renderer.playerRepresentation player
				asyncSpecDone()
			asyncSpecWait()

		it 'allows to add a player', ->
			playersUri = "#{teamX_uri}/all_players"
			player = number: 23, firstName: 'Michael', lastName: 'Jordan', points: 2
				
			options = uri: playersUri, method: 'POST', json: player
			request options, (req, resp) ->
				expect(resp.statusCode).toEqual 201
				expect(resp.headers.location).toEqual "#{playersUri}/23"
				expect(teamX.getPlayer(player.number).name()).toBe 'Michael Jordan'
				asyncSpecDone()
			asyncSpecWait()

	describe 'a single team resource within a game', ->
		game = null
		beforeEach ->
			game = createDefaultGame()
			restServer.addGame game
	
		it 'exists', ->
			request uri: game1_teamA_uri, (req, resp) ->
				expect(resp.statusCode).toEqual 200
				expect(resp).toBeJson()
				asyncSpecDone()
			asyncSpecWait()
	
		it 'exists for the team name', ->
			team_uri = "#{game1_uri}/teams/Team%20A"
			request uri: team_uri, (req, resp) ->
				expect(resp.statusCode).toEqual 200
				expect(resp).toBeJson()
				asyncSpecDone()
			asyncSpecWait()
	
		it 'can handle a bad id', ->
			request uri: "#{game1_teamA_uri}BAD", (req, resp) ->
				expect(resp.statusCode).toEqual 404
				asyncSpecDone()
			asyncSpecWait()
	
		it 'shows a representation of the team', ->
			expected = renderer.teamRepresentation game.teamA
			request uri: game1_teamA_uri, (req, resp) ->
				result = JSON.parse resp.body
				expect(result).toEqual expected
				asyncSpecDone()
			asyncSpecWait()
	
		it 'contains the list of players', ->
			player = game.teamA.addPlayer new model.Player(41, 'Dirk', 'Nowitzki')
			player1Representation = renderer.playerRepresentation player
	
			request uri: game1_teamA_uri, (req, resp) ->
				result = JSON.parse resp.body
				expect(result.players).toEqual [player1Representation]
				asyncSpecDone()
			asyncSpecWait()

	describe 'the player resource', ->
		game = null
		beforeEach ->
			game = createDefaultGame()
			restServer.addGame game

		it 'exists', ->
			player = game.teamA.addPlayer new model.Player(41, 'Dirk', 'Nowitzki')
			playerUri = "#{game1_teamA_uri}/players/41"
			request uri: playerUri, (req, resp) ->
				expect(resp.statusCode).toEqual 200
				expect(resp).toBeJson()
				asyncSpecDone()
			asyncSpecWait()

		it 'can handle a wrong player number', ->
			request uri: "#{game1_teamA_uri}/players/41", (req, resp) ->
				expect(resp.statusCode).toEqual 404
				asyncSpecDone()
			asyncSpecWait()

		it 'shows a representation of the player', ->
			player = game.teamA.addPlayer new model.Player(41, 'Dirk', 'Nowitzki')
			playerUri = "#{game1_teamA_uri}/players/41"
			request uri: playerUri, (req, resp) ->
				result = JSON.parse resp.body
				expect(result).toEqual renderer.playerRepresentation player
				asyncSpecDone()
			asyncSpecWait()

		it 'allows to add a player', ->
			playersUri = "#{game1_teamA_uri}/players"
			player = number: 23, firstName: 'Michael', lastName: 'Jordan', points: 2
				
			options = uri: playersUri, method: 'POST', json: player
			request options, (req, resp) ->
				expect(resp.statusCode).toEqual 201
				expect(resp.headers.location).toEqual "#{playersUri}/23"
				expect(game.teamA.getPlayer(player.number).name()).toBe 'Michael Jordan'
				asyncSpecDone()
			asyncSpecWait()

	describe 'the events resource', ->
		game = player = eventsUri = null
		beforeEach ->
			game = createDefaultGame()
			restServer.addGame game
			player = game.teamA.addPlayer new model.Player(41, 'Dirk', 'Nowitzki')
			eventsUri = "#{game1_teamA_uri}/players/41/events"

		it 'should allow to score goals', ->
			event =
				action: 'scores'
				argument: 'Fieldgoal'

			options = uri: eventsUri, method: 'POST', json: event
			request options, (req, resp) ->
				expect(resp.statusCode).toEqual 201
				expect(resp.headers.location).toEqual "#{game1_teamA_uri}/players/41"
				expect(player.points).toBe 2
				asyncSpecDone()
			asyncSpecWait()
			
		it 'should allow to miss goals', ->
			event =
				action: 'misses'
				argument: 'Fieldgoal'

			options = uri: eventsUri, method: 'POST', json: event
			request options, (req, resp) ->
				expect(resp.statusCode).toEqual 201
				expect(resp.headers.location).toEqual "#{game1_teamA_uri}/players/41"
				expect(player.points).toBe 0
				expect(player.attempted 'Fieldgoal').toBe 1
				asyncSpecDone()
			asyncSpecWait()
			
