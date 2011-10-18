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

	index: (request, response) ->
		response.send JSON.stringify listGames()

exports.games = games
