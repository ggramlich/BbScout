{model} = require('./BbScoutModel').BbScout

class Renderer
	gameUri: (game) => "/games/#{game.id}"
	teamUri: (team) => "#{@gameUri team.game}/teams/#{team.idInGame}"
	playerUri: (player) => "#{@teamUri player.team}/players/#{player.number}"

	renderGame: (game) => @render @gameRepresentation game

	listGames: (gamesList) =>
		for key, game of gamesList
			@gameRepresentation game

	gameRepresentation: (game) =>
		uri: @gameUri game
		teamA:
			name: game.teamA.name
			uri: @teamUri game.teamA
		teamB:
			name: game.teamB.name
			uri: @teamUri game.teamB
		score: game.score()

	renderTeam: (team) =>
		@render @teamRepresentation team

	teamRepresentation: (team) =>
		uri: @teamUri team
		game:
			uri: @gameUri team.game
		name: team.name
		players: @listPlayers team
		points: team.points()

	listPlayers: (team) =>
		for number, player of team.playersList
			player.team = team
			@playerRepresentation player

	playerRepresentation: (player) =>
		uri: @playerUri player
		name: player.name()
		firstName: player.firstName
		lastName: player.lastName
		points: player.points

	render: (object) => JSON.stringify object

# The parser actually takes javascript object, not JSON strings,
# because we use express.bodyParser()
class Parser
	createGame: (teamNames) =>
		teamA = new model.Team teamNames.teamA
		teamB = new model.Team teamNames.teamB
		new model.Game teamA, teamB

	createPlayer: (representation, team) =>
		player = new model.Player representation.number, representation.firstName, representation.lastName, representation.points
		team.addPlayer player
		player

exports.renderer = new Renderer
exports.parser = new Parser
