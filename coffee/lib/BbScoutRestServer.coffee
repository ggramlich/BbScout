require 'express-resource'
express = require 'express'

{games} = require './BbScoutResources'

app = express.createServer()
app.use express.bodyParser()

gamesResource = app.resource 'games', games, {load: games.load}

module.exports =
	start: (port) -> app.listen port
	stop: -> app.close()
	addGame: (game) -> games.addGame(game)
	resetGames: -> games.resetGames()
	