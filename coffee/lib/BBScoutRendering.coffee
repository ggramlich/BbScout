{model} = require('./BbScoutModel').BbScout

class Renderer
	teamIsInGame = (team) -> team.game?

	listGames: (games) =>
		for key, game of games
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

	gameUri: (game) -> "/games/#{game.id}"

	listTeams: (teams) =>
		for name, team of teams
			@teamRepresentation team

	teamRepresentation: (team) =>
		reresentation =
			uri: @teamUri team
			name: team.name
			players: @listPlayers team
			points: team.points()
		if team.game?
			reresentation.game =
				uri: @gameUri team.game
		reresentation

	teamUri: (team) =>
		if teamIsInGame team
			"#{@gameUri team.game}/teams/#{team.idInGame}"
		else
			escape "/all_teams/#{team.name}"

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

	playerUri: (player) =>
		if teamIsInGame player.team
			"#{@teamUri player.team}/players/#{player.number}"
		else
			"#{@teamUri player.team}/all_players/#{player.number}"

	render: (object) => JSON.stringify object

# The parser actually takes javascript object, not JSON strings,
# because we use express.bodyParser()
class Parser
	createGame: (teamNames, existingTeams = {}) =>
		teamA = existingTeams[teamNames.teamA] ? @createTeam teamNames.teamA
		teamB = existingTeams[teamNames.teamB] ? @createTeam teamNames.teamB
		new model.Game teamA, teamB

	createTeam: (teamName) -> new model.Team teamName

	createPlayer: (representation, team) =>
		player = new model.Player representation.number, representation.firstName, representation.lastName, representation.points
		team.addPlayer player
		player

exports.renderer = new Renderer
exports.parser = new Parser
