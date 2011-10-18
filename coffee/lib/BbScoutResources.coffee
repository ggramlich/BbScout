games =
	index: (request, response) ->
		result = "games:\n"
		response.send result

exports.games = games
