doctype 5
html ->
	head ->
		meta charset: 'utf-8'
		title "#{@title or 'BbScout'}"
		meta(name: 'description', content: @description) if @description?

		link rel: 'stylesheet', href: '/css/reset.css'
		link rel: 'stylesheet', href: '/css/bbscout.css'

		script src: '/js/jquery.js'
		script src: '/js/jquery.form.js'
		script src: '/js/pure.js'
		js 'bbscout.js'

	body ->
		div '#wrap', ->
			div '#header', ->
				h1 @title or 'Untitled'
				nav ->
					ul ->
						li -> a '#teamslink', href: '#', -> 'Teams'
						li -> a '#gameslink', href: '#', -> 'Games'
			div '#left', ->

			div '#right', ->
			
			div '#footer', ->

		div '#templates', ->
			div '#teamsContainer', ->
				div '#teams', ->
					h2 'Teams'
					div '#addteamContainer', ->
						a '.addteam', -> 'add team'
					ul '.teams', ->
						li '.team', ->
							a ->

			div '#teamContainer', ->
				div '#team', ->
					h2 '.name', ->
					div '#addplayerContainer', ->
						a '.addplayer', -> 'add player'
					ul '.players', ->
						li '.player', ->
							span '.number', ->
							text ' '
							span '.name', ->

			div '#teamingameContainer', ->
				div '.teamingame', ->
					h2 '.name', ->
					ul '.players', ->
						li '.player', ->
							a ->
								span '.number', ->
								text ' '
								span '.name', ->
				
			div '#gamesContainer', ->
				div '#games', ->
					h2 'Games'
					div '#addgameContainer', ->
						a '.addgame', -> 'add game'
					ul '.games', ->
						li '.game', ->
							a ->
								span '.teamA', ->
								text ' : '
								span '.teamB', ->
								br ->
								text '('
								span '.score', ->
								text ')'

			div '#gameContainer', ->
				div '#game', ->
					h2 '.game', ->
						span '.teamA', ->
						text ' : '
						span '.teamB', ->
						br ->
						text '('
						span '.score', ->
						text ')'
					div '#teamA', ->
					div '#teamB', ->
					
					
			div '#addgame', ->
				form '.addgame', action: '#', method: 'post', ->
					select size: '1', name: 'teamA', ->
						option ''
					select size: '1', name: 'teamB', ->
						option ''
					input type: 'submit', value: 'add'

			div '#addplayer', ->
				form '.addplayer', action: '#', method: 'post', ->
					input type: 'text', name: 'number', size: '2' 
					input type: 'text', name: 'firstName', size: '15'
					input type: 'text', name: 'lastName', size: '15'
					input type: 'submit', value: 'add'

			div '#addteam', ->
				form '.addteam', action: '#', method: 'post', ->
					input type: 'text', name: 'name', size: '15' 
					input type: 'submit', value: 'add'

			div '#playerContainer', ->
				div '#player', ->
					h2 '.name', ->
					p '.pointsContainer', ->
						span '.points', ->
						text ' Points'
					ul '.stats', ->
						li '.Freethrow', ->
							span '.category', -> 'FT '
							button '.scores', -> '&otimes;'
							button '.misses', -> '&empty;'
							text ' '
							span '.scored', ->
							text ' of '
							span '.attempted', ->
						li '.Fieldgoal', ->
							span '.category', -> 'FG '
							button '.scores', -> '&otimes;'
							button '.misses', -> '&empty;'
							text ' '
							span '.scored', ->
							text ' of '
							span '.attempted', ->
						li 'Threepointer', ->
							span '.category', -> '3P '
							button '.scores', -> '&otimes;'
							button '.misses', -> '&empty;'
							text ' '
							span '.scored', ->
							text ' of '
							span '.attempted', ->
