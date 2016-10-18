mqtt = require 'mqtt'
class ComMgr
  constructor: (group, client) ->
    if client == undefined
      console.log "creating client..."
      @client = mqtt.connect('mqtt://54.93.150.126', {
        protocolId: 'MQIsdp',
        protocolVersion: 3
      })
    else
      console.log "using given client..."
      @client = client
    @readTopic = "team#{group}_read"
    @writeTopic = "team#{group}_write"
    console.log "using topics : \nread: #{@readTopic} \nwrite:#{@writeTopic}"
  subscribe:(all) ->
    console.log 'subscribing all' if all?
    @client.on('connect', ->
      @client.subscribe(@readTopic)
      @client.subscribe(@writeTopic) if all?
    )
    @client.on('message', (topic, message)->
      console.log "Message received from topic: #{topic} : \n#{JSON.stringify message}"
    )

  publish: (msg) ->
    message = JSON.stringify msg
    #console.log "sending message: #{message}"
    @client.publish(@writeTopic, message)

  destroy: ->
    @client.end()

module.exports = ComMgr
