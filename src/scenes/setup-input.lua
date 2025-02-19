-- /src/scenes/setup-input.lua
local SetupInput = {}
local Input = require 'src.core.input'
local Grid = require 'src.entities.grid'
local Player = require 'src.entities.player'

local leftGrip
local rightGrip
local leftTrigger
local rightTrigger
local aButton
local bButton
local xButton
local yButton
local leftSphereScale
local rightSphereScale
local thumbstickLeft
local thumbstickRight

function SetupInput.update(dt)
  Input.update(dt)

  -- Grip
  leftGrip = Input.getValue('grabLeft')
  rightGrip = Input.getValue('grabRight')

  -- Trigger
  leftTrigger = Input.getValue('triggerLeft')
  rightTrigger = Input.getValue('triggerRight')

  -- A B X Y
  aButton = Input.getValue('a') and '1' or '0'
  bButton = Input.getValue('b') and '1' or '0'
  xButton = Input.getValue('x') and '1' or '0'
  yButton = Input.getValue('y') and '1' or '0'

  -- Thumbstick
  thumbstickLeft = Input.getValue('move')
  thumbstickRight = Input.getValue('thumbstickRight')

  -- Thumbstick click
  leftSphereScale = Input.getValue('thumbstickClickLeft') and 0.15 or 0.2
  rightSphereScale = Input.getValue('thumbstickClickRight') and 0.15 or 0.2
end

function SetupInput.draw(pass)
  pass:setShader()
  pass:setColor(1, 1, 1)
  pass:text("left controller", -2, 4.5, -5, .5)
  pass:text("trigger: " .. leftTrigger, -2, 4.0, -5, .5)
  pass:text("grip: " .. leftGrip, -2, 3.5, -5, .5)
  pass:text("Y: " .. yButton, -2, 3.0, -5, .5)
  pass:text("X: " .. xButton, -2, 2.5, -5, .5)
  pass:sphere(-2 + thumbstickLeft.x, 1 + thumbstickLeft.y, -5, leftSphereScale)

  pass:text("right controller", 2, 4.5, -5, .5)
  pass:text("trigger: " .. rightTrigger, 2, 4.0, -5, .5)
  pass:text("grip: " .. rightGrip, 2, 3.5, -5, .5)
  pass:text("B: " .. bButton, 2, 3.0, -5, .5)
  pass:text("A: " .. aButton, 2, 2.5, -5, .5)
  pass:sphere(2 + thumbstickRight.x, 1 + thumbstickRight.y, -5, rightSphereScale)
  Grid.draw(pass)
end

return SetupInput
