{model} = require('./BbScoutModel').BbScout
{renderer, parser} = require('./BBScoutRendering')

class GamesResource
	# TODO make gamesList smarter (not simply an array)
	gamesList = model.store.games

	addGame: (game) ->
		gamesList.push game
		game.id = gamesList.length

	resetGames: -> gamesList = []

	load: (id, fn) ->
		key = id - 1
		fn(null, gamesList[key])

	index: (request, response) ->
		response.send JSON.stringify renderer.listGames gamesList
		
	create: (request, response) =>
		game = parser.createGame request.body
		@addGame game
		response.redirect renderer.gameUri(game), 201

	show: (request, response) ->
		response.send renderer.renderGame request.game

class TeamsResource

	load: (request, id, fn) ->
		team = request.game?["team#{id.toUpperCase()}"]
		if team?
			team.game = request.game
			team.idInGame = id
		fn(null, team)

	show: (request, response) ->
		response.send renderer.renderTeam request.team

class PlayersResource

	create: (request, response) =>
		player = parser.createPlayer request.body, request.team
		response.redirect renderer.playerUri(player), 201


exports.games = new GamesResource
exports.teams = new TeamsResource
exports.players = new PlayersResource
