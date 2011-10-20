model = require('BbScoutModel').BbScout.model

gamesList = model.store.games

listGames = ->
	gameEntry = (id, game) ->
		{
			uri: "/games/#{id}"
			teamA: game.teamA.name
			teamB: game.teamB.name
			score: game.score()
		}

	for key, game of gamesList
		gameEntry parseInt(key) + 1, game

games =
	addGame: (game) ->
		gamesList.push game

	resetGames: -> gamesList = []

	index: (request, response) ->
		response.send JSON.stringify listGames()
		
	create: (request, response) ->
		teamNames = request.body
		teamA = new model.Team teamNames.teamA
		teamB = new model.Team teamNames.teamB
		game = new model.Game teamA, teamB
		gamesList.push game
		index = gamesList.length
		response.redirect "/games/#{index}", 201

exports.games = games
