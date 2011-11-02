model = require('./BbScoutModel').BbScout.model



class GamesResource
	# TODO make gamesList smarter (not simply an array)
	gamesList = model.store.games

	gameUri = (game) -> "/games/#{game.id}"

	listGames = ->
		for key, game of gamesList
			createGameResource game
	
	createGameResource = (game) ->
		uri: gameUri game
		teamA:
			name: game.teamA.name
			uri: "#{gameUri(game)}/teams/a"
		teamB:
			name: game.teamB.name
			uri: "#{gameUri(game)}/teams/b"
		score: game.score()

	addGame: (game) ->
		gamesList.push game
		game.id = gamesList.length

	resetGames: -> gamesList = []

	load: (id, fn) ->
		key = id - 1
		fn(null, gamesList[key])

	index: (request, response) ->
		response.send JSON.stringify listGames()
		
	create: (request, response) =>
		teamNames = request.body
		teamA = new model.Team teamNames.teamA
		teamB = new model.Team teamNames.teamB
		game = new model.Game teamA, teamB
		@addGame game
		response.redirect gameUri(game), 201

	show: (request, response) ->
		response.send JSON.stringify createGameResource(request.game)

exports.games = new GamesResource
