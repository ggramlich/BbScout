port = process.env.PORT || 8000
server = require './lib/BbScoutRestServer'
server.start port

console.log "Server started on port #{port}"
