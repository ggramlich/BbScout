model = require('./BbScoutModel').BbScout.model

gameUri = (game) -> "/games/#{game.id}"

class GamesResource
	# TODO make gamesList smarter (not simply an array)
	gamesList = model.store.games

	listGames = ->
		for key, game of gamesList
			gameRepresentation game
	
	gameRepresentation = (game) ->
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
		response.send JSON.stringify gameRepresentation(request.game)

class TeamsResource
	teamUri = (team) -> "#{gameUri team.game}/teams/#{team.idInTeam}"

	playerUri = (player) -> "#{teamUri player.team}/players/#{player.number}"

	playerRepresentation = (player) ->
		uri: playerUri player
		name: player.name()
		points: player.points

	listPlayers = (team) ->
		for number, player of team.playersList
			player.team = team
			playerRepresentation player

	teamRepresentation = (team) ->
		uri: teamUri team
		game:
			uri: gameUri team.game
		name: team.name
		players: listPlayers team
		points: team.points()
		

	load: (request, id, fn) ->
		team = request.game?["team#{id.toUpperCase()}"]
		if team?
			team.game = request.game
			team.idInTeam = id
		fn(null, team)

	show: (request, response) ->
		response.send JSON.stringify teamRepresentation(request.team)

exports.games = new GamesResource
exports.teams = new TeamsResource
