# This can be removed after https://github.com/npm/npm/issues/5875 is fixed.
try
  {Adapter,TextMessage,EnterMessage,User} = require 'hubot'
catch
  prequire = require('parent-require')
  {Adapter,TextMessage,EnterMessage,User} = prequire 'hubot'

WebSocket = require('ws')

class WebsocketAdapter extends Adapter
  send: (envelope, strings...) ->
    @robot.logger.debug "send", envelope, strings
    envelope.room.send str for str in strings

  reply: (envelope, strings...) ->
    @robot.logger.debug "reply", envelope, strings
    envelope.room.send str for str in strings

  run: ->
    port = if process.env.HUBOT_WEBSOCKET_PORT then process.env.HUBOT_WEBSOCKET_PORT else 8081

    server = new WebSocket.Server port: port

    server.on "connection", (socket) =>
      user = new User "user-id", room: socket
      @receive new EnterMessage(user)
      @robot.logger.debug "Enter: %s", user.id

      @receive new TextMessage(user, "#{@robot.name} help")

      socket.on "message", (msg) =>
        @robot.logger.debug "Message[%s]: %s", user.id, msg
        @receive new TextMessage(user, msg)

    @robot.logger.info "Running websocket server on port %s", port
    @emit 'connected'

# Export class for unit tests
module.exports = WebsocketAdapter
