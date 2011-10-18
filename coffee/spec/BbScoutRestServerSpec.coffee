restServer = require 'BbScoutRestServer'
request = require('request')

port = 8001

games_uri = "http://localhost:#{port}/games/"

describe 'The REST server', ->
	beforeEach ->
		restServer.start(port)

	afterEach ->
		restServer.stop()

	it 'responds on the games resource', ->
		request uri: games_uri, (req, resp) ->
			expect(resp.statusCode).toEqual(200)
			asyncSpecDone()
		asyncSpecWait()
