port = process.env.PORT || 8000
server = require './lib/BbScoutRestServer'
server.start port

console.log "Server started on port #{port}"

model = require('./lib/BbScoutModel').BbScout.model

teamA = new model.Team 'Dallas Mavericks'
teamB = new model.Team 'Miami Heat'
game = new model.Game teamA, teamB

server.addGame game
teamA.addPlayer new model.Player 41, 'Dirk', 'Nowitzki'
teamA.addPlayer new model.Player 0, 'Shawn', 'Marion'
teamA.addPlayer new model.Player 20, 'Dominique', 'Jones'
teamA.addPlayer new model.Player 2, 'Jason', 'Kidd'
teamA.addPlayer new model.Player 4, 'Caron', 'Butler'

teamB.addPlayer new model.Player 6, 'LeBron', 'James'
teamB.addPlayer new model.Player 5, 'Juwan', 'Howard'
teamB.addPlayer new model.Player 15, 'Mario', 'Chalmers'
teamB.addPlayer new model.Player 22, 'James', 'Jones'
teamB.addPlayer new model.Player 3, 'Dwyane', 'Wade'

console.log "added a game"

teamX = new model.Team 'Deutschland'
teamX.addPlayer new model.Player 5, 'Johannes', 'Herber'
server.addTeam teamX

console.log 'added team'
console.dir teamX

