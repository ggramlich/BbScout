require 'express-resource'
express = require 'express'

{games, teams, players} = require './BbScoutResources'

app = express.createServer()
app.use express.bodyParser()

gamesResource = app.resource 'games', games, {load: games.load}
teamsResource = app.resource 'teams', teams, {load: teams.load}
playersResouce = app.resource 'players', players, {load: players.load}
gamesResource.add teamsResource
teamsResource.add playersResouce

module.exports =
	start: (port) -> app.listen port
	stop: -> app.close()
	addGame: (game) -> games.addGame game
	resetGames: -> games.resetGames()
	getGame: (id) -> games.getGame id
