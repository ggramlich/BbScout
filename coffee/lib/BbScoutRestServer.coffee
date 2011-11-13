require 'express-resource'
express = require 'express'

{games, allTeams, allTeamsPlayers, teams, players, events} = require './BbScoutResources'

app = express.createServer()
app.use express.bodyParser()

# Setup Template Engine
app.register '.coffee', require('coffeekup')
app.set 'view engine', 'coffee'

# Setup Static Files
app.use express.static('public')

# App Routes
app.get '/', (request, response) ->
	response.render 'index'

app.use require('connect-assets')()

gamesResource = app.resource 'games', games, {load: games.load}
teamsResource = app.resource 'teams', teams, {load: teams.load}
playersResource = app.resource 'players', players, {load: players.load}
allTeamsResource = app.resource 'all_teams', allTeams, {load: allTeams.load}
allTeamsPlayersResource = app.resource 'all_players', allTeamsPlayers, {load: allTeamsPlayers.load}
eventsResource = app.resource 'events', events

gamesResource.add teamsResource
teamsResource.add playersResource
allTeamsResource.add allTeamsPlayersResource
playersResource.add eventsResource

module.exports =
	start: (port) -> app.listen port
	stop: -> app.close()
	addGame: (game) -> games.addGame game
	addTeam: (team) -> allTeams.addTeam team
	resetGames: -> games.resetGames()
	getGame: (id) -> games.getGame id
