-- /src/scenes/setup-input.lua
local SetupInput = {}
local Input = require 'src.core.input'

-- function SetupInput.init()
-- end

local leftGrip
local rightGrip
local leftTrigger
local rightTrigger
local leftThumbstick
local rightThumbstick
local a
local b
-- local x
local y

function SetupInput.update(dt)
  leftGrip = Input.getAxis("left", "grip")
  leftTrigger = Input.getAxis("left", "trigger")
  rightGrip = Input.getAxis("right", "grip")
  rightTrigger = Input.getAxis("right", "trigger")
  leftThumbstick = Input.getAxis("left", "thumbstick")
  rightThumbstick = Input.getAxis("right", "thumbstick")
  -- a = Input.isDown("right", "a")
  -- b = Input.isDown("right", "b")
  -- -- x = Input.isDown("left", "x")
  -- y = Input.isDown("left", "y")
end

function SetupInput.draw(pass)
  pass:setColor(1, 1, 1)
  pass:text("left controller", -2, 4.5, -5, .5)
  pass:text("trigger: " .. leftTrigger, -2, 4.0, -5, .5)
  pass:text("grip: " .. leftGrip, -2, 3.5, -5, .5)
  -- pass:text("X: " .. x, -2, 3.0, -5, .5)
  -- pass:text("Y: " .. y, -2, 2.5, -5, .5)
  pass:text("thumbstick: " .. leftThumbstick, -2, 2, -5, .5)
  pass:sphere(-2, 1, -5, 0.2)

  pass:text("right controller", 2, 4.5, -5, .5)
  pass:text("trigger: " .. rightTrigger, 2, 4.0, -5, .5)
  pass:text("grip: " .. rightGrip, 2, 3.5, -5, .5)
  -- pass:text("A: " .. a, 2, 3.0, -5, .5)
  -- pass:text("B: " .. b, 2, 2.5, -5, .5)
  pass:text("thumbstick: " .. rightThumbstick, 2, 2, -5, .5)
  pass:sphere(2, 1, -5, 0.2)
end

return SetupInput
