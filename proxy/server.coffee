WebSocketServer = require("websocket").server
http = require("http")
net = require("net")
urlParse = require("url").parse

webserver_port = process.env.MC_HEROKU_SERVER_PORT || 8080
minecraft_server_host = "0.0.0.0"
minecraft_server_port = 25566

httpServer = http.createServer (request, response) ->
  console.log "Received request for #{request.url}"
  response.writeHead 404, {"Content-Type": "text/plain"}
  response.end("This is not exactly an HTTP server.\n")

httpServer.listen webserver_port, ->
  console.log "Socket proxy server is listening on port #{webserver_port}"

webSocketServer = new WebSocketServer
  httpServer: httpServer
  autoAcceptConnections: no

originIsAllowed = (origin) -> yes

webSocketServer.on "request", (request) ->

  url = urlParse(request.resource, true)
  args = url.pathname.split("/").slice(1)
  action = args.shift()

  unless action is "tunnel"
    console.log "Rejecting request for #{action} with 404"
    request.reject(404)
    return

  console.log(
    "Trying to create a TCP to WebSocket tunnel for " +
    "#{minecraft_server_host}:#{minecraft_server_port}"
  )

  webSocketConnection = request.accept()

  console.log(
    "#{webSocketConnection.remoteAddress} connected - " +
    "Protocol Version #{webSocketConnection.websocketVersion}"
  )

  tcpSocketConnection = new net.Socket()

  tcpSocketConnection.on "error", (err) ->
    webSocketConnection.send JSON.stringify
      status: "error"
      details: "Upstream socket error; " + err

  tcpSocketConnection.on "data", (data) ->
    webSocketConnection.send data

  tcpSocketConnection.on "close", ->
    webSocketConnection.close()

  tcpSocketConnection.connect minecraft_server_port, minecraft_server_host, ->
    webSocketConnection.on "message", (msg) ->
      if msg.type is "utf8"
        console.log "received utf message: #{msg.utf8Data}"
      else
        tcpSocketConnection.write msg.binaryData

    console.log(
      "Upstream socket connected for #{webSocketConnection.remoteAddress}"
    )
    webSocketConnection.send JSON.stringify
      status: "ready"
      details: "Upstream socket connected"

  webSocketConnection.on "close", ->
    tcpSocketConnection.destroy()
    console.log "#{webSocketConnection.remoteAddress} disconnected"
