root = exports ? this
root.BbScout ?= {};

PointTypes =
	Freethrow: 1
	Fieldgoal: 2
	Threepointer: 3

root.BbScout.model =
	store:
		games: []

	teams: {}

	Game: class
		constructor: (@teamA, @teamB) ->

		getTeam: (name) ->
			return @teamA if @teamA.name == name
			return @teamB if @teamB.name == name

		score: -> "#{@teamA.points()}:#{@teamB.points()}"

	Team: class
		constructor: (@name) ->
			@playersList = {}
		
		addPlayer: (player) ->
			player.team = @
			@playersList[player.number] = player
		
		getPlayer: (number) ->
			@playersList[number]
		
		points: ->
			sum = 0
			for own number, player of @playersList
				sum += player.points
			sum

	Player: class
		constructor: (@number, @firstName = '', @lastName = '', @points = 0) ->
			@stats =
				Freethrow: {scored: 0, attempted: 0}
				Fieldgoal: {scored: 0, attempted: 0}
				Threepointer: {scored: 0, attempted: 0}
		
		name: -> "#{@firstName} #{@lastName}"
		
		scores: (pointType) ->
			return false unless @validatePointType pointType
			@points += @pointsFor(pointType)
			@stats[pointType].scored++
			@stats[pointType].attempted++
		
		misses: (pointType) ->
			return false unless @validatePointType pointType
			@stats[pointType].attempted++
		
		pointsFor: (pointType) ->
			PointTypes[pointType]

#TODO move into PointTypes
		validatePointType: (pointType) -> PointTypes[pointType]?

		scored: (pointType) ->
			return false unless @validatePointType pointType
			@stats[pointType].scored
		
		attempted: (pointType) ->
			return false unless @validatePointType pointType
			@stats[pointType].attempted

