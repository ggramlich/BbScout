$LEFT = $RIGHT = null

$(document).ready ->
	$LEFT = $('#left')
	$RIGHT = $('#right')
	$('#templates').hide()
	$('#templates').children('div').addClass('template')
	compileTemplates()
	$('#teamslink').click ->
		resetTemplates()
		showTeams $('#teamsContainer')

	$('#gameslink').click ->
		resetTemplates()
		showGames $('#gamesContainer')

templates = {}

resetTemplates = ->	$('#templates').append $('.template')

clearTemplatesIn = ($block) -> $('#templates').append $block.find('.template')

getLinkUri = (event) -> $(event.target).closest('a').attr('href')

showTeams = ($container) ->
	loadTeams (teams) ->
		data = teams: teams
		$container.html templates['teams'](data)
		$container.appendTo $LEFT
		$container.find('.team a').click (event) ->
			event.preventDefault()
			clearTemplatesIn $RIGHT
			showTeam getLinkUri(event), $('#teamContainer')
		$container.find('a.addteam').click (event) ->
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
		$container.appendTo $RIGHT
		$container.find('a.addplayer').click (event) ->
			event.preventDefault()
			showAddPlayerForm "#{uri}/all_players/"

	showAddPlayerForm = (addplayeruri) ->
		$('#addplayerContainer').html templates['addplayer']('uri': addplayeruri)
		$('form.addplayer').ajaxForm 
			success: (result) -> showTeam uri, $container

showPlayer = (uri, $container) ->
	loadPlayer uri, (player) ->
		$container.html templates['player'](player)
		$container.appendTo $RIGHT
		$container.find('button').data('uri', "#{uri}/events")
		$container.find('button').click (event) ->
			event.preventDefault()
			addPlayerEvent $(event.target).closest('button'), ->
				showPlayer uri, $container

loadPlayer = (uri, fn) -> $.getJSON uri, null, fn

addPlayerEvent = ($button, fn) ->
	uri = $button.data('uri')
	data =
		action: $button.attr('class')
		argument: $button.closest('li').attr('class')
	$.post uri, data, fn

showGames = ($container) ->
	loadGames (games) ->
		data = games: games
		$container.html templates['games'](data)
		$container.appendTo $LEFT
		$container.find('.game a').click (event) ->
			event.preventDefault()
			clearTemplatesIn $RIGHT
			showGame getLinkUri(event), $('#gameContainer')

loadGames = (fn) -> $.getJSON '/games/', null, fn

showGame = (uri, $container) ->
	loadGame = (uri, fn) -> $.getJSON uri, null, fn

	loadTeam = (uri, $teamContainer, fn) -> $.getJSON uri, null, fn

	loadGame uri, (game) ->
		$container.html templates['game'](game)
		$container.appendTo $LEFT
		showTeamInGame game.teamA, $('#teamA')
		showTeamInGame game.teamB, $('#teamB')

showTeamInGame = (team, $container) ->
	loadTeam = (uri, fn) -> $.getJSON uri, null, fn

	loadTeam team.uri, (team) ->
		$container.html $(templates['teamingame'](team))
		$container.find('.player a').click (event) ->
			event.preventDefault()
			showPlayer getLinkUri(event), $('#playerContainer')

compileTemplates = ->
	directive =
		'a.addteam@href': '/all_teams/'
		'li':
			'team<-teams':
				'a': 'team.name'
				'a@href': 'team.uri'
	templates['teams'] = $('#teams').compile directive

	directive =
		'.name': 'name'
		'li':
			'player<-players':
				'span.number': 'player.number'
				'span.name': 'player.name'
				'a@href': 'player.uri'
	templates['teamingame'] = $('#teamingame').compile directive

	directive =
		'.name': 'name'
		'a.addplayer@href': 'uri'
		'li':
			'player<-players':
				'span.number': 'player.number'
				'span.name': 'player.name'
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
		'span.teamA': 'teamA.name'
		'span.teamB': 'teamB.name'
		'span.score': 'score'

	templates['game'] = $('#game').compile directive

	directive =
		'.name': 'name'
		'span.points': 'points'
		'li.Freethrow span.scored': 'stats.Freethrow.scored'
		'li.Freethrow span.attempted': 'stats.Freethrow.attempted'
		'li.Fieldgoal span.scored': 'stats.Fieldgoal.scored'
		'li.Fieldgoal span.attempted': 'stats.Fieldgoal.attempted'
		'li.Threepointer span.scored': 'stats.Threepointer.scored'
		'li.Threepointer span.attempted': 'stats.Threepointer.attempted'

	templates['player'] = $('#player').compile directive

	directive =
		'form@action': 'uri'
	templates['addplayer'] = $('#addplayer').compile directive

	directive =
		'form@action': 'uri'
	templates['addteam'] = $('#addteam').compile directive

	