$(document).ready ->
	$('#templates').hide()
	$('#templates').children('div').addClass('template')
	compileTemplates()
	$('#teamslink').click ->
		resetTemplates()
		showTeams()

	$('#gameslink').click ->
		resetTemplates()
		showGames()

templates = {}

compileTemplates = ->
	directive =
		'li':
			'team<-teams':
				'a': 'team.name'
				'a@href': 'team.uri'
	templates['teams'] = $('.teams').compile directive

	directive =
		'.name': 'name'
		'.points': 'points'
		'a.add_player@href': 'uri'
		'li':
			'player<-players':
				'span.number': 'player.number'
				'span.name': 'player.name'
				'a@href': 'player.uri'
	templates['team'] = $('#team').compile directive

resetTemplates = ->
	$('#templates').append $('.template')

showTeams = ->
	loadTeams (teams) ->
		data = teams: teams
		$('#teams').html templates['teams'](data)
		$('#teams').appendTo $('#left')
		$('.teams').find('a').click (event) ->
			event.preventDefault()
			showTeam $(event.target).attr('href')

loadTeams = (fn) -> $.getJSON '/all_teams/', null, fn

showTeam = (uri) ->
	loadTeam uri, (team) ->

		console.log team.players[0]
		$('#team').html templates['team'](team)
		$('#team').show().appendTo $('#middle')

loadTeam = (uri, fn) -> $.getJSON uri, null, fn

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
		$('#games').appendTo $('#left')

loadGames = (fn) -> $.getJSON '/games/', null, fn
