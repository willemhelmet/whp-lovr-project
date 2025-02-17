-- scr/core/input.lua
--[[
--
--  What i want here is a system that can handle a large variety of inputs
--  from various modalities.
--  For instance, I want to get all types of button input from:
--    VR controllers,
--    Hand tracking,
--    Keyboard,
--    Mouse
--  I think for the time being I should focus only on the keyboard, and then VR controllers
--]]
local lovr = require 'lovr'
local Input = {}

local threshold = 0.2;

Input.bindings = {
  moveForward = {
    'w',
    'up',
  },
  moveBackward = {
    's',
    'down',
  },
  moveLeft = {
    'a',
    'left',
  },
  moveRight = {
    'd',
    'right',
  },
  turnLeft = {

  },
  turnRight = {

  },
  a = { 'a' },
  b = { 'b' },
  x = { 'x' },
  y = { 'y' },
  quit = { 'escape' },
}

Input.states = {}

-- WHP: I question if this is the right way to go about things
function Input.isPressed(action)
  for _, key in ipairs(Input.bindings[action] or {}) do
    -- handle keyboard input
    if type(key) == "string" then
      if lovr.system.isKeyDown(key) then
        return true
      end
      -- Handle VR analog input (treat as boolean press)
      if type(key) == "table" and key.device and key.axis then
        local x, y = lovr.headset.getAxis(key.device, key.axis)
        local value = key.component == "x" and x or y
        if math.abs(value) > 0.2 then -- Small deadzone to avoid drift
          return true
        end
      end
    end
  end
  return false
end

-- WHP: I like how this is just a simple wrapper of lovr's headset API
function Input.getAxis(device, axis)
  return lovr.headset.getAxis(device, axis)
end

-- WHP: This returns a boolean... is that what i want?
function Input.isDown(device, button)
  return lovr.headset.isDown(device, button)
end

-- function Input.update()
--   for action, keys in pairs(Input.bindings) do
--     Input.states[action] = Input.isPressed(action)
--   end
-- end

return Input
