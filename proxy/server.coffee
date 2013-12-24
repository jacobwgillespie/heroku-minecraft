WebSocketServer = require("websocket").server
http = require("http")
net = require('net')
urlParse = require('url').parse

heroku_webserver_port = process.env.MC_HEROKU_SERVER_PORT || 8080

httpServer = http.createServer (request, response) ->
  console.log "Received request for #{request.url}"
  response.writeHead 404
  response.end()

httpServer.listen heroku_webserver_port, ->
  console.log "Socket proxy server is listening on port #{heroku_webserver_port}"

webSocketServer = new WebSocketServer
  httpServer: httpServer
  # autoAcceptConnections: yes

originIsAllowed = (origin) -> yes

webSocketServer.on "request", (request) ->

  url = urlParse(request.resource, true)
  args = url.pathname.split("/").slice(1)
  action = args.shift()
  # params = url.query

  unless action is 'tunnel'
    console.log "Rejecting request for #{action} with 404"
    request.reject(404)
    return

  console.log "Trying to create a TCP to WebSocket tunnel for #{host}:#{port}"

  webSocketConnection = request.accept()

  console.log "#{webSocketConnection.remoteAddress} connected - Protocol Version #{webSocketConnection.websocketVersion}"

  tcpSocketConnection = new net.Socket()

  tcpSocketConnection.on "error", (err) ->
    webSocketConnection.send JSON.stringify
      status: "error"
      details: "Upstream socket error; " + err

  tcpSocketConnection.on "data", (data) ->
    webSocketConnection.send data

  tcpSocketConnection.on "close", ->
    webSocketConnection.close()

  tcpSocketConnection.connect 25566, "localhost", ->
    webSocketConnection.on "message", (msg) ->
      if msg.type is 'utf8'
        console.log "received utf message: #{msg.utf8Data}"
        # tcpSocketConnection.write msg.binaryData
      else
        console.log "received binary message of length #{msg.binaryData.length}"
        tcpSocketConnection.write msg.binaryData

    console.log "Upstream socket connected for #{webSocketConnection.remoteAddress}"
    webSocketConnection.send JSON.stringify
      status: "ready"
      details: "Upstream socket connected"

  webSocketConnection.on "close", ->
    tcpSocketConnection.destroy()
    console.log "#{webSocketConnection.remoteAddress} disconnected"
