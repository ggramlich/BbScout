doctype 5
html ->
	head ->
		meta charset: 'utf-8'
		title "#{@title or 'BbScout'}"
		meta(name: 'description', content: @description) if @description?

		link rel: 'stylesheet', href: '/css/bbscout.css'

		script src: '/js/jquery.js'
		script src: '/js/jquery.form.js'
		script src: '/js/pure.js'
		js 'bbscout.js'

	body ->
    header ->
			h1 @title or 'Untitled'
			nav ->
				ul ->
					li -> a '#teamslink', href: '#', -> 'Teams'
					li -> a '#gameslink', href: '#', -> 'Games'
		div '#main', ->

		div '#content', -> @body

		div '#left', ->

		div '#middle', ->

		div '#right', ->

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
							a ->
								span '.number', ->
								text ' '
								span '.name', ->
				
			div '#gamesContainer', ->
				ul '#games', ->
					li '.game', ->
						a ->
							span '.teamA', ->
							text ' : '
							span '.teamB', ->
							text ' ('
							span '.score', ->
							text ')'

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
					p ->
						span '.points', ->
						text ' Points'
					ul '.stats', ->
						li '.Freethrow', ->
							text 'FT'
							span '.scored', ->
							text ' of '
							span '.attempted', ->
						li '.Fieldgoal', ->
							text 'FG'
							span '.scored', ->
							text ' of '
							span '.attempted', ->
						li 'Threepointer', ->
							text '3P'
							span '.scored', ->
							text ' of '
							span '.attempted', ->
