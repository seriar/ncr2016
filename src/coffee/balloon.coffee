send = require './send.coffee'
ComMgr = require './communication-manager.coffee'

class Balloon
  constructor: () ->
    @running = false
    @step = 25
    @action =
      m1: "0",
      m2: "0",
      m_up: "0",
      command_id: "1",
      time: String (@step)

    @self = this
    @com = new ComMgr('1')
  backward: ->
    #console.log 'reverse'
    @action.m1= "2"
    @action.m2= "2"
  forward: ->
    #console.log 'forward'
    @action.m1= "1"
    @action.m2= "1"
  left: ->
    #console.log 'left'
    @action.m1= "0"
    @action.m2= "1"
  right: ->
    #console.log 'right'
    @action.m1= "1"
    @action.m2= "0"
  lift: ->
    #console.log 'lift'
    @action.m_up = "4"
  stopVertical: ->
    #console.log 'stopping lift'
    @action.m_up = "0"
  stopHorizontal: ->
    #console.log 'stopping thrust'
    @action.m1= "0"
    @action.m2= "0"
  stop: ->
    #console.log 'stopping'
    @action =
      m1: "0",
      m2: "0",
      m_up: "0",
      command_id: "1",
      time: String (@step)

  quit: ->
    console.log 'quitting'
    @action =
      m1: "0",
      m2: "0",
      m_up: "0",
      command_id: "1",
      time: String (@step)

    @running = false
    @com.destroy()
  run:(balloon) ->
    #console.log 'step'
    balloon.com.publish(balloon.action)
    setTimeout ->
      if balloon.running
        balloon.run(balloon)
    , 1000
  start: ->
    @running = true
    this.run(this)
  increaseSpeed: ->
    t = parseInt(@action.time, 10)
    if (t + @step) > 255
      @action.time = 255
    else
      @action.time = String(t + @step)
  decreaseSpeed: ->
    t = parseInt(@action.time, 10)
    if (t - @step < 0)
      @action.time = 0
    else
      @action.time = String(t - @step)
  resetSpeed: ->
    @action.time = String(@step)
module.exports = Balloon
