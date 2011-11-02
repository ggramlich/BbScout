require 'express-resource'
express = require 'express'

{games, teams} = require './BbScoutResources'

app = express.createServer()
app.use express.bodyParser()

gamesResource = app.resource 'games', games, {load: games.load}
teamsResource = app.resource 'teams', teams, {load: teams.load}
gamesResource.add teamsResource

module.exports =
	start: (port) -> app.listen port
	stop: -> app.close()
	addGame: (game) -> games.addGame(game)
	resetGames: -> games.resetGames()
	