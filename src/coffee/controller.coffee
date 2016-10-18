mqtt = require 'mqtt'
client = mqtt.connect('mqtt://54.93.150.126', {
  protocolId: 'MQIsdp',
  protocolVersion: 3
})
client.on('connect', ->
  client.subscribe('team1_position')
  client.subscribe('team1_compass')
)
client.on('message', (topic, message)->
  console.log "Message received from topic: #{topic} : \n#{message}"
)
