keypress = require 'keypress'
Balloon = require './src/coffee/balloon.coffee'

console.log 'start'
balloon = new Balloon()
balloon.start()

lift = false
forward = false
left = false
right = false
backward = false

console.log 'started'
keypress(process.stdin)

update= ->
  if lift
    balloon.lift()
  else
    balloon.stopVertical()

  if forward
    balloon.forward()
  else if left
    balloon.left()
  else if right
    balloon.right()
  else if backward
    balloon.backward()
  else
    balloon.stopHorizontal()


process.stdin.on('keypress', (ch, key) ->
  #console.log(JSON.stringify(key))
  if key
    if (key.ctrl && key.name == 'c')
      balloon.quit()
      process.stdin.pause()
    else if(key.name == 'escape')
      forward = false
      backward = false
      right = false
      left = false
      lift = false
    else if(key.name == 'space')
      lift = not lift
    else if(key.name == 'up')
      forward = not forward
      backward = false
      right = false
      left = false
    else if(key.name == 'left')
      left = not left
      right = false
      forward = false
      backward = false
    else if(key.name == 'right')
      right = not right
      left = false
      forward = false
      backward = false
    else if(key.name == 'down')
      backward = not backward
      forward = false
      right = false
      left = false
    else if(key.name == 'q')
      balloon.increaseSpeed()
    else if(key.name == 'z')
      balloon.decreaseSpeed()
    else if(key.name == 'a')
      balloon.resetSpeed()
    update()
    console.log(JSON.stringify(balloon.action))
    console.log("Forward: #{forward}\nBackward: #{backward}\nLift: #{lift}\nRight: #{right}\nLeft: #{left}")
)

process.stdin.setRawMode(true)
process.stdin.resume()
