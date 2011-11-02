model = require('./BbScoutModel').BbScout.model

gamesList = model.store.games

gameUri = (id) -> "/games/#{id}"

listGames = ->
	gameEntry = (id, game) ->
		uri: gameUri id
		teamA: game.teamA.name
		teamB: game.teamB.name
		score: game.score()

	for key, game of gamesList
		gameEntry parseInt(key) + 1, game

createGameResource = (game) ->
	teamA:
		name: game.teamA.name
		uri: "#{gameUri(game.id)}/teams/a"
	teamB:
		name: game.teamB.name
		uri: "#{gameUri(game.id)}/teams/b"
	score: game.score()

class GamesResource
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
		id = @addGame game
		response.redirect gameUri(id), 201

	show: (request, response) ->
		response.send JSON.stringify createGameResource(request.game)

exports.games = new GamesResource
