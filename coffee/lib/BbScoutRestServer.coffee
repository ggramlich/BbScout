require 'express-resource'
express = require 'express'

{games} = require './BbScoutResources'

app = express.createServer()

gamesResource = app.resource 'games', games#, {load: Game.load}

module.exports =
	start: (port) -> app.listen port
	stop: -> app.close()
	addGame: (game) -> games.addGame(game)