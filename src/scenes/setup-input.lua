-- /src/scenes/setup-input.lua
local SetupInput = {}
local Input = require 'src.core.input'

-- function SetupInput.init()
-- end

local leftGrip
local rightGrip
local leftTrigger
local rightTrigger
local leftThumbstickX
local leftThumbstickY
local rightThumbstickX
local rightThumbstickY
local aButton
local bButton
local xButton
local yButton
local leftTouchpad
local rightTouchpad
local leftThumbstickButton
local rightThumbstickButton
local leftSphereScale
local rightSphereScale

function SetupInput.update(dt)
  leftGrip = Input.getAxis("left", "grip")
  leftTrigger = Input.getAxis("left", "trigger")
  rightGrip = Input.getAxis("right", "grip")
  rightTrigger = Input.getAxis("right", "trigger")
  leftThumbstickX, leftThumbstickY = Input.getAxis("left", "thumbstick")
  rightThumbstickX, rightThumbstickY = Input.getAxis("right", "thumbstick")

  -- A B X Y
  if Input.isDown("right", "a") then
    aButton = "1"
  else
    aButton = "0"
  end
  if Input.isDown("right", "b") then
    bButton = "1"
  else
    bButton = "0"
  end
  if Input.isDown("left", "x") then
    xButton = "1"
  else
    xButton = "0"
  end
  if Input.isDown("left", "y") then
    yButton = "1"
  else
    yButton = "0"
  end

  -- Thumbstick click
  if Input.isDown("left", "thumbstick") then
    leftSphereScale = 0.15
  else
    leftSphereScale = 0.2
  end
  if Input.isDown("right", "thumbstick") then
    rightSphereScale = 0.15
  else
    rightSphereScale = 0.2
  end

  -- Touchpad
  -- Doesn't work on Oculus Rift CV1 controllers
  if Input.isDown("left", "touchpad") then
    leftTouchpad = "1"
  else
    leftTouchpad = "0"
  end
  if Input.isDown("right", "touchpad") then
    rightTouchpad = "1"
  else
    rightTouchpad = "0"
  end

end

function SetupInput.draw(pass)
  pass:setColor(1, 1, 1)
  pass:text("left controller", -2, 4.5, -5, .5)
  pass:text("trigger: " .. leftTrigger, -2, 4.0, -5, .5)
  pass:text("grip: " .. leftGrip, -2, 3.5, -5, .5)
  pass:text("Y: " .. yButton, -2, 3.0, -5, .5)
  pass:text("X: " .. xButton, -2, 2.5, -5, .5)
  pass:text("touchpad: " .. leftTouchpad, -2, 2, -5, .5 )
  pass:sphere(-2 + leftThumbstickX, 1 + leftThumbstickY, -5, leftSphereScale)

  pass:text("right controller", 2, 4.5, -5, .5)
  pass:text("trigger: " .. rightTrigger, 2, 4.0, -5, .5)
  pass:text("grip: " .. rightGrip, 2, 3.5, -5, .5)
  pass:text("B: " .. bButton, 2, 3.0, -5, .5)
  pass:text("A: " .. aButton, 2, 2.5, -5, .5)
  pass:text("touchpad: " .. rightTouchpad, 2, 2, -5, .5 )
  pass:sphere(2 + rightThumbstickX, 1 + rightThumbstickY, -5, rightSphereScale)
end

return SetupInput
