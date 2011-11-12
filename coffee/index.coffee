port = process.env.PORT || 8000
server = require './lib/BbScoutRestServer'
server.start port

console.log "Server started on port #{port}"

model = require('./lib/BbScoutModel').BbScout.model

teamA = new model.Team 'Team A'
teamB = new model.Team 'Team B'
game = new model.Game teamA, teamB

server.addGame game
teamA.addPlayer new model.Player(41, 'Dirk', 'Nowitzki')
teamA.addPlayer new model.Player(99, 'XYZ', '99')

teamX = new model.Team 'Team X'
teamX.addPlayer new model.Player(5, 'Johannes', 'Herber')
server.addTeam teamX

console.log "added a game"
