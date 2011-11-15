$(document).ready ->
	$('#templates').hide()
	$('#templates').children('div').addClass('template')
	compileTemplates()
	$('#teamslink').click ->
		resetTemplates()
		showTeams($('#teamsContainer'))

	$('#gameslink').click ->
		resetTemplates()
		showGames($('#gamesContainer'))

templates = {}

resetTemplates = ->
	$('#templates').append $('.template')

showTeams = ($container) ->
	loadTeams (teams) ->
		data = teams: teams
		$container.html templates['teams'](data)
		$container.appendTo $('#left')
		$container.find('.team a').click (event) ->
			event.preventDefault()
			showTeam $(event.target).attr('href'), $('#teamContainer')
		$container.find('a.add_team').click (event) ->
			event.preventDefault()
			showAddTeamForm "/all_teams/"

	showAddTeamForm = (addteamuri) ->
		$('#addteamContainer').html templates['addteam']('uri': addteamuri)
		$('form.addteam').ajaxForm 
			success: (result) -> showTeams $container

loadTeams = (fn) -> $.getJSON '/all_teams/', null, fn

showTeam = (uri, $container) ->
	loadTeam = (uri, fn) -> $.getJSON uri, null, fn

	loadTeam uri, (team) ->
		$container.html templates['team'](team)
		$container.appendTo $('#middle')
		$container.find('a').click (event) ->
			event.preventDefault()
			showAddPlayerForm "#{uri}/all_players/"

	showAddPlayerForm = (addplayeruri) ->
		$('#addplayerContainer').html templates['addplayer']('uri': addplayeruri)
		$('form.addplayer').ajaxForm 
			success: (result) -> showTeam uri, $container
	
showGames = ($container) ->
	loadGames (games) ->
		data = games: games
		$container.html templates['games'](data)
		$container.appendTo $('#left')

loadGames = (fn) -> $.getJSON '/games/', null, fn


compileTemplates = ->
	directive =
		'a.add_team@href': '/all_teams/'
		'li':
			'team<-teams':
				'a': 'team.name'
				'a@href': 'team.uri'
	templates['teams'] = $('#teams').compile directive

	directive =
		'.name': 'name'
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

	directive =
		'form@action': 'uri'
	templates['addteam'] = $('#addteam').compile directive

	