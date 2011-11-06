require 'express-resource'
express = require 'express'

{games, teams, players, events} = require './BbScoutResources'

app = express.createServer()
app.use express.bodyParser()

gamesResource = app.resource 'games', games, {load: games.load}
teamsResource = app.resource 'teams', teams, {load: teams.load}
playersResource = app.resource 'players', players, {load: players.load}
eventsResource = app.resource 'events', events

gamesResource.add teamsResource
teamsResource.add playersResource
playersResource.add eventsResource

module.exports =
	start: (port) -> app.listen port
	stop: -> app.close()
	addGame: (game) -> games.addGame game
	resetGames: -> games.resetGames()
	getGame: (id) -> games.getGame id
