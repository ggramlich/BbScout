loadFile = (filename) ->
	JsSlim.loadJsFile(filename + '.js')

loadFile('BbScoutModel');

model = this.BbScout.model

class Team
	constructor: (@name) ->
		@team = new model.Team(@name)
		model.teams[@name] = @team
	
	resetTeams: -> model.teams = {}
	
	setNumber: (@number) ->
	setFirstName: (@firstName) ->
	setLastName: (@lastName) ->
	
	execute: ->
		player = new model.Player(@number, @firstName, @lastName);
		@team.addPlayer player

class SelectPlayer
	constructor: (@teamname, @number) ->
		@player = model.teams[@teamname]?.getPlayer(@number)
	
	playerName: -> @player?.name() ? 'unknown'

POINT_TYPES =
	'free throw': 'Freethrow'
	'free throws': 'Freethrow'
	'field goal': 'Fieldgoal'
	'field goals': 'Fieldgoal'
	'three pointer': 'Threepointer'
	'three pointers': 'Threepointer'

normalizePointType = (pointType) -> POINT_TYPES[pointType]


class PlayerSimulation
	NUMBER = '1'
	constructor: -> @player = new model.Player(NUMBER)
	
	points: -> @player.points
	
	setPoints: (points) -> @player.points = parseInt points
	
	scores: (pointType) -> @player.scores normalizePointType(pointType)
	
	misses: (pointType) -> @player.misses normalizePointType(pointType)
	
	scored: (pointType) -> @player.scored normalizePointType(pointType)
	
	attempted: (pointType) -> @player.attempted normalizePointType(pointType)

class GameSimulation
	constructor: (teamNameA, teamNameB) ->
		@game = new model.Game @getTeam(teamNameA), @getTeam(teamNameB)
	
	score: -> @game.score()
	
	playerOfScoresA: (number, teamName, pointType) ->
		player = @getPlayer(teamName, number)
		pointTypeOk = player?.scores normalizePointType(pointType)
		player? and pointTypeOk
	
	getPlayer: (teamName, number) -> @game.getTeam(teamName)?.getPlayer(number)
	
	getTeam: (teamName) -> model.teams[teamName]


# Export the fixtures as module BasketballEnglish

this.BasketballEnglish =
	Team: Team
	SelectPlayer: SelectPlayer
	PlayerSimulation: PlayerSimulation
	GameSimulation: GameSimulation


