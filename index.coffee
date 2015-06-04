WebsocketAdapter = require './src/websocket'

exports.use = (robot) ->
  new WebsocketAdapter(robot)
