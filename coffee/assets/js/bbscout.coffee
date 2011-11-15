$LEFT = $RIGHT = null

loadJSON = (uri, fn) -> $.getJSON uri, null, fn

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
	loadJSON '/all_teams/', (teams) ->
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
			success: -> showTeams $container

showTeam = (uri, $container) ->
	loadJSON uri, (team) ->
		$container.html templates['team'](team)
		$container.appendTo $RIGHT
		$container.find('a.addplayer').click (event) ->
			event.preventDefault()
			showAddPlayerForm "#{uri}/all_players/"

	showAddPlayerForm = (addplayeruri) ->
		$('#addplayerContainer').html templates['addplayer']('uri': addplayeruri)
		$('form.addplayer').ajaxForm 
			success: -> showTeam uri, $container

addPlayerEvent = ($button, fn) ->
	uri = $button.data('uri')
	data =
		action: $button.attr('class')
		argument: $button.closest('li').attr('class')
	$.post uri, data, fn

showGames = ($container) ->
	gamesUri = '/games/'
	loadJSON gamesUri, (games) ->
		data =
			uri: gamesUri
			games: games
		$container.html templates['games'](data)
		$container.appendTo $LEFT
		$container.find('a.addgame').click (event) ->
			event.preventDefault()
			showAddGameForm()

		$container.find('.game a').click (event) ->
			event.preventDefault()
			resetTemplates()
			showGame getLinkUri(event), $('#gameContainer')

		showAddGameForm = ->
			loadJSON 'all_teams', (teams) ->
				data =
					uri: gamesUri
					teams: teams
				$('#addgameContainer').html templates['addgame'](data)
				$('form.addgame').ajaxForm 
					success: -> showGames $container

showGame = (uri, $container) ->
	refreshGame = ->
		loadJSON uri, (game) ->
			$container.html templates['game'](game)
			$container.appendTo $LEFT
			showTeamInGame game.teamA, $('#teamA')
			showTeamInGame game.teamB, $('#teamB')

	showTeamInGame = (team, $container) ->
		loadJSON team.uri, (team) ->
			$container.html $(templates['teamingame'](team))
			$container.find('.player a').click (event) ->
				event.preventDefault()
				showPlayer getLinkUri(event), $('#playerContainer')

	showPlayer = (uri, $container) ->
		loadJSON uri, (player) ->
			$container.html templates['player'](player)
			$container.appendTo $RIGHT
			$container.find('button').data('uri', "#{uri}/events")
			$container.find('button').click (event) ->
				event.preventDefault()
				addPlayerEvent $(event.target).closest('button'), ->
					showPlayer uri, $container
					refreshGame()

	refreshGame()

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
		'a.addgame@href': 'uri'
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

	directive =
		'form@action': 'uri'
		'option':
			'team<-teams':
				'.': 'team.name'
	templates['addgame'] = $('#addgame').compile directive

