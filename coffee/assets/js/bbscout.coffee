$(document).ready ->
	$('#templates').hide()
	$('#teamslink').click ->
		resetTemplates()
		showTeams()

	$('#gameslink').click ->
		resetTemplates()
		showGames()

resetTemplates = ->
	$('#templates').append $('#teams')
	$('#templates').append $('#games')

showTeams = ->
	loadTeams (teams) ->
		directive =
			li:
				'team<-teams':
					'a': 'team.name'
					'a@href': 'team.uri'

		data = teams: teams
		$('.teams').render data, directive
		$('#teams').show().appendTo $('#left')

loadTeams = (fn) -> $.getJSON '/all_teams/', null, fn

showGames = ->
	loadGames (games) ->
		directive =
			li:
				'game<-games':
					'a@href': 'game.uri'
					'span.teamA': 'game.teamA.name'
					'span.teamB': 'game.teamB.name'
					'span.score': 'game.score'

		data = games: games
		$('.games').render data, directive
		$('#games').show().appendTo $('#left')

loadGames = (fn) -> $.getJSON '/games/', null, fn
