doctype 5
html ->
	head ->
		meta charset: 'utf-8'
		title "#{@title or 'BbScout'}"
		meta(name: 'description', content: @description) if @description?

		link rel: 'stylesheet', href: '/css/bbscout.css'

		script src: '/js/jquery.js'
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
			div '#teams', ->
				ul '.teams', ->
					li '.team', ->
						a ->

			div '#games', ->
				ul '.games', ->
					li '.game', ->
						a ->
							span '.teamA', ->
							text ' : '
							span '.teamB', ->
							text ' ('
							span '.score', ->
							text ')'
