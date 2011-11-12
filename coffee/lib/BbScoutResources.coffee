{model} = require('./BbScoutModel').BbScout
{renderer, parser} = require('./BBScoutRendering')

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
		response.send JSON.stringify renderer.listGames gamesList
		
	create: (request, response) =>
		game = parser.createGame request.body
		@addGame game
		response.redirect renderer.gameUri(game), 201

	show: (request, response) ->
		response.send renderer.renderGame request.game

class TeamsResource

	load: (request, id, fn) ->
		team = request.game?[id]
		fn(null, team)

	show: (request, response) ->
		response.send renderer.renderTeam request.team

class AllTeamsResource
	allTeamsList = model.teams

	index: (request, response) ->
		response.send JSON.stringify renderer.listTeams allTeamsList
		
	addTeam: (team) ->
		allTeamsList[team.name] = team

	load: (request, name, fn) ->
		team = allTeamsList[name]
		fn(null, team)

	show: (request, response) ->
		response.send renderer.renderTeam request.all_team

class PlayersResource

	create: (request, response) =>
		player = parser.createPlayer request.body, request.team
		response.redirect renderer.playerUri(player), 201

	load: (request, id, fn) ->
		player = request.team?.getPlayer id
		fn(null, player)

	show: (request, response) ->
		response.send renderer.renderPlayer request.player

class EventsResource
	create: (request, response) =>
		player = request.player
		return unless player?
		
		event = request.body
		player[event.action]? event.argument
		response.redirect "#{renderer.playerUri(player)}", 201

exports.games = new GamesResource
exports.allTeams = new AllTeamsResource
exports.teams = new TeamsResource
exports.players = new PlayersResource
exports.events = new EventsResource
