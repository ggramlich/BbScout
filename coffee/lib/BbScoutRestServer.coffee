require 'express-resource'
express = require 'express'

{games} = require './BbScoutResources'

app = express.createServer()

games = app.resource 'games', games

exports.start = (port) ->
	app.listen port

exports.stop = () ->
	app.close()
