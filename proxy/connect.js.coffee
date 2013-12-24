net = require("net")
WebSocketClient = require("websocket").client

createTunnel = (host, callback) ->

  url = "wss://#{host}/tunnel"

  server = net.createServer (tcpSock) ->
    wsClient = new WebSocketClient()
    webSock = undefined
    buffer = []

    tcpSock.on "data", (data) ->
      if not webSock or buffer.length
        buffer.push data
      else
        webSock.send data

    tcpSock.on "close", ->
      console.log "TCP socket closed"
      if webSock
        webSock.close()
      else
        webSock = null

    wsClient.on "connect", (connection) ->
      console.log "WebSocket connected"
      connection.send buffer.shift()  while buffer.length
      if webSock is null
        connection.close()
        return
      webSock = connection
      webSock.on "message", (msg) ->
        if msg.type is "utf8"
          data = JSON.parse(msg.utf8Data)
          if data.status is "error"
            console.log data.details
            webSock.close()
        else
          tcpSock.write msg.binaryData

      webSock.on "close", (reasonCode, description) ->
        console.log "WebSocket closed; " + reasonCode + "; " + description
        tcpSock.destroy()


    wsClient.on "connectFailed", (err) ->
      console.log "WebSocket connection failed: " + err
      tcpSock.destroy()

    wsClient.connect url

  server.on "error", (err) ->
    callback err

  server.listen 25565, '0.0.0.0', ->
    addr = server.address()
    console.log "listening on " + addr.address + ":" + addr.port
    callback null, server if callback


createTunnel process.argv[2], (err, server) ->
  if err
    console.log "Local Error: #{String(err)}"
  else
    console.log "Tunnel open..."
