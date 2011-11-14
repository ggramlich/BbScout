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

resetTemplates = ->
	$('#templates').append $('.template')

showTeams = ->
	loadTeams (teams) ->
		data = teams: teams
		$('#teamsContainer').html templates['teams'](data)
		$('#teamsContainer').appendTo $('#left')
		$('#teams').find('a').click (event) ->
			event.preventDefault()
			showTeam $(event.target).attr('href')

loadTeams = (fn) -> $.getJSON '/all_teams/', null, fn

showTeam = (uri) ->
	loadTeam = (uri, fn) -> $.getJSON uri, null, fn

	loadTeam uri, (team) ->
		$('#teamContainer').html templates['team'](team)
		$('#teamContainer').appendTo $('#middle')
		$('#teamContainer').find('a').click (event) ->
			event.preventDefault()
			showAddPlayerForm "#{uri}/all_players/"

	showAddPlayerForm = (addplayeruri) ->
		$('#addplayerContainer').html templates['addplayer']('uri': addplayeruri)
		$('form.addplayer').ajaxForm 
			success: (result) -> showTeam uri
	
showGames = ->
	loadGames (games) ->
		data = games: games
		$('#gamesContainer').html templates['games'](data)
		$('#gamesContainer').appendTo $('#left')

loadGames = (fn) -> $.getJSON '/games/', null, fn


compileTemplates = ->
	directive =
		'li':
			'team<-teams':
				'a': 'team.name'
				'a@href': 'team.uri'
	templates['teams'] = $('#teams').compile directive

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

	directive =
		'li':
			'game<-games':
				'a@href': 'game.uri'
				'span.teamA': 'game.teamA.name'
				'span.teamB': 'game.teamB.name'
				'span.score': 'game.score'

	templates['games'] = $('#games').compile directive

	directive =
		'form@action': 'uri'
	templates['addplayer'] = $('#addplayer').compile directive

