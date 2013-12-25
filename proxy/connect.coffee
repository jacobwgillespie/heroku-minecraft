net = require("net")
WebSocketClient = require("websocket").client

createTunnel = (host, callback) ->

  url = "ws://#{host}/tunnel"

  server = net.createServer (tcpSock) ->

    wsClient = new WebSocketClient()
    webSock = undefined
    buffer = []

    tcpSock.on "data", (data) ->
      if not webSock or buffer.length > 0
        console.log "Buffering TCP Data: #{data}"
        buffer.push data
      else
        # console.log "Sending TCP Data over WebSockets: #{data}"
        webSock.send data

    tcpSock.on "close", ->
      console.log "TCP socket closed"
      if webSock
        webSock.close()
      else
        webSock = null

    wsClient.on "connect", (connection) ->
      console.log "WebSocket connected"

      webSock = connection

      # flush buffer
      while buffer.length > 0
        data = buffer.shift()
        console.log "Flushing buffered data over WebSockets: #{data}"
        webSock.send data

      # check if tcpSock is already closed
      if tcpSock is null
        webSock.close()
        return

      webSock.on "message", (msg) ->
        if msg.type is "utf8"
          data = JSON.parse(msg.utf8Data)
          if data.status is "error"
            console.log data.details
            console.log "Closing WebSocket because of an error"
            webSock.close()
        else
          tcpSock.write msg.binaryData

      webSock.on "close", (reasonCode, description) ->
        console.log "WebSocket closed: #{reasonCode} - #{description}"
        tcpSock.destroy()

    wsClient.on "connectFailed", (err) ->
      console.log "WebSocket connection failed: #{err}"
      tcpSock.destroy()

    console.log "Attempting to open WebSockets connection to #{url}"
    wsClient.connect url

  server.on "error", (err) ->
    callback err

  server.listen 25565, '0.0.0.0', ->
    addr = server.address()
    console.log "TCP server listening on #{addr.address}:#{addr.port}"
    callback null, server if callback


createTunnel process.argv[2], (err, server) ->
  console.log "Local Error: #{String(err)}" if err?
  # else
  #   log "TCP to WebSockets tunnel opened."
