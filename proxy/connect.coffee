net = require("net")
WebSocketClient = require("websocket").client

log = (msg) ->
  console.log msg

createTunnel = (host, callback) ->

  url = "wss://#{host}/tunnel"

  server = net.createServer (tcpSock) ->
    wsClient = new WebSocketClient()
    webSock = undefined
    buffer = []

    tcpSock.on "data", (data) ->
      if not webSock or buffer.length > 0
        log "Buffering TCP Data: #{data}"
        buffer.push data
      else
        log "Sending TCP Data over WebSockets: #{data}"
        webSock.send data

    tcpSock.on "close", ->
      log "TCP socket closed"
      if webSock
        webSock.close()
      else
        webSock = null

    wsClient.on "connect", (connection) ->
      log "WebSocket connected"

      webSock = connection

      # flush buffer
      while buffer.length > 0
        data = buffer.shift()
        log "Flushing buffered data over WebSockets: #{data}"
        webSock.send data

      # check if tcpSock is already closed
      if tcpSock is null
        webSock.close()
        return

      webSock.on "message", (msg) ->
        if msg.type is "utf8"
          data = JSON.parse(msg.utf8Data)
          if data.status is "error"
            log data.details
            log "Closing WebSocket because of an error"
            webSock.close()
        else
          tcpSock.write msg.binaryData

      webSock.on "close", (reasonCode, description) ->
        log "WebSocket closed: #{reasonCode} - #{description}"
        tcpSock.destroy()

    wsClient.on "connectFailed", (err) ->
      log "WebSocket connection failed: #{err}"
      tcpSock.destroy()

    log "Attempting to open WebSockets connection to #{url}"
    wsClient.connect url

  server.on "error", (err) ->
    callback err

  server.listen 25565, '0.0.0.0', ->
    addr = server.address()
    log "TCP server listening on #{addr.address}:#{addr.port}"
    callback null, server if callback


createTunnel process.argv[2], (err, server) ->
  log "Local Error: #{String(err)}" if err?
  # else
  #   log "TCP to WebSockets tunnel opened."
