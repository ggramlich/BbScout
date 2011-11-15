{model} = require('./BbScoutModel').BbScout
{renderer, parser} = require('./BBScoutRendering')

allTeamsList = model.teams

jsonResponse = (response, object) ->
	response.contentType('json')
	response.send renderer.render object

class GamesResource
	# TODO make gamesList smarter (not simply an array)
	gamesList = model.store.games

	addGame: (game) ->
		gamesList.push game
		game.id = gamesList.length
		game

	resetGames: -> gamesList = []

	load: (request, id, fn) => fn(null, @getGame id)

	getGame: (id) -> gamesList[id - 1]

	index: (request, response) ->
		jsonResponse response, renderer.listGames gamesList
		
	create: (request, response) =>
		game = parser.createGame request.body, allTeamsList
		@addGame game
		response.redirect renderer.gameUri(game), 201

	show: (request, response) ->
		jsonResponse response, renderer.gameRepresentation request.game

class TeamsResource

	load: (request, id, fn) ->
		team = request.game?[id]
		team ?= request.game?.getTeam id
		fn(null, team)

	show: (request, response) ->
		jsonResponse response, renderer.teamRepresentation request.team

class AllTeamsResource
	index: (request, response) ->
		jsonResponse response, renderer.listTeams allTeamsList

	reset: ->
		allTeamsList = []

	addTeam: (team) ->
		allTeamsList[team.name] = team

	load: (request, name, fn) ->
		team = allTeamsList[name]
		fn(null, team)

	show: (request, response) ->
		jsonResponse response, renderer.teamRepresentation request.all_team

	create: (request, response) =>
		teamRepresentation = request.body
		team = parser.createTeam teamRepresentation.name
		@addTeam team
		response.redirect renderer.teamUri(team), 201

class AllTeamsPlayersResource
	load: (request, id, fn) ->
		player = request.all_team?.getPlayer id
		fn(null, player)

	show: (request, response) ->
		jsonResponse response, renderer.playerRepresentation request.all_player

	create: (request, response) =>
		player = parser.createPlayer request.body, request.all_team
		response.redirect renderer.playerUri(player), 201

class PlayersResource

	create: (request, response) =>
		player = parser.createPlayer request.body, request.team
		response.redirect renderer.playerUri(player), 201

	load: (request, id, fn) ->
		player = request.team?.getPlayer id
		fn(null, player)

	show: (request, response) ->
		jsonResponse response, renderer.playerRepresentation request.player

class EventsResource
	create: (request, response) =>
		player = request.player
		return unless player?
		
		event = request.body
		player[event.action]? event.argument
		response.redirect "#{renderer.playerUri(player)}", 201

exports.games = new GamesResource
exports.allTeams = new AllTeamsResource
exports.allTeamsPlayers = new AllTeamsPlayersResource
exports.teams = new TeamsResource
exports.players = new PlayersResource
exports.events = new EventsResource
